// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Cell extends Equatable {
  final bool hasMine;
  final int adjacentMines;
  final bool revealed;
  final bool flagged;

  const Cell({
    this.hasMine = false,
    this.adjacentMines = 0,
    this.revealed = false,
    this.flagged = false,
  });

  Cell reveal() {
    return copyWith(revealed: true);
  }

  Cell toggleFlag() {
    return copyWith(flagged: !flagged);
  }

  Cell copyWith({
    bool? hasMine,
    int? adjacentMines,
    bool? revealed,
    bool? flagged,
  }) {
    return Cell(
      hasMine: hasMine ?? this.hasMine,
      adjacentMines: adjacentMines ?? this.adjacentMines,
      revealed: revealed ?? this.revealed,
      flagged: flagged ?? this.flagged,
    );
  }

  @override
  List<Object?> get props => [hasMine, adjacentMines, revealed, flagged];
}
