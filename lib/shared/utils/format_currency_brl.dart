import 'package:intl/intl.dart';

String formatCurrencyBrl(num value) {
  return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value);
}
