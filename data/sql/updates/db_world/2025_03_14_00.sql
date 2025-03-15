-- DB update 2025_03_05_00 -> 2025_03_14_00
-- SylCore Copyright 2025


-- "Flown the Coop!"
DELETE FROM smart_scripts WHERE entryorguid = 2816100 AND comment = 'Chicken Escapee - On Script - Set React State \'Aggressive\'';

UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 28161;

DELETE FROM `smart_scripts` WHERE (`entryorguid` = 28161) AND (`source_type` = 0) AND (`id` IN (8));
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(28161, 0, 8, 0, 4, 0, 100, 0, 0, 0, 0, 0, 0, 0, 75, 62989, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Chicken Escapee - On Spellhit (Chicken Net) - End Combat');




-- "Seeds of Chaos"
UPDATE `creature_template` SET `speed_run` = 1.8 WHERE (`entry` = 31157);

-- "Finding the Phylactery"
UPDATE `gameobject_template` SET `Data5` = 1 WHERE (`entry` = 188141);

-- "The Reckoning"
UPDATE `creature_template` SET `faction` = 35 WHERE (`entry` = 30420);


-- Utgarde Pinnacle - Dungeon
UPDATE `creature_template_movement` SET `Flight` = 0 WHERE (`CreatureId` = 29281);
DELETE FROM `creature` WHERE (`id1` = 29281) AND (`guid` IN (126115));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(126115, 29281, 0, 0, 575, 0, 0, 3, 1, 0, 296.632, -346.075, 92.6, 4.60767, 86400, 0, 0, 12600, 0, 0, 0, 0, 0, '', 0);

DELETE FROM `creature` WHERE (`id1` = 26696) AND (`guid` IN (126110, 126111));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(126110, 26696, 0, 0, 575, 0, 0, 2, 1, 1, 370.794, -432.289, 75.1223, 3.53522, 3600, 5, 0, 50400, 0, 1, 0, 0, 0, '', 0),
(126111, 26696, 0, 0, 575, 0, 0, 2, 1, 1, 372.712, -436.907, 75.0746, 3.53521, 3600, 0, 0, 50400, 0, 2, 0, 0, 0, '', 0);

DELETE FROM `creature` WHERE (`id1` = 28368) AND (`guid` IN (126250, 126251));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(126250, 28368, 0, 0, 575, 0, 0, 2, 1, 1, 423.682, -458.795, 75.2266, 1.74533, 3600, 0, 0, 40320, 44070, 0, 0, 0, 0, '', 0),
(126251, 28368, 0, 0, 575, 0, 0, 2, 1, 1, 419.459, -454.22, 75.2546, 6.26573, 3600, 0, 0, 40320, 44070, 0, 0, 0, 0, '', 0);

DELETE FROM `creature` WHERE (`id1` = 26694) AND (`guid` IN (126125, 126124));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(126125, 26694, 0, 0, 575, 0, 0, 3, 1, 1, 419.459, -454.22, 75.2546, 6.26573, 3600, 0, 0, 40320, 44070, 0, 0, 0, 0, '', 0),
(126124, 26694, 0, 0, 575, 0, 0, 3, 1, 1, 423.682, -458.795, 75.2266, 1.74533, 3600, 0, 0, 40320, 44070, 0, 0, 0, 0, '', 0);



-- Northend

-- Adding the spell_target_positions.
INSERT INTO `spell_target_position` (`ID`, `EffectIndex`, `MapID`, `PositionX`, `PositionY`, `PositionZ`, `Orientation`, `VerifiedBuild`) VALUES (46448, 0, 571, 3782.1125, 3558.9978, 473.32175, 2.9065022, 0);
INSERT INTO `spell_target_position` (`ID`, `EffectIndex`, `MapID`, `PositionX`, `PositionY`, `PositionZ`, `Orientation`, `VerifiedBuild`) VALUES (46447, 0, 571, 3733.002, 3563.1372, 290.81595, 3.7939076, 0);

-- Update to use the areaTrigger script.
UPDATE `areatrigger_scripts` SET `ScriptName`='at_naxxanar_teleports' WHERE `entry`=5334;
UPDATE `areatrigger_scripts` SET `ScriptName`='at_naxxanar_teleports' WHERE `entry`=5338;