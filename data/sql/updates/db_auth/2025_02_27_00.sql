-- DB update 2025_02_24_00 -> 2025_02_27_00
-- Copyright: SylCore - 2025
-- This updates the motd table in database "acore_auth".

UPDATE motd
SET text = 'Welcome to a SylCore Server.'
WHERE text = 'Welcome to an SylCore Server.' AND realmid = -1;

UPDATE realmlist
SET name = 'SylCore'
WHERE name = 'AzerothCore' AND id = 1