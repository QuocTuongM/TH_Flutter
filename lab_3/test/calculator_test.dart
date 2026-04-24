import 'package:flutter_test/flutter_test.dart';
import 'package:lab_3/utils/calculator_logic.dart';

void main() {

  group('Basic Calculations', () {
    test('5 + 3 = 8', () {
      expect(CalculatorLogic.evaluate('5+3', true), 8);
    });

    test('10 - 4 = 6', () {
      expect(CalculatorLogic.evaluate('10-4', true), 6);
    });

    test('6 × 2 = 12', () {
      expect(CalculatorLogic.evaluate('6×2', true), 12);
    });

    test('8 ÷ 2 = 4', () {
      expect(CalculatorLogic.evaluate('8÷2', true), 4);
    });
  });

  group('Parentheses & Order', () {
    test('(5 + 3) × 2 = 16', () {
      expect(CalculatorLogic.evaluate('(5+3)×2', true), 16);
    });

    test('((2 + 3) × (4 - 1)) ÷ 5 = 3', () {
      expect(CalculatorLogic.evaluate('((2+3)×(4-1))÷5', true), 3);
    });
  });

  group('Scientific Functions', () {
    test('sin(45) + cos(45) ≈ 1.41', () {
      final result = CalculatorLogic.evaluate('sin(45)+cos(45)', true);
      expect(result.toStringAsFixed(2), '1.41');
    });

    test('log(100) = 2', () {
      final result = CalculatorLogic.evaluate('log(100)', true);
      expect(result.toStringAsFixed(0), '2');
    });
  });

  group('Constants & Special', () {
    test('2π ≈ 6.28', () {
      final result = CalculatorLogic.evaluate('2π', true);
      expect(result.toStringAsFixed(2), '6.28');
    });

    test('√9 = 3', () {
      final result = CalculatorLogic.evaluate('√9', true);
      expect(result, 3);
    });

    test('5! = 120', () {
      final result = CalculatorLogic.evaluate('5!', true);
      expect(result, 120);
    });
  });

  group('Error Handling', () {
    test('Invalid expression returns error', () {
      expect(() => CalculatorLogic.evaluate('5++', true), throwsException);
    });

    test('Divide by zero', () {
      expect(() => CalculatorLogic.evaluate('1/0', true), throwsException);
    });
  });
}