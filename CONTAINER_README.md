# LÖVE2D Development Container

Dieses Projekt enthält einen Development Container für die LÖVE2D-Spieleentwicklung. Der Container ist in erster Linie für **code-fokussierte Entwicklung** und **automatisierte Tests** konzipiert.

## ⚠️ Wichtige Hinweise zur Verwendung

### GUI-Limitierung im Container

Der DevContainer und GitHub Codespaces **unterstützen keine grafische Darstellung** von LÖVE-Spielen. Dies ist eine grundlegende Limitierung von containerbasierten Entwicklungsumgebungen, insbesondere in der Cloud.

### Empfohlener Workflow

1. **Für Codierung und Tests**: Verwenden Sie den DevContainer oder GitHub Codespaces.
2. **Für Spielvisualisierung und vollständige Entwicklung**: Verwenden Sie eine lokale LÖVE-Installation.

## Starten des Containers

### Lokal mit VS Code
1. Stellen Sie sicher, dass Docker und die VS Code-Erweiterung "Dev Containers" installiert sind.
2. Öffnen Sie diesen Ordner in VS Code.
3. Klicken Sie auf das grüne Symbol unten links und wählen Sie "Reopen in Container".

### Mit GitHub Codespaces
1. Öffnen Sie das Repository auf GitHub.
2. Klicken Sie auf "Code" > "Open with Codespaces" > "New codespace".

## Verfügbare VS Code-Tasks

Der Container richtet automatisch folgende Tasks ein:
- **Run Tests**: Führt Busted-Tests aus (Tastenkürzel: Strg+Shift+T)
- **Run Game Headless**: Führt das Spiel ohne Grafik aus (nur für Debug-Zwecke)

## Detaillierte Dokumentation

Eine vollständige Dokumentation mit allen Features und Ausführungsoptionen finden Sie im Ordner `.devcontainer/README.md`.
