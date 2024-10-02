import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/cubit/minesweeper_cubit.dart';

class MinesweeperView extends StatelessWidget {
  const MinesweeperView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = MinesweeperCubit(
      cols: 9,
      rows: 9,
      mineCount: 10,
    );
    return BlocProvider(
      create: (context) => cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Minesweeper'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
          ],
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  BlocSelector<MinesweeperCubit, MinesweeperState, int>(
                    selector: (state) {
                      return state.gameBoard.mineCount + state.flagsUsed;
                    },
                    builder: (context, value) {
                      return Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            cubit.resetAllFlags();
                          },
                          icon: const Icon(
                            Icons.flag,
                          ),
                          label: Text('$value'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  StreamBuilder(
                      stream: Stream.periodic(const Duration(seconds: 1)),
                      builder: (context, snapshot) {
                        final time = cubit.stopwatch?.elapsed;
                        return Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.timer_sharp,
                            ),
                            label: time == null
                                ? const Text('00:00')
                                : Text(
                                    '${time.inMinutes.toString().padLeft(2, '0')}:${time.inSeconds.remainder(60).toString().padLeft(2, '0')}'),
                          ),
                        );
                      })
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<MinesweeperCubit, MinesweeperState>(
                builder: (context, state) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: state.gameBoard.cols,
                    ),
                    itemCount: state.gameBoard.totalCells,
                    itemBuilder: (context, index) {
                      int row = index ~/ state.gameBoard.rows;
                      int col = index % state.gameBoard.cols;
                      var cell = state.gameBoard.grid[row][col];

                      return GestureDetector(
                        onTap: () => cubit.revealCell(row, col),
                        onLongPress: () => cubit.flagCell(row, col),
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: cell.revealed
                                ? Colors.grey
                                : Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              cell.revealed
                                  ? (cell.hasMine
                                      ? '💣'
                                      : (cell.adjacentMines > 0
                                          ? '${cell.adjacentMines}'
                                          : ''))
                                  : (cell.flagged ? '🚩' : ''),
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
