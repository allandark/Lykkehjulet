# Lykkehjulet Festspil
Gameengine: Godot
Platform: Windows 11

## Regler
### Game Components

#### 1.1 Overview

Type: Word puzzle game show
Players: 3 contestants
Objective: Accumulate the highest total cash and prizes by solving word puzzles.

#### 2.1 Wheel
Circular wheel divided into wedges.
Wedge types:
- Cash amounts (e.g., $500, $900, etc.)
Special wedges:
- Falit
- Tabt Tur
- Wild Card
- Prize wedges
- Express (in some rounds)
- Million Dollar Wedge (when in use)

2.2 Puzzle Board
Displays:
- Sætninger (hidden until correctly guessed)
- Category (e.g., Phrase, Person, Thing, Event)
Puzzle consists of letters A–Z and may include punctuation or symbols.
2.3 Letter Rules

Consonants: Must be guessed after spinning the wheel.

Vowels (A, E, I, O, U): Must be purchased for $250 each.


#### 3.1 Standard Round Flow

3.1 Turn Order
Determined prior to Round 1.

Play proceeds clockwise among contestants.
3.2 Turn Actions
On a contestant’s turn:
- Option A: Spin the Wheel
  - Spin wheel.
  - If wheel lands on:
    - Cash wedge: Guess one consonant.
    - Bankrupt: Lose all accumulated round earnings; turn ends.
    - Lose a Turn: Turn ends immediately.
    - Special wedge: Follow wedge-specific rules. (tbd)

  - If consonant:
    - Is in puzzle:
      - Earn (wedge value × number of occurrences).
      - Continue turn.
    - Is not in puzzle:
      - No earnings.
      - Turn passes.

- Option B: Buy a Vowel
  - Cost: $250 (must have sufficient funds).
  - If vowel appears:
    - Reveal all instances.
    - Continue turn.
  - If not:
    - Turn ends.

- Option C: Solve the Puzzle
  - Contestant states full puzzle.
  - If correct:
    - Wins accumulated cash/prizes for that round.
    - Round ends.
  - If incorrect:
    - Turn ends.