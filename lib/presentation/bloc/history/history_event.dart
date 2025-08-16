part of 'history_bloc.dart';

/// Eventos del HistoryBloc
sealed class HistoryEvent {
  const HistoryEvent();
}

class HistoryLoadInitial extends HistoryEvent { const HistoryLoadInitial(); }

class HistoryLoadMore extends HistoryEvent { const HistoryLoadMore(); }

class HistoryRefresh extends HistoryEvent { const HistoryRefresh(); }

class HistoryToggleDayCollapse extends HistoryEvent {
  const HistoryToggleDayCollapse(this.day);
  final DateTime day;
}


