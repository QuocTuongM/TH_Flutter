import 'package:math_expressions/math_expressions.dart';

class CalculatorLogic {
  static double evaluate(String expression, bool isDeg) {
    try {
      String expr = expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('π', 'pi');

      // ✅ FIX √9 → sqrt(9)
      expr = expr.replaceAllMapped(
        RegExp(r'√(\d+)'),
        (m) => 'sqrt(${m[1]})',
      );

      // ✅ FIX log10: log(x) = ln(x)/ln(10)
      expr = expr.replaceAllMapped(
        RegExp(r'log\(([^)]+)\)'),
        (m) => 'ln(${m[1]})/ln(10)',
      );

      // ✅ Factorial: 5! → 120
      expr = expr.replaceAllMapped(
        RegExp(r'(\d+)!'),
        (m) => _factorial(int.parse(m[1]!)).toString(),
      );

      // ✅ Implicit multiplication
      expr = expr
          .replaceAllMapped(
            RegExp(r'(\d)(pi|\()'),
            (m) => '${m[1]}*${m[2]}',
          )
          .replaceAllMapped(
            RegExp(r'(pi|\))(\d)'),
            (m) => '${m[1]}*${m[2]}',
          );

      // ✅ DEG mode
      if (isDeg) {
        expr = expr
            .replaceAll('sin(', 'sin(pi/180*')
            .replaceAll('cos(', 'cos(pi/180*')
            .replaceAll('tan(', 'tan(pi/180*');
      }

      final parser = GrammarParser();
      final exp = parser.parse(expr);
      final result = exp.evaluate(EvaluationType.REAL, ContextModel());

      // ✅ Fix lỗi toán học
      if (result.isNaN || result.isInfinite) {
        throw Exception("Math Error");
      }

      return result;
    } catch (e) {
      throw Exception("Invalid Expression");
    }
  }

  // ✅ Factorial
  static int _factorial(int n) {
    if (n < 0) throw Exception("Invalid factorial");
    if (n <= 1) return 1;
    return n * _factorial(n - 1);
  }
}