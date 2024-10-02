
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/cubit/game_board.dart';

part 'minesweeper_state.dart';

class MinesweeperCubit extends Cubit<MinesweeperState> {
  MinesweeperCubit({
    required int rows,
    required int cols,
    required int mineCount,
  }) : super(
          MinesweeperState(
            gameBoard: GameBoard.initial(
              rows: rows,
              cols: cols,
              mineCount: mineCount,
            ),
          ),
        ) {
    startTimer();
  }

  Stopwatch? stopwatch;

  void startTimer() {
    stopwatch = Stopwatch()..start();
  }

  void revealCell(int row, int col) {
    log('revealCell($row, $col)');

    if (state.gameOver || state.won) return;

    var cell = state.gameBoard.grid[row][col];
    if (cell.flagged || cell.revealed) return;

    state.gameBoard.revealCell(row, col);

    emit(state.copyWith());

    if (cell.hasMine) {
      stopwatch?.stop();
      emit(state.copyWith(
        gameOver: true,
        elapsed: stopwatch?.elapsed,
      ));

      print("Game Over! You hit a mine.");
    } else if (_checkWinCondition()) {
      stopwatch?.stop();
      emit(state.copyWith(
        won: true,
        elapsed: stopwatch?.elapsed,
      ));

      print("You win! All mines flagged and safe cells revealed.");
    }
  }

  void flagCell(int row, int col) {
    log('flagCell($row, $col)');
    var cell = state.gameBoard.grid[row][col];
    if (cell.revealed) return;

    state.gameBoard.grid[row][col] = cell.toggleFlag();

    emit(
      state.copyWith(
        flagsUsed: state.flagsUsed + (cell.flagged ? 1 : -1),
      ),
    );

    if (_checkWinCondition()) {
      stopwatch?.stop();
      emit(state.copyWith(
        won: true,
        elapsed: stopwatch?.elapsed,
      ));
      print("You win! All mines flagged and safe cells revealed.");
    }
  }

  // Check if all non-mine cells are revealed or all mines are flagged
  bool _checkWinCondition() {
    for (var row in state.gameBoard.grid) {
      for (var cell in row) {
        if (!cell.hasMine && !cell.revealed) return false;
        if (cell.hasMine && !cell.flagged) return false;
      }
    }
    return true;
  }

  void resetAllFlags() {
    log('resetAllFlags()');
    for (var row in state.gameBoard.grid) {
      for (var i = 0; i < row.length; i++) {
        if (row[i].flagged) {
          row[i] = row[i].toggleFlag();
        }
      }
    }
    emit(
      state.copyWith(
        flagsUsed: 0,
      ),
    );
  }
}
