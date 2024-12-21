# AlmostMario


## Overview

This project was created to learn game development with Swift and SpriteKit. The game is a platformer inspired by Mario, aimed at mastering the basics of game engines, physics, animations, and object interactions. It is not a copy of Mario but an educational experiment to explore technologies.

---

## Features

- **Character Movement**: Control Mario to move left, right, and jump.
- **Collectibles**: Earn coins by interacting with specific objects.
- **Enemies**: Avoid or defeat moving enemies.
- **Game Endings**: Game over and victory sequences with appropriate animations and transitions.
- **Restart Option**: Restart the game at any point via an in-game button.

---

## Requirements

- iOS 14.0 or later
- Xcode 13.0 or later
- Swift 5.0 or later

---

## Gameplay Instructions

### **Controls**:
   - **Left Button**: Move Mario left.
   - **Right Button**: Move Mario right.
   - **Up Button**: Make Mario jump.
   - **Restart Button**: Restart the game.

![moving](https://github.com/user-attachments/assets/d08a69ef-02b9-405c-b173-a76b26e00648)


### **Objectives**:
   - Collect coins by hitting question blocks.
   - Avoid enemies or defeat them by jumping on them.
   - Reach the flag to complete the level.

![collect](https://github.com/user-attachments/assets/70c247a2-f821-4045-b2f6-261b67ad5e3b)


### **Challenges**:
   - Mario has limited lives; touching an enemy without jumping on it will result in a game over.

![death](https://github.com/user-attachments/assets/723d489a-bf02-4af2-aa53-0933b4af0daa)


---

## Code Architecture

- **GameScene.swift**: Handles the main game logic, including physics, collisions, and gameplay events.
- **MarioController.swift**: Manages Mario's movement, animations, and interactions with the environment.

---

## Key Functionalities

- **Physics Bodies**:
  - Mario interacts with various elements like ground, walls, enemies, and question blocks using defined physics categories.
  
- **Animations**:
  - Mario has smooth animations for moving left, right, jumping, and idle states.
  
- **Transitions**:
  - After completing a level or losing, the game transitions back to the main menu with fade-in/out effects.

---

## How to Run

1. Open the project in Xcode.
2. Select a target device or simulator.
3. Press the **Run** button to launch the game.

---

## Future Improvements

- Add more levels with increasing difficulty.
- Introduce new enemies and power-ups.
- Implement background music and sound effects.
- Create a scoring system with leaderboards.

## Gameplay

https://github.com/user-attachments/assets/34868e26-ee77-4c65-b9e6-2f110252e43f

