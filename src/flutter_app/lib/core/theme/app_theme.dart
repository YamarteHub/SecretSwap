import 'package:flutter/material.dart';

class AppTheme {
  static const Color warmIvory = Color(0xFFFAF7F1);
  static const Color softCream = Color(0xFFFFFDF8);
  static const Color warmCharcoal = Color(0xFF2E2A27);
  static const Color deepPlum = Color(0xFF3A223F);
  static const Color deepPlumAlt = Color(0xFF42283E);
  static const Color softTerracotta = Color(0xFFC96F53);
  static const Color mutedGold = Color(0xFFC7A76C);
  static const Color sageGreen = Color(0xFF7A9B7A);
  static const Color softCoral = Color(0xFFD85C4A);

  static const Color heroCreamTop = Color(0xFFFCF6EC);
  static const Color heroCreamBottom = Color(0xFFF7ECDF);
  static const Color brandBackdropTop = Color(0xFFF6ECE1);
  static const Color brandBackdropBottom = Color(0xFFEFD9C5);

  static const LinearGradient warmBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFCF7EE), Color(0xFFF6E9DC)],
  );

  static const LinearGradient secretCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEDE0EE), Color(0xFFF8EFE5)],
  );

  static const LinearGradient brandHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF7E6D6), Color(0xFFEAD3E1)],
  );

  static const List<BoxShadow> softElevatedShadow = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 22,
      spreadRadius: -6,
      offset: Offset(0, 8),
    ),
  ];

  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: deepPlum,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFEDE4EE),
      onPrimaryContainer: deepPlumAlt,
      secondary: softTerracotta,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFF7E4DE),
      onSecondaryContainer: warmCharcoal,
      tertiary: mutedGold,
      onTertiary: warmCharcoal,
      tertiaryContainer: Color(0xFFF4EAD6),
      onTertiaryContainer: warmCharcoal,
      error: softCoral,
      onError: Colors.white,
      errorContainer: Color(0xFFF8DFDA),
      onErrorContainer: Color(0xFF5A241C),
      surface: softCream,
      onSurface: warmCharcoal,
      surfaceContainerHighest: Color(0xFFF1ECE3),
      onSurfaceVariant: Color(0xFF6F655D),
      outline: Color(0xFFCCBFB3),
      outlineVariant: Color(0xFFE4DBCF),
      shadow: Color(0x1A000000),
      scrim: Color(0x66000000),
      inverseSurface: Color(0xFF37312D),
      onInverseSurface: Color(0xFFF7F2EA),
      inversePrimary: Color(0xFFD6C3D9),
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: Brightness.light,
    );

    return base.copyWith(
      scaffoldBackgroundColor: warmIvory,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: warmIvory,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: warmCharcoal,
        ),
      ),
      textTheme: base.textTheme
          .apply(bodyColor: warmCharcoal, displayColor: warmCharcoal)
          .copyWith(
            headlineSmall: base.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
              color: warmCharcoal,
            ),
            titleLarge: base.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: warmCharcoal,
            ),
            titleMedium: base.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: warmCharcoal,
            ),
            bodyMedium: base.textTheme.bodyMedium?.copyWith(
              height: 1.4,
              color: warmCharcoal,
            ),
          ),
      cardTheme: CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        shadowColor: scheme.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        color: softCream,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: softCream,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: deepPlum, width: 1.6),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: const Color(0xFFF3ECE8),
        selectedColor: const Color(0xFFEADFEA),
        side: BorderSide(color: scheme.outlineVariant),
        labelStyle: base.textTheme.labelMedium?.copyWith(
          color: scheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: deepPlum,
          foregroundColor: Colors.white,
          disabledBackgroundColor: scheme.outlineVariant,
          disabledForegroundColor: scheme.onSurfaceVariant,
          minimumSize: const Size.fromHeight(54),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          textStyle: base.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: deepPlumAlt,
          side: BorderSide(color: scheme.outline),
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: base.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: deepPlumAlt,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: softCream,
        surfaceTintColor: Colors.transparent,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: warmCharcoal,
        ),
        contentTextStyle: base.textTheme.bodyMedium?.copyWith(
          color: warmCharcoal,
          height: 1.4,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: softCream,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: deepPlumAlt,
        contentTextStyle: base.textTheme.bodyMedium?.copyWith(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: deepPlum,
        linearTrackColor: Color(0xFFEDE4DC),
      ),
      dividerColor: const Color(0xFFE6DDD1),
      iconTheme: const IconThemeData(color: deepPlumAlt),
    );
  }
}
