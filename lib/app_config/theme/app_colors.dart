import 'package:flutter/material.dart';

/// Paleta de colores Bolt Dark Theme para TaxiMeter Pro
/// 
/// Inspirado en la aplicación Bolt con optimizaciones para visibilidad nocturna.
/// Sigue Material Design 3 y especificaciones del diseño UI.
class AppColors {
  // Evitar instanciación
  AppColors._();

  // ========================================
  // PALETA BOLT DARK THEME 🌙
  // ========================================

  /// Color primario - Bolt Green (Dark optimized)
  /// Usado para: Botones principales, indicadores de estado, iconos importantes
  static const Color primary = Color(0xFF4FD49B);

  /// Color primario contenedor - Versión más oscura del primario
  /// Usado para: Fondos de cards especiales, headers importantes
  static const Color primaryContainer = Color(0xFF00532A);

  /// Color sobre primario - Texto sobre fondos primarios
  static const Color onPrimary = Color(0xFF003920);

  /// Color sobre primario contenedor - Texto sobre primary container
  static const Color onPrimaryContainer = Color(0xFF76F2C0);

  // ========================================
  // COLORES SECUNDARIOS Y TERCIARIOS
  // ========================================

  /// Color secundario - Purple accent para contraste
  /// Usado para: Elementos secundarios, badges especiales
  static const Color secondary = Color(0xFFBB86FC);

  /// Color secundario contenedor
  static const Color secondaryContainer = Color(0xFF4F378B);

  /// Color sobre secundario
  static const Color onSecondary = Color(0xFF1D192B);

  /// Color sobre secundario contenedor
  static const Color onSecondaryContainer = Color(0xFFE2DDFF);

  /// Color terciario - Bolt Yellow para elementos destacados
  /// Usado para: Ratings, alertas importantes, elementos dorados
  static const Color tertiary = Color(0xFFFFD600);

  /// Color terciario contenedor
  static const Color tertiaryContainer = Color(0xFFB39B00);

  /// Color sobre terciario
  static const Color onTertiary = Color(0xFF433C00);

  /// Color sobre terciario contenedor
  static const Color onTertiaryContainer = Color(0xFFFFF1A8);

  // ========================================
  // SUPERFICIES - DARK THEME
  // ========================================

  /// Superficie principal - Fondo dark principal
  /// Usado para: Fondo general de la app, AppBars
  static const Color surface = Color(0xFF121212);

  /// Superficie variante - Elementos elevados
  /// Usado para: Cards, botones elevados, elementos con contraste
  static const Color surfaceVariant = Color(0xFF2D2D2D);

  /// Superficie más oscura - Elementos especiales
  /// Usado para: Elementos que necesitan mayor contraste
  static const Color surfaceDark = Color(0xFF1E1E1E);

  /// Color sobre superficie - Texto principal
  static const Color onSurface = Color(0xFFE3E3E3);

  /// Color sobre superficie variante - Texto secundario
  static const Color onSurfaceVariant = Color(0xFFC7C7C7);

  /// Color de outline - Bordes y divisores
  static const Color outline = Color(0xFF5C5C5C);

  /// Color de outline variante - Bordes sutiles
  static const Color outlineVariant = Color(0xFF3C3C3C);

  // ========================================
  // ESTADOS - ERROR, WARNING, SUCCESS
  // ========================================

  /// Color de error - Optimizado para dark theme
  /// Usado para: Errores, botones peligrosos, alertas críticas
  static const Color error = Color(0xFFCF6679);

  /// Color sobre error
  static const Color onError = Color(0xFFFFFFFF);

  /// Contenedor de error
  static const Color errorContainer = Color(0xFF93000A);

  /// Color sobre contenedor de error
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  /// Color de éxito - Verde compatible con el primario
  /// Usado para: Confirmaciones, estados completados
  static const Color success = primary; // Reutilizamos el verde primario

  /// Color de advertencia - Amarillo terciario
  /// Usado para: Advertencias, estados pendientes
  static const Color warning = tertiary;

  // ========================================
  // COLORES ESPECÍFICOS DE LA APP
  // ========================================

  /// Color para montos en guaraníes - Destacado en verde
  static const Color currencyAmount = primary;

  /// Color para cronómetro - Destacado y legible
  static const Color timerText = onPrimaryContainer;

  /// Fondo del cronómetro
  static const Color timerBackground = primaryContainer;

  /// Color para ratings/estrellas
  static const Color ratingGold = tertiary;

  /// Color para estrellas vacías
  static const Color ratingEmpty = Color(0xFF5C5C5C);

  /// Color para elementos deshabilitados
  static const Color disabled = Color(0xFF383838);

  /// Texto sobre elementos deshabilitados
  static const Color onDisabled = Color(0xFF9E9E9E);

  // ========================================
  // TRANSPARENCIAS ÚTILES
  // ========================================

  /// Superficie con transparencia para overlays
  static const Color surfaceOverlay = Color(0x80121212);

  /// Primario con transparencia para efectos
  static const Color primaryTransparent = Color(0x804FD49B);

  /// Sombra para elementos elevados en dark theme
  static const Color shadow = Color(0xFF000000);

  // ========================================
  // MÉTODOS HELPER
  // ========================================

  /// Obtener color con opacidad personalizada
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// Paleta completa como ColorScheme para Material Design 3
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    secondary: secondary,
    onSecondary: onSecondary,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,
    tertiary: tertiary,
    onTertiary: onTertiary,
    tertiaryContainer: tertiaryContainer,
    onTertiaryContainer: onTertiaryContainer,
    error: error,
    onError: onError,
    errorContainer: errorContainer,
    onErrorContainer: onErrorContainer,
    surface: surface,
    onSurface: onSurface,
    surfaceContainerHighest: surfaceVariant,
    onSurfaceVariant: onSurfaceVariant,
    outline: outline,
    outlineVariant: outlineVariant,
    shadow: shadow,
    inverseSurface: onSurface,
    onInverseSurface: surface,
    inversePrimary: Color(0xFF006D3A),
  );
}
