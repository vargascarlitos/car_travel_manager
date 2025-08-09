# App Config - TaxiMeter Pro

Configuración centralizada de la aplicación TaxiMeter Pro con Material Design 3 y Bolt Dark Theme.

## 📁 Estructura

```
lib/app_config/
├── theme/
│   ├── app_colors.dart      # Paleta Bolt Dark Theme completa
│   ├── text_styles.dart     # Tipografía Material Design 3
│   ├── component_themes.dart # Temas específicos de componentes
│   └── app_theme.dart       # Configuración principal del tema
├── theme_config.dart        # Punto de entrada exportado
└── README.md               # Este archivo
```

## 🎨 Bolt Dark Theme

### Características Principales
- **🌙 Solo Dark Theme**: Optimizado para uso nocturno profesional
- **🎯 Material Design 3**: Implementación completa siguiendo especificaciones
- **🚗 Colores Bolt**: Inspirado en la aplicación Bolt con verde característico
- **⚡ Performance First**: Configuración optimizada sin setState

### Paleta de Colores

#### Colores Primarios
```dart
Primary:     #4FD49B  // Bolt Green - Dark optimized
Secondary:   #BB86FC  // Purple accent for dark
Tertiary:    #FFD600  // Bolt Yellow
```

#### Superficies
```dart
Surface:         #121212  // Dark background
Surface Variant: #2D2D2D  // Cards, elementos elevados
Surface Dark:    #1E1E1E  // Elementos especiales
```

#### Estados
```dart
Error:    #CF6679  // Error red for dark
Success:  #4FD49B  // Reutiliza el verde primario
Warning:  #FFD600  // Amarillo terciario
```

#### Específicos de la App
```dart
Timer Background:    #00532A  // Primary Container
Currency Amount:     #4FD49B  // Primary
Rating Gold:         #FFD600  // Tertiary
```

## 📝 Tipografía - Google Fonts

### Fuentes Modernas Seleccionadas 🔥
- **Inter**: Fuente principal para toda la UI (súper legible y moderna)
- **JetBrains Mono**: Fuente monospace para cronómetro (perfecta para números)

### Material Design 3 Typography
- **Display**: Para elementos grandes (splash, grandes títulos)
- **Headline**: Para títulos de pantalla y secciones  
- **Title**: Para títulos de componentes y cards
- **Label**: Para botones y elementos de UI
- **Body**: Para contenido principal

### Estilos Específicos Actualizados
```dart
timer:         48sp, JetBrains Mono, Bold  // Cronómetro principal
timerSmall:    24sp, JetBrains Mono, SemiBold // Cronómetro secundario
currency:      32sp, Inter, Bold           // Montos en Gs
passengerName: 20sp, Inter, SemiBold       // Nombres destacados
tripId:        16sp, Inter, SemiBold       // IDs de viaje
```

## 🧩 Componentes Temáticos

### Botones
- **FilledButton**: Verde Bolt (#4FD49B) para acciones principales
- **OutlinedButton**: Borde verde sobre fondo variant para acciones secundarias
- **TextButton**: Solo texto para acciones menores
- **FloatingActionButton**: Verde Bolt con elevación optimizada

### Cards
- **Elevation**: 4dp estándar para dark theme
- **Background**: Surface Variant (#2D2D2D)
- **Border Radius**: 12dp para modernidad
- **Shadow**: Optimizada para dark theme

### Inputs
- **Background**: Surface Variant (#2D2D2D)
- **Border**: Outline color con focus en verde
- **Padding**: 16dp horizontal y vertical
- **Border Radius**: 12dp

### Chips
- **Normal**: Surface Variant con borde
- **Selected**: Primary Container con texto claro
- **Padding**: 12dp horizontal, 8dp vertical

## 🔧 Uso

### Importar Configuración
```dart
import 'package:car_travel_manager/app_config/theme_config.dart';
```

### Aplicar Tema
```dart
MaterialApp(
  theme: AppTheme.darkTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.dark,
  // ...
)
```

### Usar Colores
```dart
Container(
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: AppTextStyles.headlineSmall.copyWith(
      color: AppColors.onPrimary,
    ),
  ),
)
```

### Configurar Sistema UI
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppTheme.setSystemUIOverlayStyle(); // Configura barra de estado
  runApp(MyApp());
}
```

## 🎯 Características Especiales

### Theme Extension Personalizada
```dart
// Acceso a temas específicos del taxímetro
Theme.of(context).taxiMeter.timerCardColor
Theme.of(context).taxiMeter.currencyHighlightColor
Theme.of(context).taxiMeter.ratingStarColor
```

### Colores de Estado de Viaje
```dart
TripStatusColors.pending     // #FFD600 (Warning)
TripStatusColors.inProgress  // #4FD49B (Primary)
TripStatusColors.completed   // #4FD49B (Success)
TripStatusColors.cancelled   // #CF6679 (Error)
```

### Helper Methods
```dart
// Aplicar opacidad
AppColors.withOpacity(AppColors.primary, 0.5)

// Modificar estilos de texto
AppTextStyles.withColor(AppTextStyles.bodyLarge, AppColors.primary)
AppTextStyles.withWeight(AppTextStyles.bodyMedium, FontWeight.bold)
```

## 📱 Compatibilidad

- **Material Design 3**: ✅ Completamente implementado
- **Dark Theme Only**: ✅ Sin modo claro según requerimientos
- **Material State**: ✅ Actualizado a WidgetState (Flutter 3.19+)
- **System UI**: ✅ Configuración automática de barras de estado

## 🔮 Preparado para Backend

La configuración de tema está preparada para:
- Temas dinámicos desde servidor
- Personalización por usuario
- Modo offline completo
- Sincronización de preferencias

---

**Nota**: Esta configuración sigue estrictamente las reglas de Cursor establecidas y la arquitectura Clean definida para el proyecto TaxiMeter Pro.
