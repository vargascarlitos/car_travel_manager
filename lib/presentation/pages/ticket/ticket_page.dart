import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/trip.dart';
import '../../../app_config/utils/service_type_label.dart';
import '../../../domain/repositories/trip_repository.dart';
import '../../../app_config/utils/currency_formatter.dart';
// import '../../../app_config/utils/date_time_formatter.dart';

class TicketPage extends StatelessWidget {
  const TicketPage({super.key});

  static const String routeName = '/ticket';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final tripId =
        (args is Map && args['tripId'] is String)
            ? args['tripId'] as String
            : null;
    return Scaffold(
      appBar: AppBar(title: const Text('VIAJE COMPLETADO'), centerTitle: true),
      body: SafeArea(
        child:
            tripId == null
                ? const _TicketError(message: 'Falta el identificador de viaje')
                : FutureBuilder<Trip?>(
                  future: RepositoryProvider.of<TripRepository>(
                    context,
                  ).getTripById(tripId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const _TicketError(
                        message: 'Error al cargar el ticket',
                      );
                    }
                    final trip = snapshot.data;
                    if (trip == null) {
                      return const _TicketError(message: 'Viaje no encontrado');
                    }
                    return _TicketView(trip: trip);
                  },
                ),
      ),
      bottomNavigationBar:
          tripId == null
              ? null
              : SafeArea(
                minimum: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/review',
                        arguments: {'tripId': tripId},
                      );
                    },
                    child: const Text('Siguiente'),
                  ),
                ),
              ),
    );
  }
}

class _TicketView extends StatelessWidget {
  const _TicketView({required this.trip});

  final Trip trip;

  String _formatTimer(Duration? d) {
    final dur = d ?? Duration.zero;
    final h = dur.inHours.remainder(100).toString().padLeft(2, '0');
    final m = dur.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = dur.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${trip.passengerName} pagará',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      CurrencyFormatter.format(trip.totalAmount),
                      maxLines: 1,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                        fontSize: 64,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Resumen simple (sin card vistoso)
          _SummaryRow(
            icon: Icons.timer_outlined,
            label: 'Duración',
            value: _formatTimer(trip.duration),
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            icon: Icons.directions_car,
            label: 'Servicio',
            value: serviceTypeLabel(trip.serviceType),
          ),
          const SizedBox(height: 12),

          // ID removido según pedido
          // _SummaryRow(icon: Icons.confirmation_number_outlined, label: 'ID', value: '#${trip.displayId ?? '—'}'),
          // const SizedBox(height: 12),
          // Fecha opcional (si quieres mantenerla)
          // _SummaryRow(icon: Icons.event_outlined, label: 'Fecha', value: DateTimeFormatter.formatDateTime(trip.endTime ?? trip.updatedAt)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Row(
      children: [
        Icon(icon, color: colors.primary),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: theme.textTheme.titleMedium)),
        Text(value, style: theme.textTheme.bodyLarge),
      ],
    );
  }
}

class _TicketError extends StatelessWidget {
  const _TicketError({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Center(
      child: Text(
        message,
        style: theme.textTheme.bodyLarge?.copyWith(color: colors.error),
      ),
    );
  }
}
