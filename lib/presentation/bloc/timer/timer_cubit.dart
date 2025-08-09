import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> with WidgetsBindingObserver {
  TimerCubit() : super(const TimerInitial());

  Stopwatch? _stopwatch;
  Timer? _ticker;

  void start() {
    _stopwatch ??= Stopwatch();
    if (!_stopwatch!.isRunning) {
      _stopwatch!.start();
    }
    _startTicker();
    WidgetsBinding.instance.addObserver(this);
  }

  void pause() {
    _stopwatch?.stop();
    emit(TimerPaused(_stopwatch?.elapsed ?? Duration.zero));
  }

  void resume() {
    _stopwatch?.start();
    _startTicker();
  }

  void stop() {
    _ticker?.cancel();
    _stopwatch?.stop();
    emit(TimerPaused(_stopwatch?.elapsed ?? Duration.zero));
  }

  Duration get elapsed => _stopwatch?.elapsed ?? Duration.zero;

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 10), (_) {
      final d = _stopwatch?.elapsed ?? Duration.zero;
      emit(TimerRunning(d));
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && (_stopwatch?.isRunning ?? false)) {
      // Forzar actualización inmediata al volver
      emit(TimerRunning(_stopwatch!.elapsed));
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    return super.close();
  }
}


