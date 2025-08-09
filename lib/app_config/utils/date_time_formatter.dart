/// Utilidades para formateo de fecha y hora
///
/// - Fecha: DD-MM-YYYY
/// - Hora: 12h con sufijo AM/PM (HH:MM AM/PM)
class DateTimeFormatter {
  DateTimeFormatter._();

  /// Retorna la fecha en formato DD-MM-YYYY (ej: 24-05-2024)
  static String formatDate(DateTime dateTime) {
    final local = dateTime.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString().padLeft(4, '0');
    return '$day-$month-$year';
  }

  /// Retorna la hora en formato 12h con AM/PM (ej: 10:30 AM)
  static String formatTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    int hour = local.hour % 12;
    hour = hour == 0 ? 12 : hour; // 0 -> 12
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour < 12 ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  /// Retorna fecha y hora combinadas con separador (por defecto: " - ")
  static String formatDateTime(DateTime dateTime, {String separator = ' - '}) {
    return '${formatDate(dateTime)}$separator${formatTime(dateTime)}';
  }
}


