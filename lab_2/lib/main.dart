import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0'; // Số đang hiển thị to ở màn hình
  String _equation = ''; // Phép tính phía trước
  double _num1 = 0; // Số thứ nhất
  double _num2 = 0; // Số thứ hai
  String _operation = ''; // Phép tính đang chọn
  bool _shouldResetDisplay = false; // Khi true → lần nhấn số tiếp theo sẽ xóa màn hình

  // ── Colors (sáng hơn) ─────────────────────────────────────
  static const Color bgPage     = Color(0xFF3D4660);   // nền tổng sáng hơn
  static const Color displayBg  = Color(0xFF2D3655);   // Vùng hiển thị số
  static const Color btnNum     = Color(0xFF4A5568);   // nút số
  static const Color btnFn      = Color(0xFF5A6A8A);   // C CE % ±
  static const Color btnOp      = Color(0xFF6B7FBD);   // + - × ÷ (xanh nổi)
  static const Color btnEq      = Color(0xFFEF8354);   // = cam
  static const Color textLight  = Color(0xFFFFFFFF);
  static const Color textDim    = Color(0xFFB0BEC5);

  void _onButton(String value) {
    setState(() {
      if (value == 'C') {
        _display = '0';
        _equation = '';
        _num1 = 0;
        _num2 = 0;
        _operation = '';
        _shouldResetDisplay = false;
      } else if (value == 'CE') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
        }
      } else if (value == '±') {
        if (_display != '0') {
          _display = _display.startsWith('-')
              ? _display.substring(1)
              : '-$_display';
        }
      } else if (value == '%') {
        double val = double.tryParse(_display) ?? 0;
        _display = _formatResult(val / 100);
      } else if (value == '.') {
        if (_shouldResetDisplay) {
          _display = '0.';
          _shouldResetDisplay = false;
        } else if (!_display.contains('.')) {
          _display += '.';
        }
      } else if (['+', '-', '×', '÷'].contains(value)) {
        _num1 = double.tryParse(_display) ?? 0;
        _operation = value;
        _equation = '$_display $value';
        _shouldResetDisplay = true;
      } else if (value == '=') {
        if (_operation.isEmpty) return;
        _num2 = double.tryParse(_display) ?? 0;
        _equation = '$_equation $_display =';
        double result = 0;
        switch (_operation) {
          case '+': result = _num1 + _num2; break;
          case '-': result = _num1 - _num2; break;
          case '×': result = _num1 * _num2; break;
          case '÷':
            if (_num2 == 0) {
              _display = 'Error';
              _equation = '';
              _operation = '';
              _shouldResetDisplay = true;
              return;
            }
            result = _num1 / _num2;
            break;
        }
        _display = _formatResult(result);
        _operation = '';
        _shouldResetDisplay = true;
      } else {
        if (_shouldResetDisplay || _display == '0') {
          _display = value;
          _shouldResetDisplay = false;
        } else {
          if (_display.length < 12) _display += value;
        }
      }
    });
  }

  String _formatResult(double value) {
    if (value.isInfinite || value.isNaN) return 'Error';
    if (value == value.truncateToDouble()) return value.toInt().toString();
    return double.parse(value.toStringAsFixed(10))
        .toString()
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPage,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            children: [
              // ── Display ───────────────────────────────────
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                  decoration: BoxDecoration(
                    color: displayBg,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.05),
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Equation
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          _equation,
                          key: ValueKey(_equation),
                          style: TextStyle(
                            color: textDim,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Main display
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          transitionBuilder: (child, anim) =>
                              FadeTransition(opacity: anim, child: child),
                          child: Text(
                            _display,
                            key: ValueKey(_display),
                            style: TextStyle(
                              color: _display == 'Error'
                                  ? btnEq
                                  : textLight,
                              fontSize: 64,
                              fontWeight: FontWeight.w300,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Buttons ───────────────────────────────────
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    _buildRow(['C', 'CE', '%', '÷']),
                    _buildRow(['7', '8', '9', '×']),
                    _buildRow(['4', '5', '6', '-']),
                    _buildRow(['1', '2', '3', '+']),
                    _buildRow(['±', '0', '.', '=']),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<String> buttons) {
    return Expanded(
      child: Row(
        children: buttons.map((btn) => Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: _buildButton(btn),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildButton(String label) {
    Color bg;
    Color fg = textLight;
    double fontSize = 22;

    if (label == '=') {
      bg = btnEq;
      fontSize = 28;
    } else if (['+', '-', '×', '÷'].contains(label)) {
      bg = btnOp;
      fontSize = 26;
    } else if (['C', 'CE', '%', '±'].contains(label)) {
      bg = btnFn;
    } else {
      bg = btnNum;
    }

    // Highlight nút đang active
    final bool isActiveOp = _operation == label;

    return GestureDetector(
      onTap: () => _onButton(label),
      child: Container(
        decoration: BoxDecoration(
          color: isActiveOp ? btnEq : bg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
            // Viền sáng phía trên cho chiều sâu
            BoxShadow(
              color: Colors.white.withOpacity(0.08),
              blurRadius: 1,
              offset: const Offset(0, -1),
            ),
            if (label == '=')
              BoxShadow(
                color: btnEq.withOpacity(0.5),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            if (['+', '-', '×', '÷'].contains(label))
              BoxShadow(
                color: btnOp.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: fontSize,
              fontWeight: label == '='
                  ? FontWeight.bold
                  : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}