import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:minesweeper/cubit/cell.dart';

class GameBoard extends Equatable {
  final int rows;
  final int cols;
  final int mineCount;
  final List<List<Cell>> grid;

  int get totalCells => rows * cols;

  const GameBoard({
    required this.rows,
    required this.cols,
    required this.mineCount,
    this.grid = const [],
  });

  factory GameBoard.initial({
    required int rows,
    required int cols,
    required int mineCount,
  }) {
    return GameBoard(
      rows: rows,
      cols: cols,
      mineCount: mineCount,
      grid: generateGrid(rows, cols, mineCount),
    );
  }

  GameBoard copyWith({
    List<List<Cell>>? grid,
  }) {
    return GameBoard(
      rows: rows,
      cols: cols,
      mineCount: mineCount,
      grid: grid ?? this.grid,
    );
  }

  // Generate the grid and place mines
  static List<List<Cell>> generateGrid(int rows, int cols, int mineCount) {
    List<List<Cell>> grid =
        List.generate(rows, (r) => List.generate(cols, (c) => const Cell()));

    // Place mines randomly
    int placedMines = 0;
    var random = Random();
    while (placedMines < mineCount) {
      int row = random.nextInt(rows);
      int col = random.nextInt(cols);

      if (!grid[row][col].hasMine) {
        grid[row][col] = grid[row][col].copyWith(hasMine: true);
        placedMines++;
      }
    }

    // Calculate adjacent mines for each cell
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (!grid[r][c].hasMine) {
          grid[r][c] = grid[r][c].copyWith(
            adjacentMines: countAdjacentMines(grid, r, c),
          );
        }
      }
    }

    return grid;
  }

  // Count adjacent mines for a given cell
  static int countAdjacentMines(List<List<Cell>> grid, int row, int col) {
    int count = 0;
    for (int r = -1; r <= 1; r++) {
      for (int c = -1; c <= 1; c++) {
        int newRow = row + r;
        int newCol = col + c;
        if (newRow >= 0 &&
            newRow < grid.length &&
            newCol >= 0 &&
            newCol < grid.first.length) {
          if (grid[newRow][newCol].hasMine) {
            count++;
          }
        }
      }
    }
    return count;
  }

  // Reveal cell logic
  void revealCell(int row, int col) {
    if (grid[row][col].revealed || grid[row][col].flagged) return;
    grid[row][col] = grid[row][col].reveal();

    if (grid[row][col].adjacentMines == 0 && !grid[row][col].hasMine) {
      // Recursively reveal surrounding cells if there are no adjacent mines
      for (int r = -1; r <= 1; r++) {
        for (int c = -1; c <= 1; c++) {
          int newRow = row + r;
          int newCol = col + c;
          if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols) {
            revealCell(newRow, newCol);
          }
        }
      }
    }
  }

  @override
  List<Object?> get props => [grid];
}
