import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Estilos de texto Material Design 3 para TaxiMeter Pro
/// 
/// Optimizados para dark theme con tipografía Google Fonts moderna.
/// Usa Inter para textos generales y JetBrains Mono para cronómetro.
/// Incluye estilos específicos para cronómetro, montos y elementos de UI.
class AppTextStyles {
  // Evitar instanciación
  AppTextStyles._();

  // ========================================
  // TIPOGRAFÍA MATERIAL DESIGN 3
  // ========================================

  // Fuentes Google Fonts modernas
  static String get _fontFamily => GoogleFonts.inter().fontFamily!;
  static String get _monoFontFamily => GoogleFonts.jetBrainsMono().fontFamily!;
  
  // ========================================
  // DISPLAY STYLES - Para elementos grandes
  // ========================================

  /// Display Large - Para splash screens, grandes títulos
  static TextStyle get displayLarge => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    color: AppColors.onSurface,
    height: 1.12,
  );

  /// Display Medium - Para headers principales
  static TextStyle get displayMedium => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.onSurface,
    height: 1.16,
  );

  /// Display Small - Para títulos de sección importantes
  static TextStyle get displaySmall => TextStyle(
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
  static TextStyle get headlineLarge => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.onSurface,
    height: 1.25,
  );

  /// Headline Medium - AppBar titles, títulos de card importantes
  static TextStyle get headlineMedium => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.onSurface,
    height: 1.29,
  );

  /// Headline Small - Subtítulos, nombres de pasajeros destacados
  static TextStyle get headlineSmall => TextStyle(
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
  static TextStyle get titleLarge => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.onSurface,
    height: 1.27,
  );

  /// Title Medium - Títulos de componentes, labels importantes
  static TextStyle get titleMedium => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    color: AppColors.onSurface,
    height: 1.50,
  );

  /// Title Small - Títulos pequeños, labels de campos
  static TextStyle get titleSmall => TextStyle(
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
  static TextStyle get labelLarge => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.onSurface,
    height: 1.43,
  );

  /// Label Medium - Botones secundarios, chips
  static TextStyle get labelMedium => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.onSurface,
    height: 1.33,
  );

  /// Label Small - Labels pequeños, indicadores
  static TextStyle get labelSmall => TextStyle(
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
  static TextStyle get bodyLarge => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: AppColors.onSurface,
    height: 1.50,
  );

  /// Body Medium - Contenido general, descripciones
  static TextStyle get bodyMedium => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: AppColors.onSurface,
    height: 1.43,
  );

  /// Body Small - Contenido secundario, ayudas contextuales
  static TextStyle get bodySmall => TextStyle(
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

  /// Cronómetro - Estilo especial para timer con JetBrains Mono
  static TextStyle get timer => TextStyle(
    fontFamily: _monoFontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.0,
    color: AppColors.timerText,
    height: 1.2,
  );

  /// Cronómetro pequeño - Para displays secundarios  
  static TextStyle get timerSmall => TextStyle(
    fontFamily: _monoFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    color: AppColors.timerText,
    height: 1.2,
  );

  /// Monto en guaraníes - Destacado para tarifas
  static TextStyle get currency => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: AppColors.currencyAmount,
    height: 1.25,
  );

  /// Monto pequeño - Para history y detalles
  static TextStyle get currencySmall => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.currencyAmount,
    height: 1.33,
  );

  /// Pasajero destacado - Para nombres de pasajeros
  static TextStyle get passengerName => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: AppColors.primary,
    height: 1.4,
  );

  /// ID de viaje - Para Trip #123
  static TextStyle get tripId => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.primary,
    height: 1.5,
  );

  /// Error text - Para mensajes de error
  static TextStyle get error => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.error,
    height: 1.33,
  );

  /// Success text - Para mensajes de éxito
  static TextStyle get success => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.success,
    height: 1.33,
  );

  /// Caption - Para metadatos, fechas, información secundaria
  static TextStyle get caption => TextStyle(
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

  /// Crear TextTheme completo para Material Design 3 con Google Fonts
  static TextTheme get textTheme => TextTheme(
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
