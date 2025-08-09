import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_config/theme_config.dart';

/// Punto de entrada principal de TaxiMeter Pro
/// 
/// Aplicación de taxímetro con arquitectura Clean y BLoC.
/// Implementa Material Design 3 con Bolt Dark Theme.
void main() async {
  // Asegurar que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar la UI del sistema (barra de estado, etc.)
  AppTheme.setSystemUIOverlayStyle();
  
  // Ejecutar la aplicación
  runApp(const TaxiMeterApp());
}

/// Widget raíz de la aplicación TaxiMeter Pro
class TaxiMeterApp extends StatelessWidget {
  const TaxiMeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Información de la aplicación
      title: 'TaxiMeter Pro',
      
      // Configuración de debug
      debugShowCheckedModeBanner: false,
      
      // Tema principal - Solo Dark Theme (Bolt)
      theme: AppTheme.darkTheme,
      
      // No hay tema claro - solo dark según requerimientos
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      
      // Página inicial temporal (será reemplazada por arquitectura BLoC)
      home: const _TemporaryHomePage(),
      
      // Configuración de Material Design
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: AppTheme.systemUiOverlayStyle,
          child: child!,
        );
      },
    );
  }
}

/// Página temporal para probar el tema
/// 
/// Esta página será reemplazada por la arquitectura BLoC completa
/// con las 8 pantallas del flujo de la aplicación.
class _TemporaryHomePage extends StatelessWidget {
  const _TemporaryHomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaxiMeter Pro'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Card
            Card(
              elevation: 6,
              color: AppColors.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.local_taxi,
                      size: 48,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '¡Bienvenido a TaxiMeter Pro!',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Configuración de tema completada',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Features Demo Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bolt Dark Theme - Características',
                      style: AppTextStyles.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    
                    _FeatureItem(
                      icon: Icons.palette,
                      title: 'Material Design 3',
                      subtitle: 'Implementación completa con colores Bolt',
                    ),
                    
                    _FeatureItem(
                      icon: Icons.dark_mode,
                      title: 'Solo Dark Theme',
                      subtitle: 'Optimizado para uso nocturno profesional',
                    ),
                    
                    _FeatureItem(
                      icon: Icons.timer,
                      title: 'Tipografía Especializada',
                      subtitle: 'Cronómetro y moneda con fuentes optimizadas',
                    ),
                    
                    _FeatureItem(
                      icon: Icons.architecture,
                      title: 'Clean Architecture',
                      subtitle: 'Preparado para BLoC y capas separadas',
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(),
            
            // Demo Buttons
            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Tema Bolt Dark aplicado correctamente ✅',
                      style: AppTextStyles.bodyMedium,
                    ),
                    backgroundColor: AppColors.primaryContainer,
                  ),
                );
              },
              icon: const Icon(Icons.check_circle),
              label: const Text('Probar Tema'),
            ),
            
            const SizedBox(height: 12),
            
            OutlinedButton.icon(
              onPressed: () {
                // Mostrar información del tema
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Información del Tema'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Primary: ${AppColors.primary}', style: AppTextStyles.bodySmall),
                        Text('Surface: ${AppColors.surface}', style: AppTextStyles.bodySmall),
                        Text('Tertiary: ${AppColors.tertiary}', style: AppTextStyles.bodySmall),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cerrar'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.info),
              label: const Text('Ver Colores'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Demo de cronómetro
          showBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Demo Cronómetro',
                    style: AppTextStyles.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.timerBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '00:15:32',
                      style: AppTextStyles.timer,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gs 25.000',
                    style: AppTextStyles.currency,
                  ),
                ],
              ),
            ),
          );
        },
        tooltip: 'Demo Cronómetro',
        child: const Icon(Icons.timer),
      ),
    );
  }
}

/// Widget helper para mostrar características
class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge,
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
