import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/trip.dart';
import '../../../domain/repositories/trip_repository.dart';
import '../../../app_config/utils/currency_formatter.dart';
import '../../../app_config/utils/date_time_formatter.dart';
import '../../bloc/pending_recovery/pending_recovery_cubit.dart';

class PendingRecoveryPage extends StatelessWidget {
  const PendingRecoveryPage({super.key});

  static const String routeName = '/pending-recovery';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return BlocProvider(
      create: (context) => PendingRecoveryCubit(
        RepositoryProvider.of<TripRepository>(context),
      )..load(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Recuperar viaje pendiente'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocBuilder<PendingRecoveryCubit, PendingRecoveryState>(
            buildWhen: (p, c) => p.status != c.status || p.trips != c.trips,
            builder: (context, state) {
              switch (state.status) {
                case PendingRecoveryStatus.initial:
                case PendingRecoveryStatus.loading:
                  return const Center(child: CircularProgressIndicator());
                case PendingRecoveryStatus.failure:
                  return Center(
                    child: Text(
                      state.failureMessage ?? 'Error al cargar pendientes',
                      style: theme.textTheme.bodyLarge?.copyWith(color: colors.error),
                    ),
                  );
                case PendingRecoveryStatus.success:
                  if (state.trips.isEmpty) {
                    return Center(
                      child: Text('No hay viajes pendientes', style: theme.textTheme.titleMedium),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.trips.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final trip = state.trips[index];
                      return _PendingItem(trip: trip);
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _PendingItem extends StatelessWidget {
  const _PendingItem({required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.pushReplacementNamed(
            context,
            '/preview',
            arguments: {'tripId': trip.id},
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip.passengerName, style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 4),
                    Text(
                      DateTimeFormatter.formatDateTime(trip.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      CurrencyFormatter.format(trip.totalAmount),
                      style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.navigate_next, color: colors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}


