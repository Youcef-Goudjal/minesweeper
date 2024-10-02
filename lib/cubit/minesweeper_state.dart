part of 'minesweeper_cubit.dart';

class MinesweeperState extends Equatable {
  final GameBoard gameBoard;
  final bool gameOver;
  final bool won;
  final int flagsUsed;
  final int tapCount;
  final Duration? elapsed;

  const MinesweeperState({
    required this.gameBoard,
    this.gameOver = false,
    this.won = false,
    this.flagsUsed = 0,
    this.tapCount = 0,
    this.elapsed,
  });

  @override
  List<Object> get props => [gameBoard, gameOver, won, flagsUsed, tapCount];

  MinesweeperState copyWith({
    GameBoard? gameBoard,
    bool? gameOver,
    bool? won,
    int? flagsUsed,
    Duration? elapsed,
  }) {
    return MinesweeperState(
      gameBoard: gameBoard ?? this.gameBoard,
      gameOver: gameOver ?? this.gameOver,
      won: won ?? this.won,
      flagsUsed: flagsUsed ?? this.flagsUsed,
      tapCount: tapCount + 1,
      elapsed: elapsed ?? this.elapsed,
    );
  }
}
