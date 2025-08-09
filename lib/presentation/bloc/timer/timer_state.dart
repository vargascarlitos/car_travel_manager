import 'package:equatable/equatable.dart';

abstract class TimerState extends Equatable {
  const TimerState();
}

class TimerInitial extends TimerState {
  const TimerInitial();
  @override
  List<Object?> get props => [];
}

class TimerRunning extends TimerState {
  const TimerRunning(this.elapsed);
  final Duration elapsed;
  @override
  List<Object?> get props => [elapsed];
}

class TimerPaused extends TimerState {
  const TimerPaused(this.elapsed);
  final Duration elapsed;
  @override
  List<Object?> get props => [elapsed];
}


