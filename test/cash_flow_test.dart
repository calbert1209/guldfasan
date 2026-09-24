import 'package:flutter_test/flutter_test.dart';
import 'package:guldfasan/models/cash_flow.dart';
import 'package:guldfasan/models/position.dart';

void main() {
  group('CashFlow', () {
    test('returnOnInvestment calculates cashOut - cashIn', () {
      final positiveFlow = CashFlow(100.0, 150.0);
      expect(positiveFlow.returnOnInvestment(), 50.0);

      final negativeFlow = CashFlow(100.0, 80.0);
      expect(negativeFlow.returnOnInvestment(), -20.0);

      final breakEvenFlow = CashFlow(100.0, 100.0);
      expect(breakEvenFlow.returnOnInvestment(), 0.0);
    });

    test('rateOfReturn calculates (cashOut - cashIn) / cashIn', () {
      final positiveFlow = CashFlow(100.0, 150.0);
      expect(positiveFlow.rateOfReturn(), closeTo(0.5, 1e-9));

      final negativeFlow = CashFlow(100.0, 80.0);
      expect(negativeFlow.rateOfReturn(), closeTo(-0.2, 1e-9));

      final breakEvenFlow = CashFlow(100.0, 100.0);
      expect(breakEvenFlow.rateOfReturn(), 0.0);
    });

    test('add accumulates cashIn and cashOut', () {
      final flow = CashFlow(100.0, 120.0);
      final added = flow.add(50.0, 70.0);

      expect(added.cashIn, 150.0);
      expect(added.cashOut, 190.0);
      // Original flow should be immutable
      expect(flow.cashIn, 100.0);
      expect(flow.cashOut, 120.0);
    });

    test('combine merges two CashFlow instances', () {
      final flow1 = CashFlow(100.0, 120.0);
      final flow2 = CashFlow(50.0, 80.0);
      final combined = flow1.combine(flow2);

      expect(combined.cashIn, 150.0);
      expect(combined.cashOut, 200.0);
      // Original flows should be unchanged
      expect(flow1.cashIn, 100.0);
      expect(flow2.cashIn, 50.0);
    });
  });

  group('tallyCollectionCashFlow', () {
    test('calculates cashIn and cashOut for PositionCollection against market price', () {
      final now = DateTime.now();
      final collection = PositionCollection(
        symbol: 'BTC',
        positions: [
          Position(
            id: 1,
            symbol: 'BTC',
            units: 2.0,
            price: 1000.0,
            dateTime: now,
          ),
          Position(
            id: 2,
            symbol: 'BTC',
            units: 3.0,
            price: 2000.0,
            dateTime: now,
          ),
        ],
      );

      // cashIn = (2 * 1000) + (3 * 2000) = 2000 + 6000 = 8000
      // cashOut at price 2500 = (2 * 2500) + (3 * 2500) = 5000 + 7500 = 12500
      final cashFlow = tallyCollectionCashFlow(collection, 2500.0);

      expect(cashFlow.cashIn, 8000.0);
      expect(cashFlow.cashOut, 12500.0);
      expect(cashFlow.returnOnInvestment(), 4500.0);
      expect(cashFlow.rateOfReturn(), closeTo(4500.0 / 8000.0, 1e-9));
    });

    test('handles empty PositionCollection', () {
      final emptyCollection = PositionCollection(
        symbol: 'BTC',
        positions: [],
      );

      final cashFlow = tallyCollectionCashFlow(emptyCollection, 50000.0);
      expect(cashFlow.cashIn, 0.0);
      expect(cashFlow.cashOut, 0.0);
    });
  });

  group('tallyPortfolioCashFlow', () {
    test('combines multiple PositionCollection objects with a price map', () {
      final now = DateTime.now();
      final btcCollection = PositionCollection(
        symbol: 'BTC',
        positions: [
          Position(
            id: 1,
            symbol: 'BTC',
            units: 2.0,
            price: 1000.0,
            dateTime: now,
          ),
        ],
      );

      final ethCollection = PositionCollection(
        symbol: 'ETH',
        positions: [
          Position(
            id: 2,
            symbol: 'ETH',
            units: 10.0,
            price: 200.0,
            dateTime: now,
          ),
        ],
      );

      final prices = <String, int>{
        'BTC': 2500,
        'ETH': 300,
      };

      // BTC: cashIn = 2 * 1000 = 2000, cashOut = 2 * 2500 = 5000
      // ETH: cashIn = 10 * 200 = 2000, cashOut = 10 * 300 = 3000
      // Total: cashIn = 4000, cashOut = 8000
      final portfolioFlow = tallyPortfolioCashFlow(
        [btcCollection, ethCollection],
        prices,
      );

      expect(portfolioFlow.cashIn, 4000.0);
      expect(portfolioFlow.cashOut, 8000.0);
      expect(portfolioFlow.returnOnInvestment(), 4000.0);
      expect(portfolioFlow.rateOfReturn(), 1.0);
    });

    test('handles empty portfolio', () {
      final portfolioFlow = tallyPortfolioCashFlow(
        [],
        <String, int>{},
      );

      expect(portfolioFlow.cashIn, 0.0);
      expect(portfolioFlow.cashOut, 0.0);
    });
  });
}
