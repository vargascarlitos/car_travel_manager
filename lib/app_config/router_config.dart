import 'package:flutter/material.dart';
import '../presentation/pages/pages.dart';

/// Configuración de rutas para TaxiMeter Pro
/// 
/// Maneja todas las rutas de la aplicación usando Navigator 1.0
/// con rutas estáticas definidas en cada página.
/// 
/// Siguiendo Clean Architecture: presentation/pages/*/page.dart
class AppRouter {
  AppRouter._();

  // ========================================
  // RUTAS PRINCIPALES
  // ========================================

  /// Ruta inicial - Pantalla de nuevo viaje
  static const String initialRoute = '/';

  /// Generar rutas dinámicamente
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        // Importación dinámica para evitar dependencias circulares
        return _buildRoute(
          () => _getNewTripPage(),
          settings: settings,
        );

      case '/history':
        return _buildRoute(
          () => _getHistoryPage(),
          settings: settings,
        );

      case '/preview':
        return _buildRoute(
          () => _getPreviewPage(),
          settings: settings,
          arguments: settings.arguments,
        );

      case '/trip-active':
        return _buildRoute(
          () => _getActiveTripPage(),
          settings: settings,
          arguments: settings.arguments,
        );

      case '/trip-modify':
        // Transición especial: ENTRA desde arriba → abajo, y al volver sale hacia arriba
        return _buildTopDownRoute(
          () => _getModifyTripPage(),
          settings: settings,
        );

      case '/ticket':
        return _buildRoute(
          () => _getTicketPage(),
          settings: settings,
          arguments: settings.arguments,
        );

      case '/review':
        return _buildRoute(
          () => _getReviewPage(),
          settings: settings,
          arguments: settings.arguments,
        );

      case '/trip-detail':
        return _buildRoute(
          () => _getTripDetailPage(),
          settings: settings,
          arguments: settings.arguments,
        );

      default:
        return _buildErrorRoute(settings.name);
    }
  }

  // ========================================
  // BUILDERS DE PÁGINAS
  // ========================================

  /// Obtener página de nuevo viaje
  static Widget _getNewTripPage() {
    try {
      return const NewTripPage();
    } catch (e) {
      return _getErrorPage('Error cargando página de nuevo viaje: $e');
    }
  }

  /// Obtener página de historial
  static Widget _getHistoryPage() {
    try {
      return const HistoryPage();
    } catch (e) {
      return _getErrorPage('Error cargando historial: $e');
    }
  }

  /// Obtener página de previsualización
  static Widget _getPreviewPage() {
    return const PreviewPage();
  }

  /// Obtener página de viaje activo
  static Widget _getActiveTripPage() {
    return const ActiveTripPage();
  }

  /// Obtener página de modificación
  static Widget _getModifyTripPage() {
    return const ModifyTripPage();
  }

  /// Obtener página de ticket
  static Widget _getTicketPage() {
    return const TicketPage();
  }

  /// Obtener página de reseña
  static Widget _getReviewPage() {
    return const ReviewPage();
  }

  /// Obtener página de detalle del viaje
  static Widget _getTripDetailPage() {
    return const TripDetailPage();
  }

  // ========================================
  // UTILIDADES DE CONSTRUCCIÓN
  // ========================================

  /// Construir ruta con transición personalizada
  static Route<dynamic> _buildRoute(
    Widget Function() builder, {
    required RouteSettings settings,
    Object? arguments,
  }) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(),
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Transición deslizante desde la derecha
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var slideTween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: curve),
        );

        return SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }

  /// Ruta con transición deslizante vertical: entra desde arriba
  /// Basado en la guía oficial de Flutter para PageRouteBuilder
  /// Ver: Animate a page route transition (Slide from bottom) adaptado
  static Route<dynamic> _buildTopDownRoute(
    Widget Function() builder, {
    required RouteSettings settings,
  }) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(),
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Entra desde arriba (y = -1 → 0). Al volver, sale hacia arriba automáticamente.
        const begin = Offset(0.0, -1.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  /// Construir ruta de error
  static Route<dynamic> _buildErrorRoute(String? routeName) {
    return MaterialPageRoute<dynamic>(
      builder: (context) => _getErrorPage('Ruta no encontrada: $routeName'),
      settings: RouteSettings(name: '/error'),
    );
  }

  /// Página de placeholder para rutas no implementadas
  // _getPlaceholderPage eliminado (todas las rutas implementadas)

  /// Página de error
  static Widget _getErrorPage(String message) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[600],
              ),
              const SizedBox(height: 16),
              Text(
                'Ocurrió un error',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),
              Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    '/',
                    (route) => false,
                  ),
                  child: const Text('Ir al Inicio'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========================================
  // MÉTODOS DE NAVEGACIÓN HELPERS
  // ========================================

  /// Navegar a una ruta con reemplazo
  static Future<T?> pushReplacement<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Navegar y limpiar stack
  static Future<T?> pushAndRemoveUntil<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Volver a la pantalla anterior
  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }

  /// Verificar si se puede volver
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  // ========================================
  // INFORMACIÓN DE RUTAS
  // ========================================

  /// Obtener todas las rutas disponibles
  static Map<String, String> get availableRoutes => {
        '/': 'Nuevo Viaje',
        '/history': 'Historial de Viajes',
        '/preview': 'Previsualización',
        '/trip-active': 'Viaje en Curso',
        '/trip-modify': 'Modificar Viaje',
        '/ticket': 'Ticket del Viaje',
        '/review': 'Auto Reseña',
        '/trip-detail': 'Detalle del Viaje',
      };

  /// Verificar si una ruta es válida
  static bool isValidRoute(String route) {
    return availableRoutes.containsKey(route);
  }
}

/// Extensión para facilitar navegación desde widgets
extension AppRouterExtension on BuildContext {
  /// Navegar a una ruta
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed(this, routeName, arguments: arguments);
  }

  /// Navegar con reemplazo
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return Navigator.pushReplacementNamed(
      this,
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Navegar y limpiar stack
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil(
      this,
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  /// Volver a la pantalla anterior
  void pop<T extends Object?>([T? result]) {
    Navigator.pop(this, result);
  }

  /// Verificar si se puede volver
  bool canPop() {
    return Navigator.canPop(this);
  }
}
