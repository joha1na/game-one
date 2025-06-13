-- test_helper.lua
-- Hilfsfunktionen und Setup für Tests

-- LÖVE-Mock laden und global verfügbar machen
local loveMock = require('tests.love_mock')
_G.love = loveMock

-- Weitere globale Hilfsfunktionen für Tests können hier hinzugefügt werden

return {
    -- Hilfsfunktionen, die explizit importiert werden müssen
}
