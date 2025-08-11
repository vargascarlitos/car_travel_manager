import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/trip_repository.dart';
import '../../bloc/timer/timer_cubit.dart';
import '../../bloc/timer/timer_state.dart';
import '../../bloc/active_trip/active_trip_cubit.dart';
import '../../bloc/active_trip/active_trip_state.dart';
import '../../widgets/slide_button.dart';
import 'package:lottie/lottie.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class ActiveTripPage extends StatelessWidget {
  const ActiveTripPage({super.key});

  static const String routeName = '/trip-active';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final tripId = (args is Map && args['tripId'] is String) ? args['tripId'] as String : null;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TimerCubit()),
        BlocProvider(
          create: (ctx) => ActiveTripCubit(
            repository: RepositoryProvider.of<TripRepository>(ctx),
            timer: ctx.read<TimerCubit>(),
          )..startTrip(tripId ?? ''),
        ),
      ],
      child: const _ActiveTripView(),
    );
  }
}

class _ActiveTripView extends StatefulWidget {
  const _ActiveTripView();

  @override
  State<_ActiveTripView> createState() => _ActiveTripViewState();
}

class _ActiveTripViewState extends State<_ActiveTripView> {
  double _dragAccumulatedDy = 0;

  Future<void> _navigateToModifyIfNeeded(BuildContext context, {double? velocity}) async {
    final v = velocity ?? 0;
    if (_dragAccumulatedDy > 80 || v > 300) {
      final state = context.read<ActiveTripCubit>().state;
      final tripId = state.trip?.id;
      if (tripId == null) return;
      final result = await Navigator.pushNamed(
        context,
        '/trip-modify',
        arguments: {'tripId': tripId},
      );
      if (mounted && result == true) {
        await context.read<ActiveTripCubit>().refreshTrip();
      }
    }
    _dragAccumulatedDy = 0;
  }
  @override
  void initState() {
    super.initState();
    // Mantener la pantalla encendida mientras el viaje esté activo
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    // Liberar wakelock al abandonar la pantalla
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return BlocListener<ActiveTripCubit, ActiveTripState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == ActiveTripStatus.failure && state.failureMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.failureMessage!), backgroundColor: colors.error),
          );
        }
        if (state.status == ActiveTripStatus.completed && state.trip != null) {
          Navigator.pushReplacementNamed(context, '/ticket', arguments: {
            'tripId': state.trip!.id,
            'durationSeconds': state.trip!.duration?.inSeconds,
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<ActiveTripCubit, ActiveTripState>(
            buildWhen: (p, c) => p.trip?.displayId != c.trip?.displayId,
            builder: (context, state) => Text(
              state.trip?.displayId != null ? 'Trip #${state.trip!.displayId}' : 'Viaje en Curso',
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragUpdate: (details) {
              if (details.delta.dy > 0) {
                _dragAccumulatedDy += details.delta.dy;
              }
            },
            onVerticalDragEnd: (details) async {
              await _navigateToModifyIfNeeded(context, velocity: details.primaryVelocity);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SwipeDownIndicator(),
                  const SizedBox(height: 12),
                  // Título discreto en vez de cronómetro gigante
                  Text(
                    'Viaje en Curso',
                    style: theme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const _CarAnimationCard(),
                  const SizedBox(height: 16),
                  const _TripInfoCard(),
                  const Spacer(),
                  _FinishSlideButton(onFinish: context.read<ActiveTripCubit>().finishTrip),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SwipeDownIndicator extends StatelessWidget {
  const _SwipeDownIndicator();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Icon(Icons.keyboard_arrow_down, color: colors.onSurfaceVariant),
    );
  }
}

String _formatTimer(Duration d) {
  final h = d.inHours.remainder(100).toString().padLeft(2, '0');
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$h:$m:$s';
}

class _CarAnimationCard extends StatelessWidget {
  const _CarAnimationCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      color: colors.surfaceVariant,
      child: SizedBox(
        height: 140,
        child: Center(
          child: Lottie.asset(
            'assets/animations/delivery_animation.json',
            height: 300,
            repeat: true,
            animate: true,
          ),
        ),
      ),
    );
  }
}

class _TripInfoCard extends StatelessWidget {
  const _TripInfoCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<ActiveTripCubit, ActiveTripState>(
          buildWhen: (p, c) => p.trip != c.trip,
          builder: (context, state) {
            final trip = state.trip;
            if (trip == null) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cronómetro más discreto dentro de la tarjeta de información
                Row(
                  children: [
                    Icon(Icons.timer_outlined, color: colors.primary),
                    const SizedBox(width: 8),
                    BlocBuilder<TimerCubit, TimerState>(
                      buildWhen: (p, c) {
                        final prev = p is TimerRunning ? p.elapsed.inSeconds : (p is TimerPaused ? p.elapsed.inSeconds : -1);
                        final curr = c is TimerRunning ? c.elapsed.inSeconds : (c is TimerPaused ? c.elapsed.inSeconds : -1);
                        return prev != curr;
                      },
                      builder: (context, state) {
                        final d = state is TimerRunning
                            ? state.elapsed
                            : state is TimerPaused
                                ? state.elapsed
                                : Duration.zero;
                        return Text(
                          _formatTimer(d),
                          style: theme.textTheme.headlineSmall, // tamaño moderado
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(children: [Icon(Icons.person, color: colors.primary), const SizedBox(width: 8), Text('Pasajero', style: theme.textTheme.titleMedium)]),
                const SizedBox(height: 6),
                Text(trip.passengerName, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 12),
                Row(children: [Icon(Icons.directions_car, color: colors.primary), const SizedBox(width: 8), Text('Servicio', style: theme.textTheme.titleMedium)]),
                const SizedBox(height: 6),
                Text(trip.serviceType.name),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FinishSlideButton extends StatelessWidget {
  const _FinishSlideButton({required this.onFinish});
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Theme(
      data: Theme.of(context).copyWith(colorScheme: Theme.of(context).colorScheme.copyWith(primary: colors.error, onPrimary: colors.onError, primaryContainer: colors.errorContainer)),
      child: SlideButton(text: 'Finalizar viaje', onSlideCompleted: onFinish),
    );
  }
}


