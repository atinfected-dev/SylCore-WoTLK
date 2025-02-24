-- DB update 2025_02_21_00 -> 2025_02_24_00
-- SylCore Copyright 2025



UPDATE acore_string
SET content_default = 'Creature ''{}'' has been removed ( Entry: ''{}''    |    GUID: ''{}'' )'
WHERE content_default = 'Creature Removed' AND entry = 270;

ALTER TABLE acore_string 
  COMMENT 'This table holds all of the strings used internally by the server. It is provided for the main purpose of translation.';

ALTER TABLE spell_script_names 
  COMMENT 'Holds the spell id to ScriptName pairings for use in spell scripts.';

ALTER TABLE spell_scripts 
  COMMENT 'This table format is used for 3 different tables to control possible scripts activated by different actions:

spell_scripts: Holds scripts that can be activated by spells with effect SPELL_EFFECT_SCRIPT_EFFECT (77) or SPELL_EFFECT_DUMMY(3).

event_scripts: Holds scripts activated whenever an event is activated, be it by an object or as the spell effect SPELL_EFFECT_SEND_EVENT (61).

waypoint_scripts: Holds scripts used in the waypoint_data table. See also Waypoints-Information for general information about waypoints.

NOTE: An entry in this table may have more than one row as a script may do more than just one action. Also each action the script may make can have a separate delay attached to it. In that case, the core will activate the appropriate action after the correct delay.';

ALTER TABLE spell_threat 
  COMMENT 'This table holds threat values on all spells that should either give or take away threat.';
  
ALTER TABLE spell_area 
  COMMENT 'This table is used to apply a specific spell aura to the player within an area in the game. When any player enters this area or somehow interacts with a quest, this aura will be handled accordingly.';
  
ALTER TABLE spell_bonus_data 
  COMMENT 'Table used for storing custom damage/healing bonus coefficients.';

ALTER TABLE spell_linked_spell 
  COMMENT 'This table provides data for spell linking system, telling it which spells trigger what, and under which conditions.';
  
ALTER TABLE spell_group 
  COMMENT 'Table used to group spells for varius checks in the core. One spell may be added to many groups, but can occur in one group only once.';
  
ALTER TABLE spell_loot_template 
  COMMENT 'Well, according to vocabulary the meaning of the word "loot" is good for corpse loot and may be for some gameobjects like chests but quite unfit for fishing "loot". Nevermind. We will use term "loot" here as "a set of items generated on an event for a player" and "loot definition" as "a set of rules for loot generation". And forget about vocabulary for a while.

This table format is used for 12 different tables to generate different loot items for different things. The 12 tables are creature_loot_template, disenchant_loot_template, fishing_loot_template, gameobject_loot_template, item_loot_template, pickpocketing_loot_template, prospecting_loot_template, skinning_loot_template, quest_mail_loot_template, reference_loot_template, milling_loot_template, spell_loot_template. The general description here is valid for all 12 because the loot system is the same for all eleven.

Loot templates define only items in the loot. See comments about money drop in corpse, pickpocketing and luggage loot in creature_template and item_template.';