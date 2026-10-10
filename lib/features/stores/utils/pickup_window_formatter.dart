import 'package:go_to_save_app/features/stores/models/pickup_window.dart';
import 'package:intl/intl.dart';

class PickupWindowFormatter {
  static String formatPickupWindowLabel(PickupWindow window) {
    final dateFormat = DateFormat('dd/MM', 'pt_BR');
    final timeFormat = DateFormat.Hm('pt_BR');
    final now = DateTime.now();

    final crossesMidnight =
        window.start.day != window.end.day ||
        window.start.month != window.end.month ||
        window.start.year != window.end.year;

    final startLabel = _dayLabel(window.start, now, dateFormat);
    final startTime = timeFormat.format(window.start);
    final endTime = timeFormat.format(window.end);

    if (!crossesMidnight) {
      return '$startLabel, $startTime às $endTime';
    }

    final endLabel = _dayLabel(window.end, now, dateFormat);

    return '$startLabel, $startTime — $endLabel, $endTime';
  }

  static String _dayLabel(DateTime date, DateTime now, DateFormat dateFormat) {
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    final tomorrow = now.add(const Duration(days: 1));
    final isTomorrow =
        date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;

    if (isToday) return 'Hoje';
    if (isTomorrow) return 'Amanhã';

    return dateFormat.format(date);
  }
}
