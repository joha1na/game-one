# Tests für Game One

Dieses Verzeichnis enthält Tests für das Spiel, die mit dem [Busted](https://olivinelabs.com/busted/) Test-Framework geschrieben wurden.

## Installation von Busted

Um die Tests auszuführen, müssen Sie zuerst Busted installieren. Dies kann über LuaRocks erfolgen:

```bash
luarocks install busted
```

Falls Sie LuaRocks nicht haben, müssen Sie dies zuerst installieren:

### Unter macOS mit Homebrew:
```bash
brew install luarocks
```

### Unter Linux (Ubuntu/Debian):
```bash
sudo apt-get install luarocks
```

## Tests ausführen

Um alle Tests auszuführen, verwenden Sie das folgende Kommando im Hauptverzeichnis des Projekts:

```bash
lua run_tests.lua
```

Oder wenn Sie Busted direkt ausführen möchten:

```bash
cd /pfad/zum/projekt
busted tests
```

## Teststruktur

Die Tests sind nach den Modulen organisiert:

- `player_spec.lua`: Tests für die Player-Klasse
- `collision_spec.lua`: Tests für die Kollisionserkennung
- `highscore_spec.lua`: Tests für die Highscore-Funktionen
- `test_helper.lua`: Gemeinsame Hilfsfunktionen und Setup für alle Tests
- `love_mock.lua`: Mock-Implementierung der LÖVE-Engine für Tests

## Test Helper

Alle Tests verwenden den `test_helper.lua`, um gemeinsame Funktionalitäten zu teilen. Der Test-Helper:

1. Lädt den LÖVE-Mock und macht ihn global verfügbar
2. Stellt gemeinsame Hilfsfunktionen für Tests bereit

## Tests hinzufügen

Um neue Tests hinzuzufügen, erstellen Sie eine neue Datei mit der Benennung `name_spec.lua` im `tests`-Verzeichnis. Die Teststruktur folgt dem Busted-Format:

```lua
-- Test-Helper laden (setzt LÖVE-Mock global)
require('tests.test_helper')

-- Module laden, die getestet werden sollen
local MyModule = require('path.to.module')

describe('Modulname', function()
  it('sollte etwas tun', function()
    -- Test-Code
    assert.is_true(condition)
  end)
end)
```

## Versionskontrolle

Die folgenden Test-Dateien sollten im Repository veröffentlicht werden:

- Alle `*_spec.lua`-Dateien (die eigentlichen Tests)
- `test_helper.lua` (Gemeinsames Test-Setup)
- `love_mock.lua` (Mock für die LÖVE-Engine)
- `run_with_mock.lua` (Helfer-Skript)
- `.busted` (Konfigurationsdatei)
- `run_tests.lua` (Test-Runner)
- Diese README-Datei

Die folgenden temporären Test-Dateien sind in der `.gitignore` und sollten **nicht** veröffentlicht werden:

- Alle Dateien im `/tests/coverage/`-Verzeichnis
- Alle Dateien im `/tests/reports/`-Verzeichnis
- Alle Dateien im `/tests/temp/`-Verzeichnis
- Alle temporären Test-Dateien (`*.tmp`)
- LuaCov-Statistik und Bericht-Dateien (`luacov.stats.out`, `luacov.report.out`)
- Busted-Ausgabedateien (`.busted.out`)
