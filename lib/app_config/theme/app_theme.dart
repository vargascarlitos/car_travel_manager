import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'text_styles.dart';
import 'component_themes.dart';

/// Configuración principal del tema para TaxiMeter Pro
/// 
/// Implementa Material Design 3 con paleta Bolt Dark Theme.
/// Optimizado para uso nocturno y conducción profesional.
class AppTheme {
  AppTheme._();

  // ========================================
  // TEMA PRINCIPAL - BOLT DARK THEME
  // ========================================

  /// Tema principal de la aplicación - Solo Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      // Esquema de colores Material Design 3
      colorScheme: AppColors.darkColorScheme,
      
      // Brillo del tema
      brightness: Brightness.dark,
      
      // Color primario para compatibilidad
      primarySwatch: _createMaterialColor(AppColors.primary),
      
      // Colores de fondo principales
      scaffoldBackgroundColor: AppColors.surface,
      canvasColor: AppColors.surface,
      
      // Tipografía Material Design 3
      textTheme: AppTextStyles.textTheme,
      
      // Tema de AppBar
      appBarTheme: ComponentThemes.appBarTheme,
      
      // Temas de botones
      filledButtonTheme: ComponentThemes.filledButtonTheme,
      outlinedButtonTheme: ComponentThemes.outlinedButtonTheme,
      textButtonTheme: ComponentThemes.textButtonTheme,
      floatingActionButtonTheme: ComponentThemes.floatingActionButtonTheme,
      
      // Tema de cards
      cardTheme: ComponentThemes.cardTheme,
      
      // Tema de inputs
      inputDecorationTheme: ComponentThemes.inputDecorationTheme,
      
      // Tema de chips
      chipTheme: ComponentThemes.chipTheme,
      
      // Tema de listas
      listTileTheme: ComponentThemes.listTileTheme,
      
      // Tema de diálogos
      dialogTheme: ComponentThemes.dialogTheme,
      
      // Tema de bottom sheets
      bottomSheetTheme: ComponentThemes.bottomSheetTheme,
      
      // Tema de progress indicators
      progressIndicatorTheme: ComponentThemes.progressIndicatorTheme,
      
      // Tema de switches
      switchTheme: ComponentThemes.switchTheme,
      
      // Tema de checkboxes
      checkboxTheme: ComponentThemes.checkboxTheme,
      
      // Tema de radio buttons
      radioTheme: ComponentThemes.radioTheme,
      
      // Tema de sliders
      sliderTheme: ComponentThemes.sliderTheme,
      
      // Tema de dividers
      dividerTheme: ComponentThemes.dividerTheme,
      
      // Configuración de iconos
      iconTheme: const IconThemeData(
        color: AppColors.onSurface,
        size: 24,
      ),
      primaryIconTheme: const IconThemeData(
        color: AppColors.primary,
        size: 24,
      ),
      
      // Configuración de Material
      materialTapTargetSize: MaterialTapTargetSize.padded,
      
      // Visual density para diferentes plataformas
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      // Configuración de splash
      splashColor: AppColors.primary.withValues(alpha: 0.12),
      highlightColor: AppColors.primary.withValues(alpha: 0.08),
      
      // Configuración de focus
      focusColor: AppColors.primary.withValues(alpha: 0.12),
      hoverColor: AppColors.primary.withValues(alpha: 0.08),
      
      // Typography theme (para compatibilidad)
      typography: Typography.material2021(),
      
      // Configuración de Material 3
      useMaterial3: true,
      
      // Configuración de extension themes
      extensions: <ThemeExtension<dynamic>>[
        _TaxiMeterThemeExtension(),
      ],
    );
  }

  // ========================================
  // CONFIGURACIÓN DE SISTEMA UI
  // ========================================

  /// Configuración de la barra de estado y navegación
  static SystemUiOverlayStyle get systemUiOverlayStyle {
    return const SystemUiOverlayStyle(
      // Barra de estado (arriba)
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      
      // Barra de navegación (abajo) - Android
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: AppColors.outline,
      
      // Configuración para notch/island
      systemNavigationBarContrastEnforced: false,
    );
  }

  /// Aplicar configuración del sistema UI
  static void setSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  // ========================================
  // HELPER METHODS
  // ========================================

  /// Crear MaterialColor desde Color para compatibilidad
  static MaterialColor _createMaterialColor(Color color) {
    final strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = (color.r * 255).round(), g = (color.g * 255).round(), b = (color.b * 255).round();

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    
    for (final strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    
    return MaterialColor(color.toARGB32(), swatch);
  }
}

// ========================================
// THEME EXTENSION PERSONALIZADA
// ========================================

/// Extensión de tema personalizada para elementos específicos de TaxiMeter
class _TaxiMeterThemeExtension extends ThemeExtension<_TaxiMeterThemeExtension> {
  const _TaxiMeterThemeExtension({
    this.timerCardColor = AppColors.primaryContainer,
    this.currencyHighlightColor = AppColors.currencyAmount,
    this.ratingStarColor = AppColors.ratingGold,
    this.ratingEmptyColor = AppColors.ratingEmpty,
    this.tripStatusColors = const TripStatusColors(),
  });

  final Color timerCardColor;
  final Color currencyHighlightColor;
  final Color ratingStarColor;
  final Color ratingEmptyColor;
  final TripStatusColors tripStatusColors;

  @override
  ThemeExtension<_TaxiMeterThemeExtension> copyWith({
    Color? timerCardColor,
    Color? currencyHighlightColor,
    Color? ratingStarColor,
    Color? ratingEmptyColor,
    TripStatusColors? tripStatusColors,
  }) {
    return _TaxiMeterThemeExtension(
      timerCardColor: timerCardColor ?? this.timerCardColor,
      currencyHighlightColor: currencyHighlightColor ?? this.currencyHighlightColor,
      ratingStarColor: ratingStarColor ?? this.ratingStarColor,
      ratingEmptyColor: ratingEmptyColor ?? this.ratingEmptyColor,
      tripStatusColors: tripStatusColors ?? this.tripStatusColors,
    );
  }

  @override
  ThemeExtension<_TaxiMeterThemeExtension> lerp(
    ThemeExtension<_TaxiMeterThemeExtension>? other,
    double t,
  ) {
    if (other is! _TaxiMeterThemeExtension) {
      return this;
    }
    
    return _TaxiMeterThemeExtension(
      timerCardColor: Color.lerp(timerCardColor, other.timerCardColor, t)!,
      currencyHighlightColor: Color.lerp(currencyHighlightColor, other.currencyHighlightColor, t)!,
      ratingStarColor: Color.lerp(ratingStarColor, other.ratingStarColor, t)!,
      ratingEmptyColor: Color.lerp(ratingEmptyColor, other.ratingEmptyColor, t)!,
      tripStatusColors: TripStatusColors.lerp(tripStatusColors, other.tripStatusColors, t),
    );
  }
}

// ========================================
// COLORES DE ESTADO DE VIAJE
// ========================================

/// Colores específicos para estados de viaje
class TripStatusColors {
  const TripStatusColors({
    this.pending = AppColors.warning,
    this.inProgress = AppColors.primary,
    this.completed = AppColors.success,
    this.cancelled = AppColors.error,
  });

  final Color pending;
  final Color inProgress;
  final Color completed;
  final Color cancelled;

  static TripStatusColors lerp(TripStatusColors a, TripStatusColors b, double t) {
    return TripStatusColors(
      pending: Color.lerp(a.pending, b.pending, t)!,
      inProgress: Color.lerp(a.inProgress, b.inProgress, t)!,
      completed: Color.lerp(a.completed, b.completed, t)!,
      cancelled: Color.lerp(a.cancelled, b.cancelled, t)!,
    );
  }
}

// ========================================
// EXTENSIÓN PARA ACCESO FÁCIL
// ========================================

/// Extensión para acceso fácil a temas personalizados
extension TaxiMeterThemeData on ThemeData {
  _TaxiMeterThemeExtension get taxiMeter => 
      extension<_TaxiMeterThemeExtension>() ?? const _TaxiMeterThemeExtension();
}
