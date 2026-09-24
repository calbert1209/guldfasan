import 'package:flutter_test/flutter_test.dart';
import 'package:guldfasan/services/fetcher.dart';

void main() {
  group('parseGoldPrices', () {
    test('parses valid HTML with Tanaka gold prices', () {
      const html = '''
        <table>
          <tbody id="metal_price">
            <tr class="gold">
              <td class="retail_tax">29,755 円</td>
              <td class="purchase_tax">29,398 円</td>
            </tr>
          </tbody>
        </table>
      ''';

      final prices = parseGoldPrices(html);
      expect(prices, equals({'retail': 29755, 'buy': 29398}));
    });

    test('throws StateError when gold row is missing', () {
      const html = '''
        <tbody id="metal_price">
          <tr class="silver">
            <td class="retail_tax">350 円</td>
            <td class="purchase_tax">320 円</td>
          </tr>
        </tbody>
      ''';

      expect(() => parseGoldPrices(html), throwsA(isA<StateError>()));
    });
  });

  group('parseCoinPrices', () {
    test('parses valid CoinGecko JSON string', () {
      const jsonStr =
          '{"bitcoin": {"jpy": 9500000}, "ethereum": {"jpy": 450000}}';

      final prices = parseCoinPrices(jsonStr);
      expect(prices, equals({'BTC': 9500000, 'ETH': 450000}));
    });

    test('handles partial JSON with null or missing coins', () {
      const jsonMissingEth = '{"bitcoin": {"jpy": 9500000}}';
      expect(
          parseCoinPrices(jsonMissingEth), equals({'BTC': 9500000, 'ETH': null}));

      const jsonMissingBtc = '{"ethereum": {"jpy": 450000}}';
      expect(
          parseCoinPrices(jsonMissingBtc), equals({'BTC': null, 'ETH': 450000}));

      const jsonNullEntries = '{"bitcoin": null, "ethereum": {"jpy": null}}';
      expect(
          parseCoinPrices(jsonNullEntries), equals({'BTC': null, 'ETH': null}));

      const emptyJson = '{}';
      expect(parseCoinPrices(emptyJson), equals({'BTC': null, 'ETH': null}));
    });
  });
}
