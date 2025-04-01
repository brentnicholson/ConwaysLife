Game of Life Code Exercise

For this exercise you will create an implementation of Conway’s Game of Life.

The Game of Life consists of a grid of square cells, each of which is in two possible states, alive  or dead. Every cell interacts with its eight neighbors, which are the cells that are horizontally, vertically, or diagonally adjacent. 

Each turn in the game is a new generation of cells. At each generation the following changes occur:

1. Any live cell with fewer than two live neighbors dies, as if by underpopulation.
2. Any live cell with two or three live neighbors lives on to the next generation.
3. Any live cell with more than three live neighbors dies, as if by overpopulation.
4. Any dead cell with exactly 3 live neighbors becomes a live cell, as if by reproduction.

The rules can be summarized into the following:
1. Any live cell with two to three neighbors survives.
2. Any dead cell with three live neighbors becomes a live cell.
3. All other live cells die in the next generation. All other dead cells stay dead.

The game is started with a seed that defines the state of each cell in the grid. The first generation is created by applying the rules simultaneously to every cell in the seed. The rules continue to be applied repeatedly to create further generations.

The final product of the exercise should include:
1. The ability to set the initial seed for the game.
2. A UI that displays the current generation of the grid.
3. A UI affordance for advancing the game one generation at a time.
4. The grid must be at least 10 columns and 10 rows.

The exercise should be completed as a working iOS app.

Screen Shot
![Simulator Screenshot - iPhone 16 Pro - 2025-04-01 at 11 19 25](https://github.com/user-attachments/assets/636d39a7-0fd0-4cbd-94fb-32fee5fb9c36)
