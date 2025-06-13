# Development Container für LÖVE2D-Spieleentwicklung

Dieser Ordner enthält die Konfiguration für einen Development Container, der automatisch eine Umgebung für die LÖVE2D-Spieleentwicklung einrichtet. Der Container ist primär für code-fokussierte Entwicklungsaufgaben und das Ausführen von Tests konzipiert.

## ⚠️ Wichtiger Hinweis zur GUI-Unterstützung

**Dieser Container unterstützt keine GUI-Anwendungen**, und LÖVE-Spiele können nicht visuell ausgeführt werden. Dies ist eine Einschränkung sowohl bei lokalen Docker-Containern als auch bei GitHub Codespaces.

Die Gründe hierfür sind:
1. Fehlende X11/Wayland-Unterstützung in Standard-Containern
2. Keine direkte Grafikkartenunterstützung in Containern
3. Bei GitHub Codespaces zusätzlich: Cloud-basierte Ausführung ohne lokalen Display-Server

## Hauptanwendungszwecke

Der Container ist ideal für:
- Codeentwicklung und -bearbeitung
- Ausführen und Entwickeln von Tests mit Busted
- Code-Reviews und Pull Requests
- Kollaboratives Arbeiten am Projekt
- CI/CD-Integration für automatisierte Tests

## Enthaltene Features

- LÖVE2D-Engine (nur für Tests und Headless-Ausführung)
- Busted Test-Framework für Lua
- Git und GitHub CLI
- Lua-Entwicklungswerkzeuge (luarocks, luacheck, luacov, inspect)
- Vorkonfigurierte VS Code-Tasks

## VS Code-Tasks

Der Container richtet automatisch folgende VS Code-Tasks ein:

- **Run Tests** (`Strg+Shift+T`): Führt die Busted-Tests aus
- **Run Game Headless**: Führt das Spiel im Headless-Modus aus (ohne Grafik/Audio)

## Container starten

**Lokal mit VS Code und Docker:**
1. Installiere die Erweiterung "Dev Containers"
2. Öffne das Projekt und klicke auf die grüne Schaltfläche unten links
3. Wähle "Reopen in Container"

**Mit GitHub Codespaces:**
1. Öffne das Repository auf GitHub
2. Klicke auf "Code" > "Open with Codespaces"
3. Wähle "New codespace"

## Ausführungsoptionen im Container

### 1. Headless-Ausführung für Debug-Zwecke

Für Debug- und Testzwecke kann das Spiel im Headless-Modus ausgeführt werden:

```bash
# Mit der VS Code Task
> Run Game Headless

# Oder direkt im Terminal:
SDL_AUDIODRIVER=dummy SDL_VIDEODRIVER=dummy love .
```

Diese Ausführung zeigt keine Grafik, kann aber für Debugging, Logging und grundlegende Funktionalitätstests verwendet werden.

### 2. Tests ausführen

Tests können mit dem integrierten Test-Framework ausgeführt werden:

```bash
# Mit der VS Code Task
> Run Tests

# Oder direkt im Terminal:
lua run_tests.lua
```

### 3. Erweiterte Lösungen (nur für Fortgeschrittene)

Für spezielle Anwendungsfälle können folgende fortgeschrittene Techniken verwendet werden, die jedoch nicht standardmäßig eingerichtet sind:

**X11-Forwarding**: Funktioniert nur mit zusätzlichen Konfigurationsschritten auf dem Host-System.
**VNC-Server**: Erfordert zusätzliche Software-Installation und Konfiguration.
**Xvfb**: Mit dem Skript `run_with_xvfb.sh` kann das Spiel in einem virtuellen Framebuffer ausgeführt werden.

## Empfehlung für vollständige Spieleentwicklung

Für die vollständige Entwicklung des Spiels mit grafischer Darstellung empfehlen wir:
- Lokale Installation von LÖVE (ohne Container)
- Lokale VS Code-Installation mit Lua-Erweiterungen
- Verwendung des Containers nur für Tests und Code-Review
