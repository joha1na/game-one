#!/bin/bash

# Prüfen, ob LÖVE installiert ist
echo "Überprüfe LÖVE-Installation..."
love --version

# VS Code task.json überprüfen
mkdir -p /workspaces/game-one/.vscode
if [ ! -f /workspaces/game-one/.vscode/tasks.json ]; then
    echo "Erstelle tasks.json..."
    cat > /workspaces/game-one/.vscode/tasks.json << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Run Game",
            "type": "shell",
            "command": "love .",
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "isBackground": true,
            "problemMatcher": []
        }
    ]
}
EOF
fi

# Git-Konfiguration prüfen
if [ -z "$(git config --get user.email)" ]; then
    echo "Bitte Git-Benutzer konfigurieren mit:"
    echo "  git config --global user.name \"Dein Name\""
    echo "  git config --global user.email \"deine.email@example.com\""
fi

# Prüfen, ob wir eine .gitignore haben
if [ ! -f /workspaces/game-one/.gitignore ]; then
    echo "Erstelle .gitignore Datei für LÖVE-Projekte..."
    cat > /workspaces/game-one/.gitignore << 'EOF'
# OS junk
.DS_Store
Thumbs.db

# Lua/LÖVE2D backup files
*.bak
*~

# Highscore and save data
highscores.json

# Logs
*.log
EOF
fi

echo "Umgebung ist bereit für die LÖVE2D-Spieleentwicklung!"
echo "Verwende 'Strg+Shift+B', um dein Spiel zu starten."
