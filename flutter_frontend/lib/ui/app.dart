import 'package:flutter/material.dart';
import 'package:flutter_frontend/ui/tic_tac_toe_screen.dart';

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  static const Color _primary = Color(0xFF3B82F6);
  static const Color _success = Color(0xFF06B6D4);
  static const Color _surface = Color(0xFFFFFFFF);
  static const Color _scaffold = Color(0xFFF9FAFB);
  static const Color _text = Color(0xFF111827);
  static const Color _muted = Color(0xFF64748B);
  static const Color _error = Color(0xFFEF4444);

  ThemeData _buildTheme() {
    final ColorScheme base = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.light,
      surface: _surface,
    );

    final ColorScheme scheme = base.copyWith(
      primary: _primary,
      secondary: _success,
      tertiary: _success,
      error: _error,
      onSurface: _text,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: _scaffold,
      textTheme: Typography.blackCupertino.copyWith(
        bodyLarge: const TextStyle(color: _text),
        bodyMedium: const TextStyle(color: _text),
        titleLarge: const TextStyle(color: _text, fontWeight: FontWeight.w700),
        titleMedium: const TextStyle(color: _text, fontWeight: FontWeight.w600),
        labelLarge: const TextStyle(fontWeight: FontWeight.w600),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _scaffold,
        foregroundColor: _text,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: _surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _primary.withAlpha(18)),
        ),
      ),
      dividerColor: _primary.withAlpha(18),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _muted,
          side: BorderSide(color: _primary.withAlpha(40)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: _buildTheme(),
      home: const TicTacToeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
