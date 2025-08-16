import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/trip_repository.dart';
import '../../../app_config/router_config.dart';
import '../../bloc/preview/preview_cubit.dart';
import '../../bloc/preview/preview_state.dart';
import '../../widgets/slide_button.dart';
import '../../../app_config/utils/service_type_label.dart';
// import '../../../app_config/utils/date_time_formatter.dart';
// import '../../../app_config/utils/trip_identifier.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key});

  static const String routeName = '/preview';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final tripId = (args is Map && args['tripId'] is String) ? args['tripId'] as String : null;

    return BlocProvider(
      create: (context) => PreviewCubit(
        tripRepository: RepositoryProvider.of<TripRepository>(context),
      ),
      child: BlocListener<PreviewCubit, PreviewState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status == PreviewStatus.failure && state.failureMessage != null) {
            final theme = Theme.of(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failureMessage!),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        child: PreviewView(tripId: tripId),
      ),
    );
  }
}

class PreviewView extends StatelessWidget {
  const PreviewView({super.key, required this.tripId});

  final String? tripId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (tripId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Previsualización'), centerTitle: true),
        body: Center(
          child: Text(
            'Sin identificador de viaje',
            style: theme.textTheme.bodyLarge?.copyWith(color: colors.onSurface),
          ),
        ),
      );
    }

    // Dispara carga al construir
    context.read<PreviewCubit>().load(tripId!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar Viaje'),
        centerTitle: true,
        iconTheme: IconThemeData(color: colors.onSurfaceVariant),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<PreviewCubit, PreviewState>(
            buildWhen: (p, c) => p.status != c.status || p.trip != c.trip,
            builder: (context, state) {
              if (state.status == PreviewStatus.loading || state.status == PreviewStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == PreviewStatus.failure) {
                return Center(
                  child: Text(
                    state.failureMessage ?? 'Error cargando viaje',
                    style: theme.textTheme.bodyLarge?.copyWith(color: colors.error),
                  ),
                );
              }

              return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    _HeaderReadyCard(),
                    SizedBox(height: 16),
                    _PassengerCard(),
                    SizedBox(height: 16),
                    _ServiceTypeCard(),
                    Spacer(),
                    _EditAndStartButtons(),
                  ],
                );
            },
          ),
        ),
      ),
    );
  }
}

class _HeaderReadyCard extends StatelessWidget {
  const _HeaderReadyCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      color: colors.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Listo para iniciar', style: theme.textTheme.headlineSmall?.copyWith(color: colors.onPrimaryContainer)),
            const SizedBox(height: 8),
            Text(
              'Verifica los datos del viaje antes de comenzar.',
              style: theme.textTheme.bodyMedium?.copyWith(color: colors.onPrimaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}

class _PassengerCard extends StatelessWidget {
  const _PassengerCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      color: colors.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.person, color: colors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: BlocBuilder<PreviewCubit, PreviewState>(
                buildWhen: (p, c) => p.trip?.passengerName != c.trip?.passengerName,
                builder: (context, state) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pasajero', style: theme.textTheme.titleMedium?.copyWith(color: colors.onSurface)),
                    const SizedBox(height: 6),
                    Text(state.trip?.passengerName ?? '-', style: theme.textTheme.headlineSmall?.copyWith(color: colors.onSurface)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceTypeCard extends StatelessWidget {
  const _ServiceTypeCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      color: colors.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.directions_car, color: colors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: BlocBuilder<PreviewCubit, PreviewState>(
                buildWhen: (p, c) => p.trip?.serviceType != c.trip?.serviceType,
                builder: (context, state) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tipo de Servicio', style: theme.textTheme.titleMedium?.copyWith(color: colors.onSurface)),
                    const SizedBox(height: 6),
                    Text(serviceTypeLabel(state.trip!.serviceType), style: theme.textTheme.headlineSmall?.copyWith(color: colors.onSurface)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// _TripInfoCard eliminado por requerimiento

class _EditAndStartButtons extends StatelessWidget {
  const _EditAndStartButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SlideButton(
          text: 'Deslizar para Iniciar',
          onSlideCompleted: () {
            final tripId = context.read<PreviewCubit>().state.trip!.id;
            context.pushReplacementNamed('/trip-active', arguments: {'tripId': tripId});
          },
        ),
      ],
    );
  }
}

// Labels centralizados en service_type_label.dart


