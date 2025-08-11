import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/trip_repository.dart';
import '../../../domain/entities/trip.dart';
import '../../../app_config/utils/date_time_formatter.dart';
import '../../../app_config/utils/currency_formatter.dart';
import '../../bloc/history/history_cubit.dart';

/// Pantalla de Historial de Viajes - Temporal
/// 
/// Muestra lista de viajes pasados (implementación básica)
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  /// Ruta estática de la página
  static const String route = '/history';

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return Scaffold(
      // ========================================
      // TOP APP BAR
      // ========================================
      appBar: AppBar(title: const Text('Historial')),

      // ========================================
      // CUERPO DE LA PÁGINA
      // ========================================
      body: BlocProvider(
        create: (context) => HistoryCubit(context.read<TripRepository>())..loadInitial(),
        child: const _HistoryView(),
      ),

      // ========================================
      // FLOATING ACTION BUTTON
      // ========================================
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<HistoryCubit, HistoryState>(
                buildWhen: (p, c) => p.status != c.status || p.trips != c.trips,
                builder: (context, state) {
                  switch (state.status) {
                    case HistoryStatus.initial:
                    case HistoryStatus.loading:
                      return const Center(child: CircularProgressIndicator());
                    case HistoryStatus.failure:
                      return _ErrorRetry(message: state.failureMessage ?? 'Error');
                    case HistoryStatus.success:
                    case HistoryStatus.loadingMore:
                      if (state.trips.isEmpty) return const _EmptyState();
                      return NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200 &&
                              context.read<HistoryCubit>().state.status != HistoryStatus.loadingMore &&
                              !context.read<HistoryCubit>().state.reachedEnd) {
                            context.read<HistoryCubit>().loadMore();
                          }
                          return false;
                        },
                        child: ListView.separated(
                          itemCount: state.trips.length + (state.status == HistoryStatus.loadingMore ? 1 : 0),
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            if (index >= state.trips.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                            final trip = state.trips[index];
                            return _TripListItem(trip: trip);
                          },
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripListItem extends StatelessWidget {
  const _TripListItem({required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colors.primaryContainer,
          child: Text('#${trip.displayId ?? '-'}', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.onPrimaryContainer)),
        ),
        title: Text(
          trip.passengerName,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: Text(
          '${DateTimeFormatter.formatDateTime(trip.createdAt)} • ${_formatDuration(trip.duration)} • ${CurrencyFormatter.format(trip.totalAmount)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
        trailing: Icon(Icons.chevron_right, color: colors.onSurfaceVariant),
        onTap: () => Navigator.of(context).pushNamed('/trip-detail', arguments: {'tripId': trip.id}),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history, size: 56, color: colors.onSurfaceVariant),
          const SizedBox(height: 12),
          Text('Sin viajes todavía', style: Theme.of(context).textTheme.titleMedium),
          Text('Cuando completes viajes aparecerán aquí', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  const _ErrorRetry({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => context.read<HistoryCubit>().loadInitial(),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
