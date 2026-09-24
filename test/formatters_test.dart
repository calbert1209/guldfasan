import 'package:flutter_test/flutter_test.dart';
import 'package:guldfasan/utils/formatters.dart';

void main() {
  group('formatPrice', () {
    test('formats positive numbers with thousands separators and no currency symbol', () {
      expect(formatPrice(9500000), '9,500,000');
      expect(formatPrice(1234), '1,234');
      expect(formatPrice(0), '0');
    });

    test('formats negative numbers with leading minus and thousands separators', () {
      expect(formatPrice(-1234), '-1,234');
      expect(formatPrice(-5000000), '-5,000,000');
    });

    test('does not contain yen symbol or JPY', () {
      final formatted = formatPrice(9500000);
      expect(formatted.contains('¥'), false);
      expect(formatted.contains('JPY'), false);

      final formattedNegative = formatPrice(-1234);
      expect(formattedNegative.contains('¥'), false);
      expect(formattedNegative.contains('JPY'), false);
    });
  });

  group('formatDecimalPrice', () {
    test('formats positive numbers with 3 decimal places and thousands separators', () {
      expect(formatDecimalPrice(50000), '50,000.000');
      expect(formatDecimalPrice(1234.5), '1,234.500');
      expect(formatDecimalPrice(1234.5678), '1,234.568');
      expect(formatDecimalPrice(0), '0.000');
    });

    test('formats negative numbers with leading minus and 3 decimal places', () {
      expect(formatDecimalPrice(-1234.5), '-1,234.500');
      expect(formatDecimalPrice(-50000), '-50,000.000');
    });

    test('does not contain yen symbol or JPY', () {
      final formatted = formatDecimalPrice(50000);
      expect(formatted.contains('¥'), false);
      expect(formatted.contains('JPY'), false);

      final formattedNegative = formatDecimalPrice(-1234.5);
      expect(formattedNegative.contains('¥'), false);
      expect(formattedNegative.contains('JPY'), false);
    });
  });
}
