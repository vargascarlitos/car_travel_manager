import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Estilos de texto Material Design 3 para TaxiMeter Pro
/// 
/// Optimizados para dark theme con tipografía clara y legible.
/// Incluye estilos específicos para cronómetro, montos y elementos de UI.
class AppTextStyles {
  // Evitar instanciación
  AppTextStyles._();

  // ========================================
  // TIPOGRAFÍA MATERIAL DESIGN 3
  // ========================================

  // Fuente base del sistema con fallbacks
  static const String _fontFamily = 'Roboto';
  
  // ========================================
  // DISPLAY STYLES - Para elementos grandes
  // ========================================

  /// Display Large - Para splash screens, grandes títulos
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    color: AppColors.onSurface,
    height: 1.12,
  );

  /// Display Medium - Para headers principales
  static const TextStyle displayMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.onSurface,
    height: 1.16,
  );

  /// Display Small - Para títulos de sección importantes
  static const TextStyle displaySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.onSurface,
    height: 1.22,
  );

  // ========================================
  // HEADLINE STYLES - Para títulos de pantalla
  // ========================================

  /// Headline Large - Títulos principales de pantalla
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.onSurface,
    height: 1.25,
  );

  /// Headline Medium - AppBar titles, títulos de card importantes
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.onSurface,
    height: 1.29,
  );

  /// Headline Small - Subtítulos, nombres de pasajeros destacados
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.onSurface,
    height: 1.33,
  );

  // ========================================
  // TITLE STYLES - Para títulos de sección
  // ========================================

  /// Title Large - Títulos de cards, secciones importantes
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.onSurface,
    height: 1.27,
  );

  /// Title Medium - Títulos de componentes, labels importantes
  static const TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    color: AppColors.onSurface,
    height: 1.50,
  );

  /// Title Small - Títulos pequeños, labels de campos
  static const TextStyle titleSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.onSurface,
    height: 1.43,
  );

  // ========================================
  // LABEL STYLES - Para botones y elementos de UI
  // ========================================

  /// Label Large - Botones principales, acciones importantes
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.onSurface,
    height: 1.43,
  );

  /// Label Medium - Botones secundarios, chips
  static const TextStyle labelMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.onSurface,
    height: 1.33,
  );

  /// Label Small - Labels pequeños, indicadores
  static const TextStyle labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.onSurface,
    height: 1.45,
  );

  // ========================================
  // BODY STYLES - Para contenido principal
  // ========================================

  /// Body Large - Contenido principal, texto importante
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: AppColors.onSurface,
    height: 1.50,
  );

  /// Body Medium - Contenido general, descripciones
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: AppColors.onSurface,
    height: 1.43,
  );

  /// Body Small - Contenido secundario, ayudas contextuales
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.onSurfaceVariant,
    height: 1.33,
  );

  // ========================================
  // ESTILOS ESPECÍFICOS DE LA APP
  // ========================================

  /// Cronómetro - Estilo especial para timer con monospace
  static const TextStyle timer = TextStyle(
    fontFamily: 'Roboto Mono',
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.0,
    color: AppColors.timerText,
    height: 1.2,
  );

  /// Cronómetro pequeño - Para displays secundarios
  static const TextStyle timerSmall = TextStyle(
    fontFamily: 'Roboto Mono',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    color: AppColors.timerText,
    height: 1.2,
  );

  /// Monto en guaraníes - Destacado para tarifas
  static const TextStyle currency = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: AppColors.currencyAmount,
    height: 1.25,
  );

  /// Monto pequeño - Para history y detalles
  static const TextStyle currencySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.currencyAmount,
    height: 1.33,
  );

  /// Pasajero destacado - Para nombres de pasajeros
  static const TextStyle passengerName = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: AppColors.primary,
    height: 1.4,
  );

  /// ID de viaje - Para Trip #123
  static const TextStyle tripId = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.primary,
    height: 1.5,
  );

  /// Error text - Para mensajes de error
  static const TextStyle error = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.error,
    height: 1.33,
  );

  /// Success text - Para mensajes de éxito
  static const TextStyle success = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.success,
    height: 1.33,
  );

  /// Caption - Para metadatos, fechas, información secundaria
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.onSurfaceVariant,
    height: 1.33,
    fontStyle: FontStyle.italic,
  );

  // ========================================
  // MÉTODOS HELPER
  // ========================================

  /// Aplicar color específico a un estilo existente
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Aplicar peso específico a un estilo existente
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Aplicar tamaño específico a un estilo existente
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  /// Crear TextTheme completo para Material Design 3
  static const TextTheme textTheme = TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
  );
}
