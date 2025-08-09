import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/trip.dart';
import '../../../domain/repositories/trip_repository.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key});

  static const String routeName = '/preview';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final args = ModalRoute.of(context)?.settings.arguments;
    final tripId = (args is Map && args['tripId'] is String) ? args['tripId'] as String : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Previsualización'),
        centerTitle: true,
      ),
      body: tripId == null
          ? Center(
              child: Text(
                'Sin identificador de viaje',
                style: theme.textTheme.bodyLarge?.copyWith(color: colors.onSurface),
              ),
            )
          : FutureBuilder<Trip?>(
              future: _getRepository(context).getTripById(tripId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error cargando viaje',
                      style: theme.textTheme.bodyLarge?.copyWith(color: colors.error),
                    ),
                  );
                }
                final trip = snapshot.data;
                if (trip == null) {
                  return Center(
                    child: Text(
                      'Viaje no encontrado',
                      style: theme.textTheme.bodyLarge?.copyWith(color: colors.onSurface),
                    ),
                  );
                }

                return SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pasajero', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(trip.passengerName, style: theme.textTheme.bodyLarge),
                        const SizedBox(height: 16),
                        Text('Monto', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(_formatGs(trip.totalAmount), style: theme.textTheme.headlineSmall),
                        const SizedBox(height: 16),
                        Text('Servicio', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(_serviceLabel(trip.serviceType), style: theme.textTheme.bodyLarge),
                        const SizedBox(height: 16),
                        Text('Creado', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(trip.createdAt.toString(), style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  TripRepository _getRepository(BuildContext context) {
    return RepositoryProvider.of<TripRepository>(context);
  }

  String _formatGs(int amount) {
    final text = amount.toString().replaceAllMapped(
      RegExp(r'(?=(\d{3})+(?!\d))'),
      (m) => '.',
    );
    return 'Gs $text';
  }

  String _serviceLabel(ServiceType type) {
    switch (type) {
      case ServiceType.economy:
        return 'Económico';
      case ServiceType.uberX:
        return 'UberX';
      case ServiceType.aireAc:
        return 'Aire Acondicionado';
    }
  }
}


