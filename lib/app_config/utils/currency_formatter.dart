/// Formateador de moneda en Guaraníes (Gs)
///
/// Reglas:
/// - Prefijo "Gs "
/// - Separadores de miles con puntos: 50.000
/// - Sin decimales
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Formatea un entero como "Gs 50.000"
  static String format(int amount) {
    final absStr = amount.abs().toString();
    final formatted = absStr.replaceAllMapped(
      RegExp(r'(?<=\d)(?=(\d{3})+(?!\d))'),
      (m) => '.',
    );
    final withSign = amount < 0 ? '-$formatted' : formatted;
    return 'Gs $withSign';
  }

  /// Devuelve solo la parte numérica formateada (sin prefijo)
  static String formatNumberOnly(String digits) {
    final clean = digits.replaceAll(RegExp(r'[^\d]'), '');
    if (clean.isEmpty) return '';
    return clean.replaceAllMapped(
      RegExp(r'(?<=\d)(?=(\d{3})+(?!\d))'),
      (m) => '.',
    );
  }
}


