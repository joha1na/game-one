# Development Container für LÖVE2D-Spieleentwicklung

Dieser Ordner enthält die Konfiguration für einen Development Container, der automatisch eine Umgebung für die LÖVE2D-Spieleentwicklung einrichtet.

## Schnellstart

1. Starte den Container (wird automatisch erledigt in GitHub Codespaces)
2. Öffne ein Terminal und überprüfe die LÖVE-Installation mit `love --version`
3. Starte das Spiel mit `Strg+Shift+B` oder verwende den Terminal-Befehl `love .`

## Enthaltene Features

- LÖVE2D-Engine (Version 11.3)
- Git und GitHub CLI
- Lua-Entwicklungswerkzeuge (luarocks, luacheck)
- Vorkonfigurierte VS Code-Tasks für das Ausführen des Spiels

## VS Code-Tasks

Der Container richtet automatisch eine VS Code-Task ein, die es ermöglicht, das Spiel mit der Tastenkombination `Strg+Shift+B` zu starten.

## Hinweise zur Verwendung mit GitHub Codespaces

Da GitHub Codespaces standardmäßig keine GUI-Anwendungen unterstützen, ist es für die vollständige Spieleentwicklung empfehlenswert, die Entwicklung lokal durchzuführen oder einen X-Server einzurichten.

## Für lokale Entwicklung

Wenn du diesen Container lokal mit VS Code und Docker verwenden möchtest:

1. Installiere die Erweiterung "Dev Containers"
2. Klicke auf das grüne Symbol in der unteren linken Ecke
3. Wähle "Reopen in Container"
