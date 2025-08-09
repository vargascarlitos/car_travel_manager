import 'package:flutter/material.dart';
import '../../../app_config/theme_config.dart';

/// Pantalla de Historial de Viajes - Temporal
/// 
/// Muestra lista de viajes pasados (implementación básica)
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  /// Ruta estática de la página
  static const String route = '/history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ========================================
      // TOP APP BAR
      // ========================================
      appBar: AppBar(
        title: Text(
          'Historial',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.onSurface,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 4,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.onSurface),
      ),

      // ========================================
      // CUERPO DE LA PÁGINA
      // ========================================
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header con estadísticas rápidas
              Card(
                elevation: 4,
                color: AppColors.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                        icon: Icons.local_taxi,
                        value: '124',
                        label: 'Viajes',
                      ),
                      _StatItem(
                        icon: Icons.payments,
                        value: 'Gs 2.5M',
                        label: 'Total',
                      ),
                      _StatItem(
                        icon: Icons.star,
                        value: '4.8',
                        label: 'Rating',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Lista de viajes (placeholder)
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primaryContainer,
                          child: Text(
                            '#${123 - index}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          'Viaje ${123 - index}',
                          style: AppTextStyles.bodyLarge,
                        ),
                        subtitle: Text(
                          'Hace ${index + 1} ${index == 0 ? 'hora' : 'horas'} • Gs ${(15000 + (index * 2000)).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Completado',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.onPrimaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Detalle del viaje ${123 - index}',
                                style: AppTextStyles.bodyMedium,
                              ),
                              backgroundColor: AppColors.primaryContainer,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // ========================================
      // FLOATING ACTION BUTTON
      // ========================================
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamedAndRemoveUntil(
          context,
          '/',
          (route) => false,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        child: const Icon(Icons.add),
        tooltip: 'Nuevo Viaje',
      ),
    );
  }
}

/// Widget para mostrar estadísticas
class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}
