import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/trip_repository.dart';
import '../../../domain/repositories/review_repository.dart';
import '../../bloc/trip_detail/trip_detail_cubit.dart';
import '../../../domain/entities/review.dart';
import '../../../app_config/utils/currency_formatter.dart';
import '../../../app_config/utils/date_time_formatter.dart';

class TripDetailPage extends StatelessWidget {
  const TripDetailPage({super.key});

  static const String routeName = '/trip-detail';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final tripId = (args is Map && args['tripId'] is String) ? args['tripId'] as String : null;
    return BlocProvider(
      create: (ctx) => TripDetailCubit(
        tripRepository: RepositoryProvider.of<TripRepository>(ctx),
        reviewRepository: RepositoryProvider.of<ReviewRepository>(ctx),
        tripId: tripId ?? '',
      )..load(),
      child: const _TripDetailView(),
    );
  }
}

class _TripDetailView extends StatelessWidget {
  const _TripDetailView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Viaje'), centerTitle: true),
      body: SafeArea(
        child: BlocBuilder<TripDetailCubit, TripDetailState>(
          buildWhen: (p, c) => p.status != c.status || p.trip != c.trip || p.review != c.review,
          builder: (context, state) {
            switch (state.status) {
              case TripDetailStatus.initial:
              case TripDetailStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case TripDetailStatus.failure:
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, color: colors.error, size: 48),
                        const SizedBox(height: 8),
                        Text(state.failureMessage ?? 'Error', style: theme.textTheme.bodyLarge),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () => context.read<TripDetailCubit>().load(),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                );
              case TripDetailStatus.success:
                final trip = state.trip!;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Pasajero + Monto
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pasajero', style: theme.textTheme.titleMedium),
                              const SizedBox(height: 6),
                              Text(trip.passengerName, style: theme.textTheme.headlineSmall),
                              const SizedBox(height: 12),
                              Text(CurrencyFormatter.format(trip.totalAmount),
                                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Info del viaje
                      _InfoRow(icon: Icons.timer_outlined, label: 'Duración', value: _formatDuration(trip.duration)),
                      const SizedBox(height: 12),
                      _InfoRow(icon: Icons.directions_car, label: 'Servicio', value: trip.serviceType.name),
                      const SizedBox(height: 12),
                      _InfoRow(icon: Icons.event_outlined, label: 'Inicio', value: DateTimeFormatter.formatDateTime(trip.startTime ?? trip.createdAt)),
                      const SizedBox(height: 12),
                      _InfoRow(icon: Icons.flag_outlined, label: 'Fin', value: DateTimeFormatter.formatDateTime(trip.endTime ?? trip.updatedAt)),

                      const SizedBox(height: 24),

                      if (state.review != null) _ReviewSection(review: state.review!),
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '--:--:--';
    final h = duration.inHours.toString().padLeft(2, '0');
    final m = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final s = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});
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

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({required this.review});
  final Review review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.reviews, color: colors.primary),
                const SizedBox(width: 8),
                Text('Reseña', style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(
                5,
                (i) => Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    i < review.rating ? Icons.star : Icons.star_border,
                    color: colors.tertiary,
                    size: 20,
                  ),
                ),
              ),
            ),
            if (review.comment != null && review.comment!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(review.comment!, style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
            ],
            const SizedBox(height: 4),
            Text(
              DateTimeFormatter.formatDateTime(review.createdAt),
              style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}


