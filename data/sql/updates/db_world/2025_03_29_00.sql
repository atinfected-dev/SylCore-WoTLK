-- DB update 2025_03_14_00 -> 2025_04_09_00
-- SylCore Copyright 2025

-- Remove Dragonflayer Deathseeker on normal.
DELETE FROM `creature` WHERE (`id1` = 26550) AND (`guid` IN (126153));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(126153, 26550, 0, 0, 575, 0, 0, 2, 1, 1, 317.807, -252.545, 104.418, 2.07694, 3600, 0, 0, 48700, 0, 0, 0, 0, 0, '', 0);


-- Remove Dragonflayer Fanatic on normal.
DELETE FROM `creature` WHERE (`id1` = 26553) AND (`guid` IN (126157));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(126157, 26553, 0, 0, 575, 0, 0, 2, 1, 1, 320.42, -244.701, 104.494, 4.04916, 3600, 0, 0, 50400, 0, 0, 0, 0, 0, '', 0);


-- Remove Ymirjar Dusk Shaman on normal.
DELETE FROM `creature` WHERE (`id1` = 26694) AND (`guid` IN (126107));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(126107, 26694, 0, 0, 575, 0, 0, 2, 1, 1, 481.851, -458.923, 75.133, 5.3058, 3600, 0, 0, 40320, 44070, 0, 0, 0, 0, '', 0);


-- Replacing the Dragonflayer Deathseeker on normal I removed with Dragonflayer Fanatic.
DELETE FROM `creature` WHERE (`id1` = 26553) AND (`guid` IN (5310000));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310000, 26553, 0, 0, 575, 0, 0, 1, 1, 1, 317.807, -252.545, 104.418, 2.07694, 3600, 0, 0, 50400, 0, 0, 0, 0, 0, '', 0);


-- Replacing the Dragonflayer Fanatic on normal I removed with Dragonflayer Seer
DELETE FROM `creature` WHERE (`id1` = 26554) AND (`guid` IN (5310001));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310001, 26554, 0, 0, 575, 0, 0, 1, 1, 1, 320.42, -244.701, 104.494, 4.04916, 3600, 0, 0, 50400, 19970, 0, 0, 0, 0, '', 0);


-- Replacing the Ymirjar Dusk Shaman on normal, I removed with Ymirjar Necromancer
DELETE FROM `creature` WHERE (`id1` = 28368) AND (`guid` IN (5310002));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310002, 28368, 0, 0, 575, 0, 0, 1, 1, 1, 481.851, -458.923, 75.133, 5.3058, 3600, 0, 0, 40320, 44070, 0, 0, 0, 0, '', 0);
	
-- Removed Ymirjar Necromancer on heroic.
DELETE FROM `creature` WHERE (`id1` = 28368) AND (`guid` IN (126248));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(126248, 28368, 0, 0, 575, 0, 0, 1, 1, 1, 477.974, -458.523, 104.799, 0.139626, 3600, 0, 0, 40320, 44070, 0, 0, 0, 0, '', 0);

-- Replacing the Ymirjar Necromancer on heroic, I removed with Ymirjar Dusk Shaman
DELETE FROM `creature` WHERE (`id1` = 26694) AND (`guid` IN (5310003));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310003, 26694, 0, 0, 575, 0, 0, 2, 1, 1, 477.974, -458.523, 104.799, 0.139626, 3600, 0, 0, 40320, 44070, 0, 0, 0, 0, '', 0);

-- Removed the spawn of a Ymirjar Dusk Shaman on heroic.
DELETE FROM `creature` WHERE (`id1` = 26694) AND (`guid` IN (126125));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(126125, 26694, 0, 0, 575, 0, 0, 1, 1, 1, 419.459, -454.22, 75.2546, 6.26573, 3600, 0, 0, 40320, 44070, 0, 0, 0, 0, '', 0);

-- Removed the spawn of a Ymirjar Necromancer on heroic.
DELETE FROM `creature` WHERE (`id1` = 28368) AND (`guid` IN (126250));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(126250, 28368, 0, 0, 575, 0, 0, 0, 1, 1, 423.682, -458.795, 75.2266, 1.74533, 3600, 0, 0, 40320, 44070, 0, 0, 0, 0, '', 0);

-- Deleting the entry in creature with guid of "126250" also removing the linked_respawn.
DELETE FROM `creature` WHERE (`id1` = 28368) AND (`guid` IN (126250));
DELETE FROM `acore_world`.`linked_respawn` WHERE `guid`=126250 AND `linkType`=0;
	
UPDATE `creature_template_movement` SET `Flight` = 0 WHERE (`CreatureId` = 24083);
UPDATE `creature_template_movement` SET `Flight` = 0 WHERE (`CreatureId` = 31669);
UPDATE `vehicle_template_accessory` SET `accessory_entry`=24849, `seat_id`=0, `minion`=0, `description`='Proto-Drake Rider', `summontype`=6, `summontimer`=120000 WHERE `entry`=24083 AND `seat_id`=0;
DELETE FROM `creature` WHERE (`id1` = 24083) AND (`guid` IN (1971380));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(1971380, 24083, 0, 0, 574, 0, 0, 3, 1, 0, 239.569, -161.025, 190.346, 0, 3600, 0, 0, 71856, 0, 0, 0, 33600, 0, '', 0);
		
-- Removed from the normal mode.
DELETE FROM `creature` WHERE (`id1` = 23960) AND (`guid` IN (126042));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(126042, 23960, 0, 0, 574, 0, 0, 2, 1, 1, 208.512, 231.513, 40.9014, 4.83456, 3600, 0, 0, 35928, 3155, 0, 0, 0, 0, '', 0);

-- Added the creature.
DELETE FROM `creature` WHERE (`id1` = 23956) AND (`guid` IN (5310004));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310004, 23956, 0, 0, 574, 0, 0, 1, 1, 1, 208.512, 231.513, 40.9014, 4.83456, 3600, 0, 0, 35928, 0, 2, 0, 0, 0, '', 0);

-- Removed from the normal mode.
DELETE FROM `creature` WHERE (`id1` = 23961) AND (`guid` IN (126046));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(126046, 23961, 0, 0, 574, 0, 0, 2, 1, 1, 197.267, 225.973, 40.9016, 5.42797, 3600, 0, 0, 35928, 0, 0, 0, 0, 0, '', 0);

		-- Added creature.
DELETE FROM `creature` WHERE (`id1` = 23960) AND (`guid` IN (5310005));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310005, 23960, 0, 0, 574, 0, 0, 1, 1, 1, 197.267, 225.973, 40.9016, 5.42797, 3600, 0, 0, 35928, 3155, 0, 0, 0, 0, '', 0);

-- Removed from the normal mode.
DELETE FROM `creature` WHERE (`id1` = 23960) AND (`guid` IN (126041));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(126041, 23960, 0, 0, 574, 0, 0, 2, 1, 1, 211.367, 194.883, 40.9015, 1.81514, 3600, 0, 0, 35928, 3155, 0, 0, 0, 0, '', 0);

-- Added creature.
DELETE FROM `creature` WHERE (`id1` = 23956) AND (`guid` IN (5310006));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310006, 23956, 0, 0, 574, 0, 0, 1, 1, 1, 211.367, 194.883, 40.9015, 1.81514, 3600, 0, 0, 35928, 0, 2, 0, 0, 0, '', 0);

-- Removed from the normal mode.
DELETE FROM `creature` WHERE (`id1` = 23956) AND (`guid` IN (126032));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(126032, 23956, 0, 0, 574, 0, 0, 2, 1, 1, 221.203, 200.627, 40.9015, 2.54818, 3600, 0, 0, 35928, 0, 0, 0, 0, 0, '', 0);

-- Added creature.
DELETE FROM `creature` WHERE (`id1` = 23961) AND (`guid` IN (5310007));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310007, 23961, 0, 0, 574, 0, 0, 1, 1, 1, 221.203, 200.627, 40.9015, 2.54818, 3600, 0, 0, 35928, 0, 0, 0, 0, 0, '', 0);

-- Fix for the strategist waypoint movement.
DELETE FROM `creature` WHERE (`id1` = 23956) AND (`guid` IN (5310004, 5310006));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310004, 23956, 0, 0, 574, 0, 0, 1, 1, 1, 208.512, 231.513, 40.9014, 4.83456, 3600, 0, 0, 35928, 0, 0, 0, 0, 0, '', 0),
(5310006, 23956, 0, 0, 574, 0, 0, 1, 1, 1, 211.367, 194.883, 40.9015, 1.81514, 3600, 0, 0, 35928, 0, 0, 0, 0, 0, '', 0);

-- Deleted "Dragonflayer Ironhelm" Both normal + heroic
DELETE FROM `creature` WHERE (`id1` = 23961) AND (`guid` IN (126044));

-- Added Creature (Both Normal + Heroic)
DELETE FROM `creature` WHERE (`id1` = 23960) AND (`guid` IN (5310008));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310008, 23960, 0, 0, 574, 0, 0, 3, 1, 1, 112.259, 53.3617, 65.7861, 3.9619, 3600, 0, 0, 35928, 3155, 0, 0, 0, 0, '', 0);

-- Updating the linked_respawn.
UPDATE `linked_respawn` SET `guid`=5310008, `linkedGuid`=126023, `linkType`=0 WHERE `guid`=126044 AND `linkType`=0;

DELETE FROM `creature_addon` WHERE `guid`=126044;

-- Removed from normal mode.
DELETE FROM `creature` WHERE (`id1` = 23956) AND (`guid` IN (126033));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(126033, 23956, 0, 0, 574, 0, 0, 2, 1, 1, 89.4369, 98.3051, 87.24, 1.8856, 3600, 0, 0, 35928, 0, 2, 0, 0, 0, '', 0);

-- Removed the creatures follower (the wolf) from normal mode.
DELETE FROM `creature` WHERE (`id1` = 29735) AND (`guid` IN (125998));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(125998, 29735, 0, 0, 574, 0, 0, 2, 1, 0, 87.2098, 95.4552, 86.4534, 1.88689, 3600, 5, 0, 8982, 0, 1, 0, 0, 0, '', 0);


-- Added creature.
DELETE FROM `creature` WHERE (`id1` = 23960) AND (`guid` IN (5310009));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310009, 23960, 0, 0, 574, 0, 0, 1, 1, 1, 89.4369, 98.3051, 87.24, 1.8856, 3600, 0, 0, 35928, 3155, 2, 0, 0, 0, '', 0);

-- Makes the creature we added walk based on waypoints, reusing the waypoint/pathID for the heroic creature, since its the same path.
INSERT INTO `creature_addon` (`guid`, `path_id`, `mount`, `bytes1`, `bytes2`, `emote`, `visibilityDistanceType`, `auras`) VALUES (5310009, 1260330, 0, 0, 1, 0, 0, '');

-- Added the creatures worg.
DELETE FROM `creature` WHERE (`id1` = 29735) AND (`guid` IN (5310010));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310010, 29735, 0, 0, 574, 0, 0, 1, 1, 0, 87.2098, 95.4552, 86.4534, 1.88689, 3600, 5, 0, 8982, 0, 1, 0, 0, 0, '', 0);

-- Added the creature itself to the "creature_formations" table.
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES (5310009, 5310009, 0, 0, 2, 0, 0);

-- Addded worg into the creature_formation so it follows the new creature on normal mode.
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES (5310009, 5310010, 2, 270, 514, 0, 0);

-- Add worg into linked_respawn with the leader.
INSERT INTO `linked_respawn` (`guid`, `linkedGuid`, `linkType`) VALUES (5310010, 5310009, 0);

DELETE FROM `creature_addon` WHERE (`guid` IN (126045));
DELETE FROM `creature` WHERE (`id1` = 23961) AND (`guid` IN (126045));

-- Adding the worg that should replace it (Both Normal & Heroic!)
DELETE FROM `creature` WHERE (`id1` = 29735) AND (`guid` IN (5310011));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310011, 29735, 0, 0, 574, 0, 0, 3, 1, 0, 103.615, 59.1528, 109.097, 5.134207, 3600, 0, 0, 8982, 0, 0, 0, 0, 0, '', 0);

-- Updating the linked_respawn.
UPDATE `linked_respawn` SET `guid`=5310011, `linkedGuid`=126023, `linkType`=0 WHERE `guid`=126045 AND `linkType`=0;

		-- Removed "Dragonflayer Runecaster" wrong spawn, should be "Dragonflayer Strategist" (For both Normal & Heroic)
DELETE FROM `creature` WHERE (`id1` = 23960) AND (`guid` IN (126037));

		-- Added "Dragonflayer Strategist", which would replace the "Dragonflayer Runecaster"
DELETE FROM `creature` WHERE (`id1` = 23956) AND (`guid` IN (5310012));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310012, 23956, 0, 0, 574, 0, 0, 3, 1, 1, 111.594, 61.3958, 109.095, 4.32842, 3600, 0, 0, 35928, 0, 0, 0, 0, 0, '', 0);

		-- Updating the linked_respawn.
UPDATE `linked_respawn` SET `guid`=5310012, `linkedGuid`=126023, `linkType`=0 WHERE `guid`=126037 AND `linkType`=0;

		-- Delete creature from addon.
DELETE FROM `creature_addon` WHERE `guid`=126037;

		-- Delete "Dragonflayer Runecaster", wrong spawn, should be "Dragonflayer Strategist" (Both Normal & Heroic)
DELETE FROM `creature` WHERE (`id1` = 23960) AND (`guid` IN (126036));
DELETE FROM `creature_addon` WHERE (`guid` IN (126036));

		-- Added Creature into the game.
DELETE FROM `creature` WHERE (`id1` = 23956) AND (`guid` IN (5310013));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310013, 23956, 0, 0, 574, 0, 0, 3, 1, 1, 103.125, 46.6215, 109.095, 0.907571, 3600, 0, 0, 35928, 0, 0, 0, 0, 0, '', 0);


		-- Updating the linked_respawn.
UPDATE `linked_respawn` SET `guid`=5310013, `linkedGuid`=126023, `linkType`=0 WHERE `guid`=126036 AND `linkType`=0;

		-- Delete "Dragonflayer Strategist", wrong spawn, should be "Dragonflayer Runecaster"
DELETE FROM `creature` WHERE (`id1` = 23956) AND (`guid` IN (126029));
DELETE FROM `creature_addon` WHERE (`guid` IN (126029));



DELETE FROM `creature` WHERE (`id1` = 23960) AND (`guid` IN (5310014));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310014, 23960, 0, 0, 574, 0, 0, 3, 1, 1, 109.54, 45.5503, 109.09, 1.71042, 3600, 0, 0, 35928, 3155, 0, 0, 0, 0, '', 0);

		-- Updating linked respawn.
UPDATE `linked_respawn` SET `guid`=5310014, `linkedGuid`=126023, `linkType`=0 WHERE `guid`=126029 AND `linkType`=0;

		-- Delete "Dragonflayer Runecaster", wrong spawn, should be "Dragonflayer Spiritualist" (Both Normal + Heroic)
DELETE FROM `creature` WHERE (`id1` = 23960) AND (`guid` IN (126039));
DELETE FROM `creature_addon` WHERE (`guid` IN (126039));


		-- Delete "Dragonflayer Runecaster", wrong spawn, should be "Dragonflayer Spiritualist" (Both Normal + Heroic)
DELETE FROM `creature` WHERE (`id1` = 28410) AND (`guid` IN (5310015));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310015, 28410, 0, 0, 574, 0, 0, 3, 1, 1, 245.431, 15.7227, 135.272, 2.70526, 3600, 0, 0, 28740, 7196, 0, 0, 0, 0, '', 0);

		-- Updating linked respawn.
UPDATE `linked_respawn` SET `guid`=5310015, `linkedGuid`=126023, `linkType`=0 WHERE `guid`=126039 AND `linkedGuid`=126026;

		-- Removed "Dragonflayer Bonecrusher", wrong spawn, should be "Savage Worg".
DELETE FROM `creature` WHERE (`id1` = 24069) AND (`guid` IN (125888));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(125888, 24069, 0, 0, 574, 0, 0, 2, 1, 1, 228.063, -5.74479, 178.568, 2.67035, 3600, 0, 0, 35928, 0, 0, 0, 0, 0, '', 0);

		-- Added "Savage Worg"
DELETE FROM `creature` WHERE (`id1` = 29735) AND (`guid` IN (5310016));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310016, 29735, 0, 0, 574, 0, 0, 1, 1, 0, 228.063, -5.74479, 178.568, 0.460112, 3600, 0, 0, 8982, 0, 0, 0, 0, 0, '', 0);

		-- Added "Savage Worg" Into linked_respawns
INSERT INTO `linked_respawn` (`guid`, `linkedGuid`, `linkType`) VALUES (5310016, 126026, 0);

-- Removed "Dragonflayer Runecaster", wrong spawn, should be "Dragonflayer Spiritualist"
DELETE FROM `creature` WHERE (`id1` = 23960) AND (`guid` IN (126038));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(126038, 23960, 0, 0, 574, 0, 0, 2, 1, 1, 230.448, -13.7934, 178.621, 3.28122, 3600, 0, 0, 35928, 3155, 0, 0, 0, 0, '', 0);

-- Added "Dragonflayer Spiritualist"
DELETE FROM `creature` WHERE (`id1` = 28410) AND (`guid` IN (5310017));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310017, 28410, 0, 0, 574, 0, 0, 1, 1, 1, 230.448, -13.7934, 178.621, 3.28122, 3600, 0, 0, 28740, 7196, 0, 0, 0, 0, '', 0);

-- Added "Dragonflayer Spiritualist" Into linked_respawns
INSERT INTO `linked_respawn` (`guid`, `linkedGuid`, `linkType`) VALUES (5310017, 126026, 0);

-- Remove "Dragonflayer Bonecrusher", wrong spawn, should be "Dragonflayer Spiritualist"
DELETE FROM `creature` WHERE (`id1` = 24069) AND (`guid` IN (125889));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(125889, 24069, 0, 0, 574, 0, 0, 2, 1, 1, 263.756, -99.9674, 190.468, 0.802851, 3600, 0, 0, 35928, 0, 0, 0, 0, 0, '', 0);

-- Added "Dragonflayer Spiritualist".
DELETE FROM `creature` WHERE (`id1` = 28410) AND (`guid` IN (5310018));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310018, 28410, 0, 0, 574, 0, 0, 1, 1, 1, 263.756, -99.9674, 190.468, 0.802851, 3600, 0, 0, 28740, 7196, 0, 0, 0, 0, '', 0);

-- Added "Dragonflayer Spiritualist" into the creature_addon table.
INSERT INTO `creature_addon` (`guid`, `path_id`, `mount`, `bytes1`, `bytes2`, `emote`, `visibilityDistanceType`, `auras`) VALUES (5310018, 0, 0, 1, 0, 1, 0, NULL);

-- Deleted "Dragonflayer Bonecrusher", wrong spawn, should be "Dragonflayer Heartspliter" (Both Normal + Heroic)
DELETE FROM `creature` WHERE (`id1` = 24069) AND (`guid` IN (125886));
DELETE FROM `creature_addon` WHERE `guid`=125886;

-- Added "Dragonflayer Heartsplitter"
DELETE FROM `creature` WHERE (`id1` = 24071) AND (`guid` IN (5310019));
INSERT INTO `creature` (`guid`, `id1`, `id2`, `id3`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(5310019, 24071, 0, 0, 574, 0, 0, 3, 1, 1, 162.227, -175.224, 180.59, 3.52556, 3600, 0, 0, 35928, 0, 0, 0, 0, 0, '', 0);

		-- Updating linked respawn.
UPDATE `linked_respawn` SET `guid`=5310019, `linkedGuid`=126023, `linkType`=0 WHERE `guid`=125886 AND `linkedGuid`=126026;