import 'package:flutter/material.dart';

/// OnField design system — derived from DESIGN.md.
///
/// Corporate-modern, minimal, utility-first. Anchored by an "Action Blue"
/// primary used strictly for interactive elements and brand presence.
class AppColors {
  AppColors._();

  // Surface tiers
  static const background = Color(0xFFF4F6FA);
  static const surface = Color(0xFFF4F6FA);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF4F6FA);
  static const surfaceContainer = Color(0xFFEDF0F7);
  static const surfaceContainerHigh = Color(0xFFE6EAF2);
  static const surfaceContainerHighest = Color(0xFFDFE4EE);

  // Text
  static const onSurface = Color(0xFF111827);
  static const onSurfaceVariant = Color(0xFF6B7280);

  // Outline / borders
  static const outline = Color(0xFF9CA3AF);
  static const outlineVariant = Color(0xFFC7CDD9);
  static const border = Color(0xFFE2E8F0);

  // Brand / primary
  static const primary = Color(0xFF1B4FA8);
  static const primaryDark = Color(0xFF0F2D6B);
  static const primaryContainer = Color(0xFF2E63C9);
  static const onPrimary = Color(0xFFFFFFFF);

  // Semantic
  static const success = Color(0xFF16A34A);
  static const successContainer = Color(0xFFDCFCE7);
  static const onSuccessContainer = Color(0xFF166534);

  static const info = primaryContainer;
  static const infoContainer = Color(0xFFDBE7FF);

  static const warning = Color(0xFFD97706);
  static const warningContainer = Color(0xFFFEF3C7);

  static const pendingGray = Color(0xFF9CA3AF);

  static const error = Color(0xFFDC2626);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);
}

/// Brightness-dependent design tokens (surfaces, text, outlines, borders, and
/// soft semantic tints) carried as a [ThemeExtension] so they flip with the
/// active theme. Read them at call sites via `context.colors.<token>`.
///
/// Brand/primary and the strong semantic colors (success/warning/error) read
/// fine on both backgrounds and stay as `const` on [AppColors] — only the
/// tokens here change between light and dark.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.border,
    required this.pendingGray,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warningContainer,
    required this.infoContainer,
    required this.errorContainer,
    required this.onErrorContainer,
  });

  final Color background;
  final Color surface;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color border;
  final Color pendingGray;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warningContainer;
  final Color infoContainer;
  final Color errorContainer;
  final Color onErrorContainer;

  static const light = AppPalette(
    background: Color(0xFFF4F6FA),
    surface: Color(0xFFF4F6FA),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF4F6FA),
    surfaceContainer: Color(0xFFEDF0F7),
    surfaceContainerHigh: Color(0xFFE6EAF2),
    surfaceContainerHighest: Color(0xFFDFE4EE),
    onSurface: Color(0xFF111827),
    onSurfaceVariant: Color(0xFF6B7280),
    outline: Color(0xFF9CA3AF),
    outlineVariant: Color(0xFFC7CDD9),
    border: Color(0xFFE2E8F0),
    pendingGray: Color(0xFF9CA3AF),
    successContainer: Color(0xFFDCFCE7),
    onSuccessContainer: Color(0xFF166534),
    warningContainer: Color(0xFFFEF3C7),
    infoContainer: Color(0xFFDBE7FF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF93000A),
  );

  static const dark = AppPalette(
    background: Color(0xFF0F1419),
    surface: Color(0xFF0F1419),
    surfaceContainerLowest: Color(0xFF1A2027),
    surfaceContainerLow: Color(0xFF161C23),
    surfaceContainer: Color(0xFF1E252E),
    surfaceContainerHigh: Color(0xFF252D38),
    surfaceContainerHighest: Color(0xFF2E3742),
    onSurface: Color(0xFFE5E9F0),
    onSurfaceVariant: Color(0xFF9BA3B0),
    outline: Color(0xFF6B7480),
    outlineVariant: Color(0xFF3A434F),
    border: Color(0xFF2A323C),
    pendingGray: Color(0xFF6B7480),
    successContainer: Color(0xFF14331F),
    onSuccessContainer: Color(0xFF6EE7A0),
    warningContainer: Color(0xFF3A2A0A),
    infoContainer: Color(0xFF152A4D),
    errorContainer: Color(0xFF45161A),
    onErrorContainer: Color(0xFFFFB4AB),
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? outline,
    Color? outlineVariant,
    Color? border,
    Color? pendingGray,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warningContainer,
    Color? infoContainer,
    Color? errorContainer,
    Color? onErrorContainer,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceContainerLowest:
          surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      border: border ?? this.border,
      pendingGray: pendingGray ?? this.pendingGray,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warningContainer: warningContainer ?? this.warningContainer,
      infoContainer: infoContainer ?? this.infoContainer,
      errorContainer: errorContainer ?? this.errorContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceContainerLowest:
          Color.lerp(surfaceContainerLowest, other.surfaceContainerLowest, t)!,
      surfaceContainerLow:
          Color.lerp(surfaceContainerLow, other.surfaceContainerLow, t)!,
      surfaceContainer:
          Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      surfaceContainerHigh:
          Color.lerp(surfaceContainerHigh, other.surfaceContainerHigh, t)!,
      surfaceContainerHighest: Color.lerp(
          surfaceContainerHighest, other.surfaceContainerHighest, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant:
          Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      border: Color.lerp(border, other.border, t)!,
      pendingGray: Color.lerp(pendingGray, other.pendingGray, t)!,
      successContainer:
          Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer:
          Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warningContainer:
          Color.lerp(warningContainer, other.warningContainer, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      onErrorContainer:
          Color.lerp(onErrorContainer, other.onErrorContainer, t)!,
    );
  }
}

/// Terse access to the active [AppPalette]: `context.colors.surface`.
extension AppPaletteX on BuildContext {
  AppPalette get colors => Theme.of(this).extension<AppPalette>()!;
}

class AppRadius {
  AppRadius._();
  static const sm = 4.0;
  static const base = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const full = 9999.0;
}

class AppSpacing {
  AppSpacing._();
  static const gutter = 16.0;
  static const cardPadding = 16.0;
  static const touchTargetMin = 48.0;
}

/// Level-1 (card) and Level-2 (active) ambient shadows from DESIGN.md.
class AppShadows {
  AppShadows._();
  static const card = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
  ];
  static const elevated = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 15,
      spreadRadius: -3,
      offset: Offset(0, 10),
    ),
  ];
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(
        Brightness.light,
        AppPalette.light,
        const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          primaryContainer: AppColors.primaryContainer,
          onPrimaryContainer: AppColors.onPrimary,
          secondary: Color(0xFF505F76),
          onSecondary: Colors.white,
          secondaryContainer: Color(0xFFD0E1FB),
          onSecondaryContainer: Color(0xFF54647A),
          tertiary: Color(0xFF4D556B),
          onTertiary: Colors.white,
          error: AppColors.error,
          onError: Colors.white,
          errorContainer: AppColors.errorContainer,
          onErrorContainer: AppColors.onErrorContainer,
          surface: Color(0xFFF4F6FA),
          onSurface: Color(0xFF111827),
          onSurfaceVariant: Color(0xFF6B7280),
          outline: Color(0xFF9CA3AF),
          outlineVariant: Color(0xFFC7CDD9),
          surfaceContainerLowest: Color(0xFFFFFFFF),
          surfaceContainerLow: Color(0xFFF4F6FA),
          surfaceContainer: Color(0xFFEDF0F7),
          surfaceContainerHigh: Color(0xFFE6EAF2),
          surfaceContainerHighest: Color(0xFFDFE4EE),
        ),
      );

  static ThemeData get dark => _build(
        Brightness.dark,
        AppPalette.dark,
        const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF8FB0EC),
          onPrimary: Color(0xFF0A1F45),
          primaryContainer: AppColors.primaryContainer,
          onPrimaryContainer: Colors.white,
          secondary: Color(0xFFAEC0DC),
          onSecondary: Color(0xFF1B2A40),
          secondaryContainer: Color(0xFF334562),
          onSecondaryContainer: Color(0xFFD0E1FB),
          tertiary: Color(0xFFC0C6DC),
          onTertiary: Color(0xFF1F2738),
          error: Color(0xFFFFB4AB),
          onError: Color(0xFF690005),
          errorContainer: Color(0xFF45161A),
          onErrorContainer: Color(0xFFFFB4AB),
          surface: Color(0xFF0F1419),
          onSurface: Color(0xFFE5E9F0),
          onSurfaceVariant: Color(0xFF9BA3B0),
          outline: Color(0xFF6B7480),
          outlineVariant: Color(0xFF3A434F),
          surfaceContainerLowest: Color(0xFF1A2027),
          surfaceContainerLow: Color(0xFF161C23),
          surfaceContainer: Color(0xFF1E252E),
          surfaceContainerHigh: Color(0xFF252D38),
          surfaceContainerHighest: Color(0xFF2E3742),
        ),
      );

  static ThemeData _build(
    Brightness brightness,
    AppPalette palette,
    ColorScheme scheme,
  ) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: palette.background,
      fontFamily: 'Inter',
      extensions: [palette],
    );

    return base.copyWith(
      // No page route transitions anywhere in the app.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _NoTransitionsBuilder(),
          TargetPlatform.iOS: _NoTransitionsBuilder(),
          TargetPlatform.macOS: _NoTransitionsBuilder(),
          TargetPlatform.windows: _NoTransitionsBuilder(),
          TargetPlatform.linux: _NoTransitionsBuilder(),
          TargetPlatform.fuchsia: _NoTransitionsBuilder(),
        },
      ),
      textTheme: _textTheme(base.textTheme, palette),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        foregroundColor: palette.onSurface,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: brightness == Brightness.dark
              ? palette.onSurface
              : AppColors.primaryDark,
        ),
      ),
      cardTheme: CardThemeData(
        color: palette.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: palette.border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size.fromHeight(AppSpacing.touchTargetMin),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.base),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size(0, AppSpacing.touchTargetMin),
          side: BorderSide(color: palette.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.base),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceContainerLow,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.base),
          borderSide: BorderSide(color: palette.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.base),
          borderSide: BorderSide(color: palette.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.base),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        labelStyle: TextStyle(color: palette.onSurfaceVariant),
        hintStyle: TextStyle(color: palette.outline),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 64,
        backgroundColor: palette.surfaceContainerLowest,
        indicatorColor: AppColors.primary,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.primary : palette.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected ? AppColors.onPrimary : palette.onSurfaceVariant,
          );
        }),
      ),
      dividerTheme: DividerThemeData(
        color: palette.border,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base, AppPalette palette) {
    return base.copyWith(
      headlineLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: palette.onSurface,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: palette.onSurface,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: palette.onSurface,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: palette.onSurface,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        color: palette.onSurface,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: palette.onSurfaceVariant,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: palette.onSurfaceVariant,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: palette.onSurfaceVariant,
      ),
    );
  }
}

/// Page transitions builder that renders the destination instantly, with no
/// slide/fade animation. Applied to every platform so route changes (including
/// auth redirects) appear immediately.
class _NoTransitionsBuilder extends PageTransitionsBuilder {
  const _NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
