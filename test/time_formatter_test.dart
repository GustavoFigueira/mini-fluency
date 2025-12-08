import 'package:flutter_test/flutter_test.dart';
import 'package:mini_fluency/core/utils/time_formatter.dart';

void main() {
  group('TimeFormatter', () {
    group('formatSeconds', () {
      test('should format seconds less than 60', () {
        expect(TimeFormatter.formatSeconds(0), '0s');
        expect(TimeFormatter.formatSeconds(30), '30s');
        expect(TimeFormatter.formatSeconds(59), '59s');
      });

      test('should format minutes without remaining seconds', () {
        expect(TimeFormatter.formatSeconds(60), '1min');
        expect(TimeFormatter.formatSeconds(120), '2min');
        expect(TimeFormatter.formatSeconds(300), '5min');
      });

      test('should format minutes with remaining seconds', () {
        expect(TimeFormatter.formatSeconds(61), '1min 1s');
        expect(TimeFormatter.formatSeconds(90), '1min 30s');
        expect(TimeFormatter.formatSeconds(125), '2min 5s');
      });
    });

    group('formatMinutes', () {
      test('should format minutes less than 60', () {
        expect(TimeFormatter.formatMinutes(0), '0 min');
        expect(TimeFormatter.formatMinutes(30), '30 min');
        expect(TimeFormatter.formatMinutes(59), '59 min');
      });

      test('should format hours without remaining minutes', () {
        expect(TimeFormatter.formatMinutes(60), '1h');
        expect(TimeFormatter.formatMinutes(120), '2h');
        expect(TimeFormatter.formatMinutes(180), '3h');
      });

      test('should format hours with remaining minutes', () {
        expect(TimeFormatter.formatMinutes(61), '1h 1min');
        expect(TimeFormatter.formatMinutes(90), '1h 30min');
        expect(TimeFormatter.formatMinutes(125), '2h 5min');
      });
    });
  });
}
