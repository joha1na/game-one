# Game One

A small space shooter game developed with [LÖVE2D](https://love2d.org/) and Lua, inspired by the CS50 Game Development course.

**Work in Progress:**
This project is a playground for experimenting with game development in Lua and LÖVE2D. The goal is to gradually build and expand a game, trying out new features and ideas along the way. The game might also end up not being about space and shooting.

## Features
- Control a spaceship
- Moving enemies
- Shooting and collision detection
- Scoring system and persistent highscore (using a local `highscores.json` file and a custom `json.lua` module)
- Start, pause, and game over screens

## Installation
1. [Download and install LÖVE2D](https://love2d.org/)
2. Clone this repository:
   ```sh
   git clone https://github.com/joha1na/game-one.git
   ```
3. Change into the directory:
   ```sh
   cd game-one
   ```
4. Start the game:
   ```sh
   love .
   ```

## Controls
- **Arrow keys**: Move the spaceship
- **Space**: Shoot
- **P**: Pause
- **Mouse**: Menu buttons
- **ESC**: Quit the game

## Highscore
Highscores are automatically saved to a `highscores.json` file (using the included `json.lua` module) and loaded on startup.  
You do **not** need to create this file manually – it will be created automatically the first time you achieve a score.

## Development
- The project is developed using [Cursor](https://www.cursor.so/), an AI-powered code editor.

## Credits
- Developed by Jana Maire ([joha1na](https://github.com/joha1na))
- Inspired by the CS50 Game Development course

---
Have fun playing and experimenting! 