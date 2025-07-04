/*
 * This file is part of the SylCore Project. See AUTHORS file for Copyright information
 *
 * Copyright (C) 2016-2025 AzerothCore <www.azerothcore.org>
 * Copyright (C) 2025 SylCore
 * 
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Affero General Public License as published by the
 * Free Software Foundation; either version 3 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "DBCStores.h"
#include "GameObjectAI.h"
#include "Log.h"
#include "ObjectMgr.h"
#include "Opcodes.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "Spell.h"
#include "SpellAuraEffects.h"
#include "SpellAuras.h"
#include "SpellMgr.h"
#include "Totem.h"
#include "TotemPackets.h"
#include "Vehicle.h"
#include "WorldPacket.h"
#include "WorldSession.h"

void WorldSession::HandleClientCastFlags(WorldPacket& recvPacket, uint8 castFlags, SpellCastTargets& targets)
{
    // some spell cast packet including more data (for projectiles?)
    if (castFlags & 0x02)
    {
        // not sure about these two
        float elevation, speed;
        recvPacket >> elevation;
        recvPacket >> speed;

        targets.SetElevation(elevation);
        targets.SetSpeed(speed);

        uint8 hasMovementData;
        recvPacket >> hasMovementData;
        if (hasMovementData)
        {
            recvPacket.SetOpcode(recvPacket.read<uint32>());
            HandleMovementOpcodes(recvPacket);
        }
    }
}

void WorldSession::HandleUseItemOpcode(WorldPacket& recvPacket)
{
    /// @todo: add targets.read() check
    Player* pUser = _player;

    // ignore for remote control state
    if (pUser->m_mover != pUser)
        return;

    uint8 bagIndex, slot, castFlags;
    uint8 castCount;                                       // next cast if exists (single or not)
    ObjectGuid itemGUID;
    uint32 glyphIndex;                                      // something to do with glyphs?
    uint32 spellId;                                         // casted spell id

    recvPacket >> bagIndex >> slot >> castCount >> spellId >> itemGUID >> glyphIndex >> castFlags;

    if (glyphIndex >= MAX_GLYPH_SLOT_INDEX)
    {
        pUser->SendEquipError(EQUIP_ERR_ITEM_NOT_FOUND, nullptr, nullptr);
        return;
    }

    Item* pItem = pUser->GetUseableItemByPos(bagIndex, slot);
    if (!pItem)
    {
        pUser->SendEquipError(EQUIP_ERR_ITEM_NOT_FOUND, nullptr, nullptr);
        return;
    }

    SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(spellId);

    if (!spellInfo)
    {
        LOG_ERROR("network.opcode", "WORLD: unknown spell id {}", spellId);
        recvPacket.rfinish(); // prevent spam at ignore packet
        return;
    }

    // fail if we are cancelling pending request
    if (!_player->SpellQueue.empty())
    {
        PendingSpellCastRequest& request = _player->SpellQueue.front(); // Peek at the first spell
        if (request.cancelInProgress)
        {
            pUser->SendEquipError(EQUIP_ERR_NONE, pItem, nullptr);
            recvPacket.rfinish(); // prevent spam at ignore packet
            return;
        }
    }

    // try queue spell if it can't be executed right now
    if (!_player->CanExecutePendingSpellCastRequest(spellInfo))
        if (_player->CanRequestSpellCast(spellInfo))
        {
            WorldPacket packetCopy(recvPacket); // Copy the packet
            packetCopy.rpos(0); // Reset read position to the start of the buffer.
            _player->SpellQueue.emplace_back(
                spellId,
                spellInfo->GetCategory(),
                std::move(packetCopy), // Move ownership of copied packet
                true // itemCast
            );
            return;
        }

    if (pItem->GetGUID() != itemGUID)
    {
        pUser->SendEquipError(EQUIP_ERR_ITEM_NOT_FOUND, nullptr, nullptr);
        return;
    }

    LOG_DEBUG("network", "WORLD: CMSG_USE_ITEM packet, bagIndex: {}, slot: {}, castCount: {}, spellId: {}, Item: {}, glyphIndex: {}, data length = {}", bagIndex, slot, castCount, spellId, pItem->GetEntry(), glyphIndex, (uint32)recvPacket.size());

    ItemTemplate const* proto = pItem->GetTemplate();
    if (!proto)
    {
        pUser->SendEquipError(EQUIP_ERR_ITEM_NOT_FOUND, pItem, nullptr);
        return;
    }

    // some item classes can be used only in equipped state
    if (proto->InventoryType != INVTYPE_NON_EQUIP && !pItem->IsEquipped())
    {
        pUser->SendEquipError(EQUIP_ERR_ITEM_NOT_FOUND, pItem, nullptr);
        return;
    }

    InventoryResult msg = pUser->CanUseItem(pItem);
    if (msg != EQUIP_ERR_OK)
    {
        pUser->SendEquipError(msg, pItem, nullptr);
        return;
    }

    // only allow conjured consumable, bandage, poisons (all should have the 2^21 item flag set in DB)
    if (proto->Class == ITEM_CLASS_CONSUMABLE && !proto->HasFlag(ITEM_FLAG_IGNORE_DEFAULT_ARENA_RESTRICTIONS) && pUser->InArena())
    {
        pUser->SendEquipError(EQUIP_ERR_NOT_DURING_ARENA_MATCH, pItem, nullptr);
        return;
    }

    // don't allow items banned in arena
    if (proto->HasFlag(ITEM_FLAG_NOT_USEABLE_IN_ARENA) && pUser->InArena())
    {
        pUser->SendEquipError(EQUIP_ERR_NOT_DURING_ARENA_MATCH, pItem, nullptr);
        return;
    }

    if (pUser->IsInCombat())
    {
        for (int i = 0; i < MAX_ITEM_PROTO_SPELLS; ++i)
        {
            if (SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(proto->Spells[i].SpellId))
            {
                if (!spellInfo->CanBeUsedInCombat())
                {
                    pUser->SendEquipError(EQUIP_ERR_NOT_IN_COMBAT, pItem, nullptr);
                    return;
                }
            }
        }
    }

    // check also  BIND_WHEN_PICKED_UP and BIND_QUEST_ITEM for .additem or .additemset case by GM (not binded at adding to inventory)
    if (pItem->GetTemplate()->Bonding == BIND_WHEN_USE || pItem->GetTemplate()->Bonding == BIND_WHEN_PICKED_UP || pItem->GetTemplate()->Bonding == BIND_QUEST_ITEM)
    {
        if (!pItem->IsSoulBound())
        {
            pItem->SetState(ITEM_CHANGED, pUser);
            pItem->SetBinding(true);
        }
    }

    SpellCastTargets targets;
    targets.Read(recvPacket, pUser);
    HandleClientCastFlags(recvPacket, castFlags, targets);

    // Note: If script stop casting it must send appropriate data to client to prevent stuck item in gray state.
    if (!sScriptMgr->OnItemUse(pUser, pItem, targets))
    {
        // no script or script not process request by self
        pUser->CastItemUseSpell(pItem, targets, castCount, glyphIndex);
    }
}

void WorldSession::HandleOpenItemOpcode(WorldPacket& recvPacket)
{
    LOG_DEBUG("network", "WORLD: CMSG_OPEN_ITEM packet, data length = {}", (uint32)recvPacket.size());

    Player* pUser = _player;

    // ignore for remote control state
    if (pUser->m_mover != pUser)
        return;

    // xinef: additional check, client outputs message on its own
    if (!pUser->IsAlive())
    {
        pUser->SendEquipError(EQUIP_ERR_YOU_ARE_DEAD, nullptr, nullptr);
        return;
    }

    uint8 bagIndex, slot;

    recvPacket >> bagIndex >> slot;

    LOG_DEBUG("network.opcode", "bagIndex: {}, slot: {}", bagIndex, slot);

    Item* item = pUser->GetItemByPos(bagIndex, slot);
    if (!item)
    {
        pUser->SendEquipError(EQUIP_ERR_ITEM_NOT_FOUND, nullptr, nullptr);
        return;
    }

    ItemTemplate const* proto = item->GetTemplate();
    if (!proto)
    {
        pUser->SendEquipError(EQUIP_ERR_ITEM_NOT_FOUND, item, nullptr);
        return;
    }

    // Verify that the bag is an actual bag or wrapped item that can be used "normally"
    if (!proto->HasFlag(ITEM_FLAG_HAS_LOOT) && !item->IsWrapped())
    {
        pUser->SendEquipError(EQUIP_ERR_CANT_DO_RIGHT_NOW, item, nullptr);
        LOG_ERROR("network.opcode", "Possible hacking attempt: Player {} [{}] tried to open item [{}, entry: {}] which is not openable!",
                       pUser->GetName(), pUser->GetGUID().ToString(), item->GetGUID().ToString(), proto->ItemId);
        return;
    }

    // locked item
    uint32 lockId = proto->LockID;
    if (lockId)
    {
        LockEntry const* lockInfo = sLockStore.LookupEntry(lockId);

        if (!lockInfo)
        {
            pUser->SendEquipError(EQUIP_ERR_ITEM_LOCKED, item, nullptr);
            LOG_ERROR("network.opcode", "WORLD::OpenItem: item [{}] has an unknown lockId: {}!", item->GetGUID().ToString(), lockId);
            return;
        }

        // was not unlocked yet
        if (item->IsLocked())
        {
            pUser->SendEquipError(EQUIP_ERR_ITEM_LOCKED, item, nullptr);
            return;
        }
    }

    if (sScriptMgr->OnPlayerBeforeOpenItem(pUser, item))
    {
        if (item->IsWrapped())// wrapped?
        {
            CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_SEL_CHARACTER_GIFT_BY_ITEM);
            stmt->SetData(0, item->GetGUID().GetCounter());
            _queryProcessor.AddCallback(CharacterDatabase.AsyncQuery(stmt)
                .WithPreparedCallback(std::bind(&WorldSession::HandleOpenWrappedItemCallback, this, bagIndex, slot, item->GetGUID().GetCounter(), std::placeholders::_1)));
        }
        else
        {
            pUser->SendLoot(item->GetGUID(), LOOT_CORPSE);
        }
    }
}

void WorldSession::HandleOpenWrappedItemCallback(uint8 bagIndex, uint8 slot, ObjectGuid::LowType itemLowGUID, PreparedQueryResult result)
{
    if (!GetPlayer())
        return;

    Item* item = GetPlayer()->GetItemByPos(bagIndex, slot);
    if (!item)
        return;

    if (item->GetGUID().GetCounter() != itemLowGUID || !item->IsWrapped()) // during getting result, gift was swapped with another item
        return;

    if (!result)
    {
        LOG_ERROR("network", "Wrapped item {} don't have record in character_gifts table and will deleted", item->GetGUID().ToString());
        GetPlayer()->DestroyItem(item->GetBagSlot(), item->GetSlot(), true);
        return;
    }

    CharacterDatabaseTransaction trans = CharacterDatabase.BeginTransaction();

    Field* fields = result->Fetch();
    uint32 entry = fields[0].Get<uint32>();
    uint32 flags = fields[1].Get<uint32>();

    item->SetGuidValue(ITEM_FIELD_GIFTCREATOR, ObjectGuid::Empty);
    item->SetEntry(entry);
    item->SetUInt32Value(ITEM_FIELD_FLAGS, flags);
    item->SetUInt32Value(ITEM_FIELD_MAXDURABILITY, item->GetTemplate()->MaxDurability);

    item->SetState(ITEM_CHANGED, GetPlayer());
    GetPlayer()->SaveInventoryAndGoldToDB(trans);

    CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_DEL_GIFT);
    stmt->SetData(0, item->GetGUID().GetCounter());
    trans->Append(stmt);

    CharacterDatabase.CommitTransaction(trans);
}

void WorldSession::HandleGameObjectUseOpcode(WorldPacket& recvData)
{
    ObjectGuid guid;
    recvData >> guid;

    LOG_DEBUG("network", "WORLD: Recvd CMSG_GAMEOBJ_USE Message [{}]", guid.ToString());

    if (GameObject* obj = GetPlayer()->GetMap()->GetGameObject(guid))
    {
        if (!obj->IsWithinDistInMap(GetPlayer(), obj->GetInteractionDistance()))
            return;

        // ignore for remote control state
        if (GetPlayer()->m_mover != GetPlayer())
            if (!(GetPlayer()->IsOnVehicle(GetPlayer()->m_mover) || GetPlayer()->IsMounted()) && !obj->GetGOInfo()->IsUsableMounted())
                return;

        obj->Use(GetPlayer());
    }
}

void WorldSession::HandleGameobjectReportUse(WorldPacket& recvPacket)
{
    ObjectGuid guid;
    recvPacket >> guid;

    LOG_DEBUG("network", "WORLD: Recvd CMSG_GAMEOBJ_REPORT_USE Message [{}]", guid.ToString());

    // ignore for remote control state
    if (_player->m_mover != _player)
        return;

    GameObject* go = GetPlayer()->GetMap()->GetGameObject(guid);
    if (!go)
        return;

    // Prevent use of GameObject if it is not selectable. Fixes hack.
    if (go->HasGameObjectFlag(GO_FLAG_NOT_SELECTABLE))
        return;

    if (!go->IsWithinDistInMap(_player, INTERACTION_DISTANCE))
        return;

    if (go->AI()->GossipHello(_player, true))
        return;

    _player->UpdateAchievementCriteria(ACHIEVEMENT_CRITERIA_TYPE_USE_GAMEOBJECT, go->GetEntry());
}

void WorldSession::HandleCastSpellOpcode(WorldPacket& recvPacket)
{
    uint32 spellId;
    uint8  castCount, castFlags;

    if (recvPacket.empty())
        return;

    recvPacket >> castCount >> spellId >> castFlags;
    TriggerCastFlags triggerFlag = TRIGGERED_NONE;

    uint32 oldSpellId = spellId;

    LOG_DEBUG("network", "WORLD: got cast spell packet, castCount: {}, spellId: {}, castFlags: {}, data length = {}", castCount, spellId, castFlags, (uint32)recvPacket.size());

    // ignore for remote control state (for player case)
    Unit* mover = _player->m_mover;
    if (mover != _player && mover->IsPlayer())
    {
        recvPacket.rfinish(); // prevent spam at ignore packet
        return;
    }

    SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(spellId);

    if (!spellInfo)
    {
        LOG_ERROR("network.opcode", "WORLD: unknown spell id {}", spellId);
        recvPacket.rfinish(); // prevent spam at ignore packet
        return;
    }

    // fail if we are cancelling pending request
    if (!_player->SpellQueue.empty())
    {
        PendingSpellCastRequest& request = _player->SpellQueue.front(); // Peek at the first spell
        if (request.cancelInProgress)
        {
            Spell* spell = new Spell(_player, spellInfo, TRIGGERED_NONE);
            spell->m_cast_count = castCount;
            spell->SendCastResult(SPELL_FAILED_DONT_REPORT);
            spell->finish(false);
            recvPacket.rfinish(); // prevent spam at ignore packet
            return;
        }
    }

    // try queue spell if it can't be executed right now
    if (!_player->CanExecutePendingSpellCastRequest(spellInfo))
    {
        if (_player->CanRequestSpellCast(spellInfo))
        {
            WorldPacket packetCopy(recvPacket); // Copy the packet
            packetCopy.rpos(0); // Reset read position to the start of the buffer.
            _player->SpellQueue.emplace_back(
                spellId,
                spellInfo->GetCategory(),
                std::move(packetCopy) // Move ownership of copied packet
            );
            return;
        }
    }

    // client provided targets
    SpellCastTargets targets;
    targets.Read(recvPacket, mover);
    HandleClientCastFlags(recvPacket, castFlags, targets);

    // not have spell in spellbook
    if (mover->IsPlayer())
    {
        // not have spell in spellbook or spell passive and not casted by client
        if (!(spellInfo->Targets & TARGET_FLAG_GAMEOBJECT_ITEM) && (!mover->ToPlayer()->HasActiveSpell(spellId) || spellInfo->IsPassive()))
        {
            bool allow = false;

            // allow casting of unknown spells for special lock cases
            if (GameObject* go = targets.GetGOTarget())
            {
                if (go->GetSpellForLock(mover->ToPlayer()) == spellInfo)
                {
                    allow = true;
                }
            }

            /// @todo: Preparation for #23204
            // allow casting of spells triggered by clientside periodic trigger auras
            /*
             if (caster->HasAuraTypeWithTriggerSpell(SPELL_AURA_PERIODIC_TRIGGER_SPELL_FROM_CLIENT, spellId))
            {
                allow = true;
                triggerFlag = TRIGGERED_FULL_MASK;
            }
            */

            if (!allow)
                return;
        }
    }
    else
    {
        // pussywizard: casting player's spells from vehicle when seat allows it
        // if ANYTHING CHANGES in this function, INFORM ME BEFORE applying!!!
        if (Vehicle* veh = mover->GetVehicleKit())
            if (const VehicleSeatEntry* seat = veh->GetSeatForPassenger(_player))
                if (seat->m_flags & VEHICLE_SEAT_FLAG_CAN_ATTACK || spellInfo->Effects[EFFECT_0].Effect == SPELL_EFFECT_OPEN_LOCK /*allow looting from vehicle, but only if player has required spell (all necessary opening spells are in playercreateinfo_spell)*/)
                    if ((mover->IsCreature() && !mover->ToCreature()->HasSpell(spellId)) || spellInfo->IsPassive()) // the creature can't cast that spell, check player instead
                    {
                        if (!(spellInfo->Targets & TARGET_FLAG_GAMEOBJECT_ITEM) && (!_player->HasActiveSpell (spellId) || spellInfo->IsPassive()))
                        {
                            //cheater? kick? ban?
                            recvPacket.rfinish(); // prevent spam at ignore packet
                            return;
                        }

                        // at this point, player is a valid caster
                        // swapping the mover will stop the check below at IsUnit, so everything works fine
                        mover = _player;
                    }

        // not have spell in spellbook or spell passive and not casted by client
        if ((mover->IsCreature() && !mover->ToCreature()->HasSpell(spellId)) || spellInfo->IsPassive())
        {
            //cheater? kick? ban?
            recvPacket.rfinish(); // prevent spam at ignore packet
            return;
        }
    }

    sScriptMgr->ValidateSpellAtCastSpell(_player, oldSpellId, spellId, castCount, castFlags);

    if (oldSpellId != spellId)
        spellInfo = sSpellMgr->GetSpellInfo(spellId);

    // Client is resending autoshot cast opcode when other spell is casted during shoot rotation
    // Skip it to prevent "interrupt" message
    if (spellInfo->IsAutoRepeatRangedSpell() && _player->GetCurrentSpell(CURRENT_AUTOREPEAT_SPELL)
            && _player->GetCurrentSpell(CURRENT_AUTOREPEAT_SPELL)->m_spellInfo == spellInfo)
    {
        recvPacket.rfinish();
        return;
    }

    // can't use our own spells when we're in possession of another unit,
    if (_player->isPossessing())
    {
        return;
    }

    // pussywizard: HandleClientCastFlags calls HandleMovementOpcodes, which can result in pretty much anything. Caster not in map will crash at GetMap() for spell difficulty in Spell constructor.
    if (!mover->FindMap())
    {
        recvPacket.rfinish(); // prevent spam at ignore packet
        return;
    }

    // auto-selection buff level base at target level (in spellInfo)
    if (targets.GetUnitTarget())
    {
        SpellInfo const* actualSpellInfo = spellInfo->GetAuraRankForLevel(targets.GetUnitTarget()->GetLevel());

        // if rank not found then function return nullptr but in explicit cast case original spell can be casted and later failed with appropriate error message
        if (actualSpellInfo)
            spellInfo = actualSpellInfo;
    }

    Spell* spell = new Spell(mover, spellInfo, triggerFlag, ObjectGuid::Empty, false);

    sScriptMgr->ValidateSpellAtCastSpellResult(_player, mover, spell, oldSpellId, spellId);

    spell->m_cast_count = castCount;                       // set count of casts
    spell->prepare(&targets);
}

void WorldSession::HandleCancelCastOpcode(WorldPacket& recvPacket)
{
    uint32 spellId;

    recvPacket.read_skip<uint8>();                          // counter, increments with every CANCEL packet, don't use for now
    recvPacket >> spellId;

    _player->SpellQueue.clear();

    _player->InterruptSpell(CURRENT_MELEE_SPELL);
    if (_player->IsNonMeleeSpellCast(false))
        _player->InterruptNonMeleeSpells(false, spellId, false, true);
}

void WorldSession::HandleCancelAuraOpcode(WorldPacket& recvPacket)
{
    uint32 spellId;
    recvPacket >> spellId;

    SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(spellId);
    if (!spellInfo)
        return;

    // not allow remove spells with attr SPELL_ATTR0_NO_AURA_CANCEL
    if (spellInfo->HasAttribute(SPELL_ATTR0_NO_AURA_CANCEL))
    {
        return;
    }

    // channeled spell case (it currently casted then)
    if (spellInfo->IsChanneled())
    {
        if (Spell* curSpell = _player->GetCurrentSpell(CURRENT_CHANNELED_SPELL))
            if (curSpell->m_spellInfo->Id == spellId)
                _player->InterruptSpell(CURRENT_CHANNELED_SPELL);
        return;
    }

    // non channeled case:
    // don't allow remove non positive spells
    // don't allow cancelling passive auras (some of them are visible)
    if (!spellInfo->IsPositive() || spellInfo->IsPassive())
    {
        return;
    }

    // maybe should only remove one buff when there are multiple?
    _player->RemoveOwnedAura(spellId, ObjectGuid::Empty, 0, AURA_REMOVE_BY_CANCEL);
}

void WorldSession::HandlePetCancelAuraOpcode(WorldPacket& recvPacket)
{
    ObjectGuid guid;
    uint32 spellId;

    recvPacket >> guid;
    recvPacket >> spellId;

    SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(spellId);
    if (!spellInfo)
    {
        LOG_ERROR("network.opcode", "WORLD: unknown PET spell id {}", spellId);
        return;
    }

    Creature* pet = ObjectAccessor::GetCreatureOrPetOrVehicle(*_player, guid);

    if (!pet)
    {
        LOG_ERROR("network.opcode", "HandlePetCancelAura: Attempt to cancel an aura for non-existant pet {} by player {}", guid.ToString(), GetPlayer()->GetName());
        return;
    }

    if (pet != GetPlayer()->GetGuardianPet() && pet != GetPlayer()->GetCharm())
    {
        LOG_ERROR("network.opcode", "HandlePetCancelAura: Pet {} is not a pet of player {}", guid.ToString(), GetPlayer()->GetName());
        return;
    }

    if (!pet->IsAlive())
    {
        pet->SendPetActionFeedback(FEEDBACK_PET_DEAD);
        return;
    }

    pet->RemoveOwnedAura(spellId, ObjectGuid::Empty, 0, AURA_REMOVE_BY_CANCEL);
}

void WorldSession::HandleCancelGrowthAuraOpcode(WorldPacket& /*recvPacket*/)
{
}

void WorldSession::HandleCancelAutoRepeatSpellOpcode(WorldPacket& /*recvPacket*/)
{
    // may be better send SMSG_CANCEL_AUTO_REPEAT?
    // cancel and prepare for deleting
    _player->InterruptSpell(CURRENT_AUTOREPEAT_SPELL);
}

void WorldSession::HandleCancelChanneling(WorldPacket& recvData)
{
    uint32 spellID = 0;
    recvData >> spellID;

    // ignore for remote control state (for player case)
    Unit* mover = _player->m_mover;
    if (!mover)
    {
        return;
    }

    SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(spellID);
    if (!spellInfo)
    {
        return;
    }

    // not allow remove spells with attr SPELL_ATTR0_NO_AURA_CANCEL
    if (spellInfo->HasAttribute(SPELL_ATTR0_NO_AURA_CANCEL))
    {
        return;
    }

    Spell* spell = mover->GetCurrentSpell(CURRENT_CHANNELED_SPELL);
    if (!spell || spell->GetSpellInfo()->Id != spellInfo->Id)
    {
        return;
    }

    mover->InterruptSpell(CURRENT_CHANNELED_SPELL);
}

void WorldSession::HandleTotemDestroyed(WorldPackets::Totem::TotemDestroyed& totemDestroyed)
{
    // ignore for remote control state
    if (_player->m_mover != _player)
        return;

    uint8 slotId = totemDestroyed.Slot;
    slotId += SUMMON_SLOT_TOTEM;

    if (slotId >= MAX_TOTEM_SLOT)
        return;

    if (!_player->m_SummonSlot[slotId])
        return;

    Creature* totem = GetPlayer()->GetMap()->GetCreature(_player->m_SummonSlot[slotId]);
    // Don't unsummon sentry totem
    if (totem && totem->IsTotem())
        totem->ToTotem()->UnSummon();
}

void WorldSession::HandleSelfResOpcode(WorldPacket& /*recvData*/)
{
    LOG_DEBUG("network", "WORLD: CMSG_SELF_RES");                  // empty opcode

    if (SpellInfo const* spell = sSpellMgr->GetSpellInfo(_player->GetUInt32Value(PLAYER_SELF_RES_SPELL)))
    {
        if (_player->HasPreventResurectionAura() && !spell->HasAttribute(SPELL_ATTR7_BYPASS_NO_RESURRECTION_AURA))
        {
            return; // silent return, client should display error by itself and not send this opcode
        }

        _player->CastSpell(_player, spell->Id);
        _player->SetUInt32Value(PLAYER_SELF_RES_SPELL, 0);
    }
}

void WorldSession::HandleSpellClick(WorldPacket& recvData)
{
    ObjectGuid guid;
    recvData >> guid;

    // this will get something not in world. crash
    Creature* unit = ObjectAccessor::GetCreatureOrPetOrVehicle(*_player, guid);

    if (!unit)
        return;

    /// @todo: Unit::SetCharmedBy: 28782 is not in world but 0 is trying to charm it! -> crash
    if (!unit->IsInWorld())
        return;

    unit->HandleSpellClick(_player);
}

void WorldSession::HandleMirrorImageDataRequest(WorldPacket& recvData)
{
    LOG_DEBUG("network", "WORLD: CMSG_GET_MIRRORIMAGE_DATA");
    ObjectGuid guid;
    recvData >> guid;

    LOG_INFO("network", "Received mirror image data request for GUID {}", guid.ToString());

    // Get unit for which data is needed by client
    Unit* unit = ObjectAccessor::GetUnit(*_player, guid);
    if (!unit)
    {
        LOG_ERROR("network", "Unit not found for GUID {}", guid.ToString());
        return;
    }

    LOG_INFO("network", "Unit found for GUID {}", guid.ToString());

    if (unit->GetTypeId() == TYPEID_UNIT) // Handle regular NPCs
    {
        CreatureOutfitContainer const& outfits = sObjectMgr->GetNPCOutfitMap();
        CreatureOutfitContainer::const_iterator it = outfits.find(unit->GetEntry());
        if (it != outfits.end())
        {
            LOG_INFO("network", "Outfit found for creature entry {}", unit->GetEntry());

            WorldPacket data(SMSG_MIRRORIMAGE_DATA, 68); // Corrected to use SMSG_MIRRORIMAGE_DATA
            data << guid;
            data << uint32(unit->GetNativeDisplayId()); // displayId
            data << uint8(it->second.race);             // race
            data << uint8(it->second.gender);           // gender
            data << uint8(unit->GetClass());            // class
            data << uint8(it->second.skin);             // skin
            data << uint8(it->second.face);             // face
            data << uint8(it->second.hair);             // hair
            data << uint8(it->second.haircolor);        // haircolor
            data << uint8(it->second.facialhair);       // facialhair
            data << uint32(0);                          // guildId

            LOG_INFO("network", "Prepared data for NPC outfit packet");

            for (uint8 i = 0; i != MAX_CREATURE_OUTFIT_DISPLAYS; ++i)
            {
                data << uint32(it->second.outfit[i]);
                //LOG_INFO("network", "Outfit slot {}: displayId {}", i, it->second.outfit[i]);
            }

            SendPacket(&data);
            LOG_INFO("network", "Sent NPC outfit data for GUID {}", guid.ToString());
            return;
        }
        else
        {
            LOG_ERROR("network", "No outfit found for creature entry {}", unit->GetEntry());
        }
    }

    if (!unit->HasAuraType(SPELL_AURA_CLONE_CASTER))
    {
        LOG_ERROR("network", "Unit does not have SPELL_AURA_CLONE_CASTER for GUID {}", guid.ToString());
        return;
    }

    Unit* creator = unit->GetAuraEffectsByType(SPELL_AURA_CLONE_CASTER).front()->GetCaster();
    if (!creator)
    {
        LOG_ERROR("network", "Creator not found for SPELL_AURA_CLONE_CASTER for GUID {}", guid.ToString());
        return;
    }

    LOG_INFO("network", "Creator found for SPELL_AURA_CLONE_CASTER: GUID {}", creator->GetGUID().ToString());

    WorldPacket data(SMSG_MIRRORIMAGE_DATA, 68);
    data << guid;
    data << uint32(creator->GetDisplayId());
    data << uint8(creator->getRace());
    data << uint8(creator->getGender());
    data << uint8(creator->getClass());

    if (creator->IsPlayer())
    {
        Player* player = creator->ToPlayer();
        data << uint8(player->GetByteValue(PLAYER_BYTES, 0));   // skin
        data << uint8(player->GetByteValue(PLAYER_BYTES, 1));   // face
        data << uint8(player->GetByteValue(PLAYER_BYTES, 2));   // hair
        data << uint8(player->GetByteValue(PLAYER_BYTES, 3));   // haircolor
        data << uint8(player->GetByteValue(PLAYER_BYTES_2, 0)); // facialhair
        data << uint32(player->GetGuildId());                   // unk

        LOG_INFO("network", "Player data: race {}, gender {}, class {}", player->getRace(), player->getGender(), player->getClass());

        static EquipmentSlots const itemSlots[] =
        {
            EQUIPMENT_SLOT_HEAD,
            EQUIPMENT_SLOT_SHOULDERS,
            EQUIPMENT_SLOT_BODY,
            EQUIPMENT_SLOT_CHEST,
            EQUIPMENT_SLOT_WAIST,
            EQUIPMENT_SLOT_LEGS,
            EQUIPMENT_SLOT_FEET,
            EQUIPMENT_SLOT_WRISTS,
            EQUIPMENT_SLOT_HANDS,
            EQUIPMENT_SLOT_BACK,
            EQUIPMENT_SLOT_TABARD,
            EQUIPMENT_SLOT_END
        };

        for (EquipmentSlots const* itr = &itemSlots[0]; *itr != EQUIPMENT_SLOT_END; ++itr)
        {
            if (*itr == EQUIPMENT_SLOT_HEAD && player->HasPlayerFlag(PLAYER_FLAGS_HIDE_HELM))
                data << uint32(0);
            else if (*itr == EQUIPMENT_SLOT_BACK && player->HasPlayerFlag(PLAYER_FLAGS_HIDE_CLOAK))
                data << uint32(0);
            else if (Item const* item = player->GetItemByPos(INVENTORY_SLOT_BAG_0, *itr))
            {
                uint32 displayInfoId = item->GetTemplate()->DisplayInfoID;

                sScriptMgr->OnGlobalMirrorImageDisplayItem(item, displayInfoId);

                data << uint32(displayInfoId);
                LOG_INFO("network", "Item slot {}: displayId {}", *itr, displayInfoId);
            }
            else
            {
                data << uint32(0);
            }
        }
    }
    else
    {
        data << uint8(0);
        data << uint32(0);
        data << uint32(0);
        data << uint32(0);
        data << uint32(0);
        data << uint32(0);
        data << uint32(0);
        data << uint32(0);
        data << uint32(0);
        data << uint32(0);
        data << uint32(0);
        data << uint32(0);
        data << uint32(0);
        data << uint32(0);
    }

    SendPacket(&data);
    LOG_INFO("network", "Sent mirror image data for GUID {}", guid.ToString());
}

void WorldSession::HandleUpdateProjectilePosition(WorldPacket& recvPacket)
{
    LOG_DEBUG("network", "WORLD: CMSG_UPDATE_PROJECTILE_POSITION");

    ObjectGuid casterGuid;
    uint32 spellId;
    uint8 castCount;
    float x, y, z;    // Position of missile hit

    recvPacket >> casterGuid;
    recvPacket >> spellId;
    recvPacket >> castCount;
    recvPacket >> x;
    recvPacket >> y;
    recvPacket >> z;

    Unit* caster = ObjectAccessor::GetUnit(*_player, casterGuid);
    if (!caster)
        return;

    Spell* spell = caster->FindCurrentSpellBySpellId(spellId);
    if (!spell || !spell->m_targets.HasDst())
        return;

    Position pos = *spell->m_targets.GetDstPos();
    pos.Relocate(x, y, z);
    spell->m_targets.ModDst(pos);

    WorldPacket data(SMSG_SET_PROJECTILE_POSITION, 21);
    data << casterGuid;
    data << uint8(castCount);
    data << float(x);
    data << float(y);
    data << float(z);
    caster->SendMessageToSet(&data, true);
}
