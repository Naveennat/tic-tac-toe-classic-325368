/// Tic Tac Toe game engine (pure module; no Flutter/UI dependencies).
library;

/// A player mark on the board.
enum PlayerMark { x, o }

/// Converts a [PlayerMark] to its display symbol.
extension PlayerMarkSymbol on PlayerMark {
  String get symbol => this == PlayerMark.x ? 'X' : 'O';
}

/// Represents the lifecycle status of a game.
enum GameStatus { inProgress, won, draw }

/// Immutable game state for a 3x3 Tic Tac Toe board.
class GameState {
  /// Board cells; length is always 9. Null indicates an empty cell.
  final List<PlayerMark?> board;

  /// The player who should play next (only meaningful when [status] is inProgress).
  final PlayerMark next;

  /// Current status (in progress, won, or draw).
  final GameStatus status;

  /// Winner if status is won; otherwise null.
  final PlayerMark? winner;

  /// Winning line indices (length 3) if won; otherwise null.
  final List<int>? winningLine;

  const GameState({
    required this.board,
    required this.next,
    required this.status,
    this.winner,
    this.winningLine,
  });

  /// Creates a fresh game.
  factory GameState.initial() {
    return const GameState(
      board: <PlayerMark?>[null, null, null, null, null, null, null, null, null],
      next: PlayerMark.x,
      status: GameStatus.inProgress,
      winner: null,
      winningLine: null,
    );
  }

  GameState copyWith({
    List<PlayerMark?>? board,
    PlayerMark? next,
    GameStatus? status,
    PlayerMark? winner,
    List<int>? winningLine,
  }) {
    return GameState(
      board: board ?? this.board,
      next: next ?? this.next,
      status: status ?? this.status,
      winner: winner,
      winningLine: winningLine,
    );
  }
}

/// The result of applying a move intent.
class ApplyMoveResult {
  final GameState state;

  const ApplyMoveResult(this.state);
}

/// A tiny reducer-style engine for Tic Tac Toe.
///
/// Contract:
/// - All functions are pure (no side effects).
/// - UI is responsible for holding the current [GameState].
class TicTacToeEngine {
  const TicTacToeEngine();

  /// PUBLIC_INTERFACE
  /// Applies a move at [index] (0..8) and returns the resulting [GameState].
  ///
  /// If the move is invalid (out of range, cell occupied, or game finished),
  /// the state is returned unchanged.
  ApplyMoveResult applyMove({required GameState state, required int index}) {
    if (state.status != GameStatus.inProgress) return ApplyMoveResult(state);
    if (index < 0 || index > 8) return ApplyMoveResult(state);
    if (state.board[index] != null) return ApplyMoveResult(state);

    final List<PlayerMark?> newBoard = List<PlayerMark?>.from(state.board);
    newBoard[index] = state.next;

    final _Outcome outcome = _evaluateBoard(newBoard);
    if (outcome.winner != null) {
      return ApplyMoveResult(
        state.copyWith(
          board: newBoard,
          status: GameStatus.won,
          winner: outcome.winner,
          winningLine: outcome.winningLine,
        ),
      );
    }

    if (outcome.isDraw) {
      return ApplyMoveResult(
        state.copyWith(
          board: newBoard,
          status: GameStatus.draw,
          winner: null,
          winningLine: null,
        ),
      );
    }

    return ApplyMoveResult(
      state.copyWith(
        board: newBoard,
        next: state.next == PlayerMark.x ? PlayerMark.o : PlayerMark.x,
        status: GameStatus.inProgress,
        winner: null,
        winningLine: null,
      ),
    );
  }

  /// PUBLIC_INTERFACE
  /// Returns a brand-new initial state (restart).
  GameState reset() => GameState.initial();

  _Outcome _evaluateBoard(List<PlayerMark?> board) {
    const List<List<int>> lines = <List<int>>[
      <int>[0, 1, 2],
      <int>[3, 4, 5],
      <int>[6, 7, 8],
      <int>[0, 3, 6],
      <int>[1, 4, 7],
      <int>[2, 5, 8],
      <int>[0, 4, 8],
      <int>[2, 4, 6],
    ];

    for (final List<int> line in lines) {
      final PlayerMark? a = board[line[0]];
      final PlayerMark? b = board[line[1]];
      final PlayerMark? c = board[line[2]];
      if (a != null && a == b && b == c) {
        return _Outcome(winner: a, winningLine: line, isDraw: false);
      }
    }

    final bool allFilled = board.every((PlayerMark? m) => m != null);
    return _Outcome(winner: null, winningLine: null, isDraw: allFilled);
  }
}

class _Outcome {
  final PlayerMark? winner;
  final List<int>? winningLine;
  final bool isDraw;

  const _Outcome({
    required this.winner,
    required this.winningLine,
    required this.isDraw,
  });
}
