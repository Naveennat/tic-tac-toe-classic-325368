import 'package:flutter/material.dart';
import 'package:flutter_frontend/game_engine/tic_tac_toe_engine.dart';

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  static const double _maxContentWidth = 520;

  final TicTacToeEngine _engine = const TicTacToeEngine();

  late GameState _state;

  @override
  void initState() {
    super.initState();
    _state = GameState.initial();
  }

  void _onCellTap(int index) {
    final ApplyMoveResult result = _engine.applyMove(state: _state, index: index);
    if (identical(result.state, _state)) return;

    setState(() {
      _state = result.state;
    });
  }

  void _onReset() {
    setState(() {
      _state = _engine.reset();
    });
  }

  String _statusText(GameState state) {
    switch (state.status) {
      case GameStatus.inProgress:
        return 'Turn: ${state.next.symbol}';
      case GameStatus.won:
        return '${state.winner?.symbol} wins!';
      case GameStatus.draw:
        return 'Draw game';
    }
  }

  Color _statusColor(ThemeData theme, GameState state) {
    switch (state.status) {
      case GameStatus.inProgress:
        return theme.colorScheme.onSurface;
      case GameStatus.won:
        return theme.colorScheme.secondary;
      case GameStatus.draw:
        return theme.colorScheme.tertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: <Widget>[
                  _HeaderCard(
                    statusText: _statusText(_state),
                    statusColor: _statusColor(theme, _state),
                    subtitle: _state.status == GameStatus.inProgress
                        ? 'Tap a tile to place your mark'
                        : 'Press Reset to play again',
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _BoardCard(
                          state: _state,
                          onCellTap: _onCellTap,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _onReset,
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final String statusText;
  final Color statusColor;
  final String subtitle;

  const _HeaderCard({
    required this.statusText,
    required this.statusColor,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: <Widget>[
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    statusText,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BoardCard extends StatelessWidget {
  final GameState state;
  final void Function(int index) onCellTap;

  const _BoardCard({
    required this.state,
    required this.onCellTap,
  });

  bool _isWinningIndex(int index) {
    final List<int>? line = state.winningLine;
    if (line == null) return false;
    return line.contains(index);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color border = theme.colorScheme.primary.withAlpha(35);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                final PlayerMark? mark = state.board[index];
                final bool canTap = state.status == GameStatus.inProgress && mark == null;

                final bool highlight = _isWinningIndex(index);
                final Color tileBg = highlight
                    ? theme.colorScheme.secondary.withAlpha(18)
                    : theme.colorScheme.primary.withAlpha(8);

                final Color tileBorder = highlight
                    ? theme.colorScheme.secondary.withAlpha(90)
                    : theme.colorScheme.primary.withAlpha(25);

                final Color symbolColor = mark == PlayerMark.x
                    ? theme.colorScheme.primary
                    : theme.colorScheme.secondary;

                return _BoardTile(
                  onTap: canTap ? () => onCellTap(index) : null,
                  background: tileBg,
                  border: tileBorder,
                  symbol: mark?.symbol ?? '',
                  symbolColor: symbolColor,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _BoardTile extends StatelessWidget {
  final VoidCallback? onTap;
  final Color background;
  final Color border;
  final String symbol;
  final Color symbolColor;

  const _BoardTile({
    required this.onTap,
    required this.background,
    required this.border,
    required this.symbol,
    required this.symbolColor,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: border),
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 160),
            style: theme.textTheme.titleLarge!.copyWith(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: symbol.isEmpty
                  ? theme.colorScheme.onSurface.withAlpha(70)
                  : symbolColor,
              letterSpacing: 0.5,
            ),
            child: Text(symbol),
          ),
        ),
      ),
    );
  }
}
