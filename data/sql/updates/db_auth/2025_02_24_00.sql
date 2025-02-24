-- DB update 2025_02_16_01 -> 2025_02_24_00
-- Copyright: SylCore - 2025
-- This updates the motd table in database "acore_auth".

UPDATE motd
SET text = 'Welcome to an SylCore Server.'
WHERE text = 'Welcome to an AzerothCore Server.';
