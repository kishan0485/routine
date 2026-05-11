import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Core backgrounds ───────────────────────────────────────────────
  static const Color bgDark      = Color(0xFF09090F); // near-black
  static const Color surfaceDark = Color(0xFF13131F); // card bg
  static const Color cardDark    = Color(0xFF1C1C2E); // elevated card
  static const Color borderDark  = Color(0xFF2D2D4A); // subtle border

  // ── Brand ─────────────────────────────────────────────────────────
  static const Color primary      = Color(0xFF8B5CF6); // vivid violet
  static const Color primaryLight = Color(0xFFA78BFA);
  static const Color primaryDark  = Color(0xFF6D28D9);

  // ── Accents ───────────────────────────────────────────────────────
  static const Color accent  = Color(0xFF38BDF8); // sky blue
  static const Color gold    = Color(0xFFF59E0B); // premium amber
  static const Color emerald = Color(0xFF10B981); // success
  static const Color rose    = Color(0xFFF43F5E); // error / danger

  // ── Text ──────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted     = Color(0xFF475569);

  // ── Semantic ──────────────────────────────────────────────────────
  static const Color success = emerald;
  static const Color warning = gold;
  static const Color error   = rose;
  static const Color info    = accent;

  // ── Gradients ─────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF38BDF8), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient meshGradient = LinearGradient(
    colors: [Color(0xFF1E1033), Color(0xFF09090F), Color(0xFF0D1929)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  // ── Glow helpers ──────────────────────────────────────────────────
  static BoxShadow primaryGlow({double opacity = 0.35, double blur = 24}) =>
      BoxShadow(
        color: primary.withValues(alpha: opacity),
        blurRadius: blur,
        spreadRadius: 0,
      );

  static BoxShadow goldGlow({double opacity = 0.4, double blur = 20}) =>
      BoxShadow(
        color: gold.withValues(alpha: opacity),
        blurRadius: blur,
      );

  // ── Glass helpers ─────────────────────────────────────────────────
  static Color glassColor(bool isDark) =>
      isDark ? const Color(0x14FFFFFF) : const Color(0x80FFFFFF);

  static Color glassBorder(bool isDark) =>
      isDark ? const Color(0x22FFFFFF) : const Color(0x55FFFFFF);
}
