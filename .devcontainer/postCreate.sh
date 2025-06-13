#!/bin/bash
set -e

echo "🎮 Konfiguriere LÖVE2D-Entwicklungsumgebung für Tests und Code-Entwicklung..."

# Prüfen, ob LÖVE installiert ist
echo "✅ Überprüfe LÖVE-Installation..."
if ! command -v love &> /dev/null; then
    echo "❌ LÖVE ist nicht installiert! DevContainer-Setup fehlgeschlagen."
    exit 1
fi
love --version

# Arbeitsverzeichnis ermitteln
WORKSPACE_DIR=$(pwd)
echo "📂 Arbeitsverzeichnis: $WORKSPACE_DIR"

# VS Code task.json erstellen
mkdir -p $WORKSPACE_DIR/.vscode
if [ ! -f $WORKSPACE_DIR/.vscode/tasks.json ] || grep -q "Run Game" "$WORKSPACE_DIR/.vscode/tasks.json"; then
    echo "📄 Erstelle tasks.json..."
    cat > $WORKSPACE_DIR/.vscode/tasks.json << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Run Tests",
            "type": "shell",
            "command": "lua run_tests.lua",
            "group": {
                "kind": "test",
                "isDefault": true
            },
            "presentation": {
                "reveal": "always",
                "panel": "new"
            }
        },
        {
            "label": "Run Game Headless",
            "type": "shell",
            "command": "SDL_AUDIODRIVER=dummy SDL_VIDEODRIVER=dummy love .",
            "group": "build",
            "problemMatcher": []
        }
    ]
}
EOF
fi

# Git-Konfiguration prüfen
if [ -z "$(git config --get user.email)" ]; then
    echo "ℹ️ Hinweis: Git-Benutzer noch nicht konfiguriert"
    echo "  Benutze: git config --global user.name \"Dein Name\""
    echo "  und:     git config --global user.email \"deine.email@example.com\""
fi

echo "⚠️ WICHTIGER HINWEIS ZUR GUI-UNTERSTÜTZUNG:"
echo "   Dieser Container unterstützt KEINE grafische Darstellung von LÖVE-Spielen."
echo "   Dies ist eine Einschränkung sowohl bei lokalen Containern als auch bei GitHub Codespaces."
echo ""
echo "🧪 Diese Umgebung ist optimiert für:"
echo "   - Codeentwicklung und -bearbeitung"
echo "   - Ausführen und Entwickeln von Tests"
echo "   - Headless-Ausführung des Spiels zu Debug-Zwecken"
echo ""
echo "✅ Verfügbare Befehle:"
echo "   - 'lua run_tests.lua': Tests ausführen (auch mit Strg+Shift+T)"
echo "   - 'SDL_AUDIODRIVER=dummy SDL_VIDEODRIVER=dummy love .': Spiel im Headless-Modus ausführen"
echo ""
echo "🖥️ Für die vollständige Spieleentwicklung mit grafischer Darstellung:"
echo "   Wir empfehlen eine lokale LÖVE-Installation ohne Container."
