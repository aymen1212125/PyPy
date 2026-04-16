import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF13131A);
  static const Color surfaceHigh = Color(0xFF1C1C27);
  static const Color accent = Color(0xFF7B61FF);
  static const Color accentGlow = Color(0x337B61FF);
  static const Color accentSecond = Color(0xFF00D2FF);
  static const Color textPrimary = Color(0xFFF0F0FF);
  static const Color textSecond = Color(0xFF8888AA);
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFFFBB33);
  static const Color danger = Color(0xFFFF4757);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accent,
          secondary: AppColors.accentSecond,
          surface: AppColors.surface,
          error: AppColors.danger,
        ),
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.spaceGrotesk(fontSize: 34, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          headlineMedium: GoogleFonts.spaceGrotesk(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          titleLarge: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          bodyLarge: GoogleFonts.dmSans(fontSize: 16, color: AppColors.textPrimary),
          bodyMedium: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textSecond),
          labelLarge: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        cardTheme: CardTheme(
          color: AppColors.surfaceHigh.withValues(alpha: .6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0x22FFFFFF)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: AppColors.surfaceHigh,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0x22FFFFFF))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.accent)),
        ),
      );

  static BoxDecoration glassCardDecoration() => BoxDecoration(
        color: AppColors.surfaceHigh.withValues(alpha: .6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x22FFFFFF)),
      );

  static BoxDecoration gradientButtonDecoration() => BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.accent, AppColors.accentSecond]),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: AppColors.accentGlow, blurRadius: 16, spreadRadius: 2)],
      );
}
