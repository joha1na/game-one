-- Ein einfaches Skript, um Tests mit dem LÖVE-Mock auszuführen
local _busted = require("busted")

-- Mock für LÖVE-Objekte und -Funktionen erstellen
_G.love = require("tests.love_mock")

-- Führe alle Tests im tests-Verzeichnis aus
os.exit(_busted({ standalone = false }))
