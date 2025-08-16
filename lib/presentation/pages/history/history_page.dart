import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/trip_repository.dart';
import '../../../domain/entities/trip.dart';
import '../../../app_config/utils/date_time_formatter.dart';
import '../../../app_config/utils/currency_formatter.dart';
import '../../bloc/history/history_bloc.dart';

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
      appBar: AppBar(title: const Text('Historial')),

      // ========================================
      // CUERPO DE LA PÁGINA
      // ========================================
      body: BlocProvider(
        create: (context) => HistoryBloc(context.read<TripRepository>())..add(const HistoryLoadInitial()),
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<HistoryBloc, HistoryState>(
                buildWhen: (p, c) =>
                    p.status != c.status ||
                    p.trips != c.trips ||
                    p.collapsedDays != c.collapsedDays,
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

                      // Construir lista aplanada con cabeceras de día + items
                      final rows = _buildRows(state);

                      return NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200 &&
                              context.read<HistoryBloc>().state.status != HistoryStatus.loadingMore &&
                              !context.read<HistoryBloc>().state.reachedEnd) {
                            context.read<HistoryBloc>().add(const HistoryLoadMore());
                          }
                          return false;
                        },
                        child: ListView.separated(
                          itemCount: rows.length + (state.status == HistoryStatus.loadingMore ? 1 : 0),
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            if (index >= rows.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                            final row = rows[index];
                            if (row is _DayHeaderRow) {
                              return _DayHeader(
                                day: row.day,
                                isCollapsed: row.isCollapsed,
                                count: row.count,
                              );
                            }
                            final tripRow = row as _TripRow;
                            return _TripListItem(trip: tripRow.trip);
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

  List<_HistoryRow> _buildRows(HistoryState state) {
    final List<_HistoryRow> rows = [];
    if (state.trips.isEmpty) return rows;
    DateTime? currentDay;
    int currentCount = 0;
    final List<Trip> bufferTrips = [];

    void flushDay() {
      final safeCurrent = currentDay;
      if (safeCurrent == null) return;
      final day = DateTime(safeCurrent.year, safeCurrent.month, safeCurrent.day);
      final isCollapsed = state.collapsedDays.contains(day);
      rows.add(_DayHeaderRow(day: day, isCollapsed: isCollapsed, count: currentCount));
      if (!isCollapsed) {
        for (final t in bufferTrips) {
          rows.add(_TripRow(t));
        }
      }
      bufferTrips.clear();
      currentCount = 0;
    }

    for (final trip in state.trips) {
      final local = trip.createdAt.toLocal();
      final day = DateTime(local.year, local.month, local.day);
      if (currentDay == null || day != currentDay) {
        flushDay();
        currentDay = day;
      }
      bufferTrips.add(trip);
      currentCount++;
    }
    flushDay();
    return rows;
  }
}

class _TripListItem extends StatelessWidget {
  const _TripListItem({required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).pushNamed('/trip-detail', arguments: {'tripId': trip.id}),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(trip.passengerName, style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 2),
                    Text(
                      DateTimeFormatter.formatTime(trip.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                    ),
                    Text(
                      _formatDuration(trip.duration),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                    ),
                    Text(
                      CurrencyFormatter.format(trip.totalAmount),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 24,
                child: Center(
                  child: Icon(Icons.chevron_right, color: colors.onSurfaceVariant),
                ),
              ),
            ],
          ),
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

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.day, required this.isCollapsed, required this.count});
  final DateTime day;
  final bool isCollapsed;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final formatted = _formatDay(day);
    return InkWell(
      onTap: () => context.read<HistoryBloc>().add(HistoryToggleDayCollapse(day)),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              isCollapsed ? Icons.expand_more : Icons.expand_less,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              formatted,
              style: theme.textTheme.titleMedium,
            ),
            const Spacer(),
            Text(
              '$count',
              style: theme.textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDay(DateTime day) {
    final d = day.toLocal();
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }
}

abstract class _HistoryRow {}

class _DayHeaderRow extends _HistoryRow {
  _DayHeaderRow({required this.day, required this.isCollapsed, required this.count});
  final DateTime day;
  final bool isCollapsed;
  final int count;
}

class _TripRow extends _HistoryRow {
  _TripRow(this.trip);
  final Trip trip;
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
            onPressed: () => context.read<HistoryBloc>().add(const HistoryLoadInitial()),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
