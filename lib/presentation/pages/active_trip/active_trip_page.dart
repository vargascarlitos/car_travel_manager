import 'dart:async';

import 'package:flutter/material.dart';

class ActiveTripPage extends StatelessWidget {
  const ActiveTripPage({super.key});

  static const String routeName = '/trip-active';

  @override
  Widget build(BuildContext context) {
    return const _ActiveTripView();
  }
}

class _ActiveTripView extends StatefulWidget {
  const _ActiveTripView();

  @override
  State<_ActiveTripView> createState() => _ActiveTripViewState();
}

class _ActiveTripViewState extends State<_ActiveTripView> {
  late Stopwatch _stopwatch;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final elapsed = _stopwatch.elapsed;
    final formatted = _format(elapsed);

    return Scaffold(
      appBar: AppBar(title: const Text('Viaje en Curso'), centerTitle: true),
      body: Center(
        child: Card(
          color: colors.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Text(
              formatted,
              style: theme.textTheme.displaySmall?.copyWith(color: colors.onPrimaryContainer),
            ),
          ),
        ),
      ),
    );
  }

  String _format(Duration d) {
    final h = d.inHours.remainder(100).toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}


