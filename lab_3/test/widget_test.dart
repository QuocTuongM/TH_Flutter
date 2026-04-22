import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lab_3/providers/calculator_provider.dart';

void main() {
  // ✅ Khởi tạo binding và mock SharedPreferences trước khi test
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  late CalculatorProvider calc;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    calc = CalculatorProvider();
  });

  // ── Basic Operations ──────────────────────────────────
  group('Basic Operations', () {
    test('Addition: 5 + 3 = 8', () {
      calc.onButton('5');
      calc.onButton('+');
      calc.onButton('3');
      calc.onButton('=');
      expect(calc.display, '8');
    });

    test('Subtraction: 10 - 4 = 6', () {
      calc.onButton('1');
      calc.onButton('0');
      calc.onButton('-');
      calc.onButton('4');
      calc.onButton('=');
      expect(calc.display, '6');
    });

    test('Multiplication: 6 × 7 = 42', () {
      calc.onButton('6');
      calc.onButton('×');
      calc.onButton('7');
      calc.onButton('=');
      expect(calc.display, '42');
    });

    test('Division: 15 ÷ 3 = 5', () {
      calc.onButton('1');
      calc.onButton('5');
      calc.onButton('÷');
      calc.onButton('3');
      calc.onButton('=');
      expect(calc.display, '5');
    });

    test('Division by zero = Error', () {
      calc.onButton('5');
      calc.onButton('÷');
      calc.onButton('0');
      calc.onButton('=');
      expect(calc.display, 'Error');
    });
  });

  // ── Clear Operations ──────────────────────────────────
  group('Clear Operations', () {
    test('C clears display', () {
      calc.onButton('5');
      calc.onButton('C');
      expect(calc.display, '0');
    });

    test('CE removes last character', () {
      calc.onButton('1');
      calc.onButton('2');
      calc.onButton('3');
      calc.onButton('CE');
      expect(calc.display, '12');
    });
  });

  // ── Memory Operations ─────────────────────────────────
  group('Memory Operations', () {
    test('M+ stores value', () {
      calc.onButton('5');
      calc.onButton('M+');
      expect(calc.memory, '5.0');
    });

    test('M+ adds to memory: 5 M+ 3 M+ MR = 8', () {
      calc.onButton('5');
      calc.onButton('M+');
      calc.onButton('C');
      calc.onButton('3');
      calc.onButton('M+');
      calc.onButton('MR');
      expect(calc.display, '8.0');
    });

    test('M- subtracts from memory', () {
      calc.onButton('1');
      calc.onButton('0');
      calc.onButton('M+');
      calc.onButton('C');
      calc.onButton('3');
      calc.onButton('M-');
      calc.onButton('MR');
      expect(calc.display, '7.0');
    });

    test('MC clears memory', () {
      calc.onButton('5');
      calc.onButton('M+');
      calc.onButton('MC');
      expect(calc.memory, '0');
    });
  });

  // ── Scientific Operations ─────────────────────────────
  group('Scientific Operations', () {
    test('Toggle DEG/RAD', () {
      expect(calc.isDeg, true);
      calc.toggleDeg();
      expect(calc.isDeg, false);
      calc.toggleDeg();
      expect(calc.isDeg, true);
    });

    test('Decimal precision setting', () {
      calc.setDecimalPrecision(4);
      expect(calc.decimalPrecision, 4);
    });
  });

  // ── History ───────────────────────────────────────────
  group('History', () {
    test('Calculation saved to history', () {
      calc.onButton('5');
      calc.onButton('+');
      calc.onButton('3');
      calc.onButton('=');
      expect(calc.history.isNotEmpty, true);
      expect(calc.history.first.result, '8');
    });

    test('History size limit respected', () {
      calc.setHistorySize(3);
      for (int i = 0; i < 5; i++) {
        calc.onButton('1');
        calc.onButton('+');
        calc.onButton('1');
        calc.onButton('=');
      }
      expect(calc.history.length, lessThanOrEqualTo(3));
    });
  });

  // ── Calculator Mode ───────────────────────────────────
  group('Calculator Mode', () {
    test('Default mode is basic', () {
      expect(calc.mode, CalculatorMode.basic);
    });

    test('Switch to scientific mode', () {
      calc.setMode(CalculatorMode.scientific);
      expect(calc.mode, CalculatorMode.scientific);
    });
  });

  // ── Complex Expressions ───────────────────────────────
  group('Complex Expressions', () {
    test('Parentheses: (2+3)×4 = 20', () {
      calc.onButton('(');
      calc.onButton('2');
      calc.onButton('+');
      calc.onButton('3');
      calc.onButton(')');
      calc.onButton('×');
      calc.onButton('4');
      calc.onButton('=');
      expect(calc.display, '20');
    });

    test('Negative number with ±', () {
      calc.onButton('5');
      calc.onButton('±');
      expect(calc.display, '-5');
    });
  });
}