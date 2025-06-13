#!/usr/bin/env lua

-- Pfade einrichten
local currentDir = os.getenv("PWD")
package.path = package.path .. ";" .. currentDir .. "/?.lua"

-- LÖVE-Mock global setzen, bevor Tests geladen werden
_G.love = require("tests.love_mock")

-- Busted mit unserem Setup laden
local status, err = pcall(function()
    os.exit(require("busted.runner")())
end)

if not status then
    print("Fehler beim Ausführen der Tests: " .. tostring(err))
    os.exit(1)
end
