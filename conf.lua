function love.conf(t)
    -- t ist eine Tabelle mit allen möglichen LÖVE-Konfigurationsoptionen
    -- Wir können verschiedene Eigenschaften dieser Tabelle setzen
    
    -- Grundlegende Spielinformationen
    t.identity = "game-one"        -- Name des Speicherverzeichnisses
    t.version = "11.5"                  -- LÖVE-Version
    t.console = false                   -- Konsolenfenster anzeigen (nur Windows)
    
    -- Fenster-Einstellungen (t.window ist eine Untertabelle)
    t.window.title = "Game One"    -- Fenstertitel
    t.window.width = 800               -- Fensterbreite
    t.window.height = 600              -- Fensterhöhe
    t.window.resizable = false         -- Größenänderung erlauben
    t.window.vsync = true              -- Vertikale Synchronisation
    t.window.minwidth = 800            -- Minimale Fensterbreite
    t.window.minheight = 600           -- Minimale Fensterhöhe
    
    -- Module aktivieren/deaktivieren (t.modules ist eine Untertabelle)
    t.modules.audio = true             -- Audio-Modul
    t.modules.event = true             -- Event-Modul
    t.modules.graphics = true          -- Grafik-Modul
    t.modules.image = true             -- Bild-Modul
    t.modules.joystick = true          -- Joystick-Unterstützung
    t.modules.keyboard = true          -- Tastatur-Unterstützung
    t.modules.math = true              -- Mathematik-Funktionen
    t.modules.mouse = true             -- Maus-Unterstützung
    t.modules.physics = true           -- Physik-Engine
    t.modules.sound = true             -- Sound-Unterstützung
    t.modules.system = true            -- System-Funktionen
    t.modules.timer = true             -- Timer-Funktionen
    t.modules.window = true            -- Fenster-Funktionen
end 