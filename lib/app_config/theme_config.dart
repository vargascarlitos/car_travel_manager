/// Configuración de tema para TaxiMeter Pro
/// 
/// Punto de entrada principal para toda la configuración de tema.
/// Exporta colores, estilos y tema completo Material Design 3.
/// 
/// Uso:
/// ```dart
/// import 'package:car_travel_manager/app_config/theme_config.dart';
/// 
/// MaterialApp(
///   theme: AppTheme.darkTheme,
///   // ...
/// )
/// ```

// Exportar todas las configuraciones de tema
export 'theme/app_colors.dart';
export 'theme/text_styles.dart';
export 'theme/component_themes.dart';
export 'theme/app_theme.dart';

// Re-exportar Flutter Material para conveniencia
export 'package:flutter/material.dart' show 
    ThemeData, 
    ColorScheme, 
    TextTheme,
    MaterialColor,
    Colors;

// Re-exportar Flutter Services para configuración del sistema
export 'package:flutter/services.dart' show 
    SystemUiOverlayStyle,
    SystemChrome;
