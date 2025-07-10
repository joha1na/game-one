# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a 2D space shooter game built with LÖVE2D (Love2D) and Lua. The game features a player-controlled spaceship fighting against enemies with shooting, collision detection, and a persistent highscore system.

## Development Commands

### Running the Game

```bash
love .
```

### Running Tests

```bash
lua run_tests.lua
```

Tests require Busted framework:

```bash
luarocks install busted
```

## Architecture

### Core Game Structure

- **main.lua**: Game entry point with main game loop, state management, and event handling
- **conf.lua**: LÖVE2D configuration (window size: 800x600, modules enabled)
- **Game States**: "start", "playing", "paused", "gameOver", "restart"

### Entity System

- **entities/Player.lua**: Player spaceship with movement, shooting, health, and invincibility
- **entities/Enemy.lua**: Enemy ships with AI movement and shooting
- **entities/UI.lua**: UI rendering for all game states

### Constants

- **constants/Game.lua**: Game timing constants (shoot cooldowns)
- **constants/UI.lua**: UI layout constants

### Graphics & Audio

- **graphics/Graphics.lua**: Sprite rendering, background, particles, explosions
- **graphics/UIEffects.lua**: Screen shake, score popups, fade effects
- **graphics/Audio.lua**: Sound effects system

### Data Management

- **highscore.lua**: Persistent highscore system using JSON
- **json.lua**: JSON parsing module
- **highscores.json**: Highscore data file (auto-created)

### Testing

- **tests/**: Unit tests using Busted framework
- **tests/love_mock.lua**: Mock LÖVE2D implementation for testing
- **tests/test_helper.lua**: Common test utilities
- **run_tests.lua**: Test runner script

## Key Game Systems

### Collision Detection

Global `checkCollision(a, b)` function for rectangle-based collision detection between bullets, player, and enemies.

### Game State Flow

1. **Start Screen**: Menu with play button
2. **Playing**: Active gameplay with collision detection and scoring
3. **Paused**: Game paused with resume option
4. **Game Over**: Score display and restart option

### Bullet System

- Two separate bullet arrays: `game.bullets` (player) and `game.enemyBullets` (enemies)
- Automatic cleanup of off-screen bullets
- Collision detection between bullets and targets

### Visual Effects

- Particle explosions on enemy destruction
- Screen shake on collisions and damage
- Player invincibility flashing
- Score popup animations
- Animated starfield background

## Code Conventions

- German comments and variable names are used throughout
- Entity classes use metatables for OOP structure
- Constants are centralized in the `constants/` directory
- All graphics rendering goes through the Graphics module
- UI effects are handled by the UIEffects module

## File Structure Notes

- Game uses modular Lua architecture with `require()` statements
- Entity files return class tables with constructor functions
- Graphics files handle rendering and visual effects
- Test files use `*_spec.lua` naming convention

## Learning Support Guidelines

When working on code changes, prioritize educational value:

### Step-by-Step Approach

- Break down complex tasks into smaller, understandable steps
- Explain the reasoning behind each decision before implementing
- Show alternative approaches when relevant
- Use the TodoWrite tool to track and explain the implementation plan

### Code Explanations

- Explain what each code section does and why it's structured that way
- Point out game development patterns and Lua-specific concepts
- Explain Love2D framework features when using them
- Highlight connections between different parts of the codebase

### Educational Focus

- Prioritize understanding over speed
- Ask clarifying questions about learning goals
- Explain debugging strategies when fixing issues
- Discuss performance considerations and optimization opportunities
