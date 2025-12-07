/// Utility class for formatting time values
abstract final class TimeFormatter {
  static String formatSeconds(int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    }

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    if (remainingSeconds == 0) {
      return '${minutes}min';
    }

    return '${minutes}min ${remainingSeconds}s';
  }

  static String formatMinutes(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (remainingMinutes == 0) {
      return '${hours}h';
    }

    return '${hours}h ${remainingMinutes}min';
  }
}
