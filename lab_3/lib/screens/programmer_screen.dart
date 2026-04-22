import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';

enum NumberBase { dec, bin, oct, hex }

class ProgrammerScreen extends StatefulWidget {
  const ProgrammerScreen({super.key});

  @override
  State<ProgrammerScreen> createState() => _ProgrammerScreenState();
}

class _ProgrammerScreenState extends State<ProgrammerScreen> {
  String _input = '0';
  NumberBase _base = NumberBase.dec;
  String _operation = '';
  int _num1 = 0;
  bool _shouldReset = false;

  // ── Chuyển đổi số theo base ───────────────────────────
  String _convert(String input, NumberBase from, NumberBase to) {
    try {
      int value;
      switch (from) {
        case NumberBase.dec: value = int.parse(input); break;
        case NumberBase.bin: value = int.parse(input, radix: 2); break;
        case NumberBase.oct: value = int.parse(input, radix: 8); break;
        case NumberBase.hex: value = int.parse(input, radix: 16); break;
      }
      switch (to) {
        case NumberBase.dec: return value.toString();
        case NumberBase.bin: return value.toRadixString(2);
        case NumberBase.oct: return value.toRadixString(8);
        case NumberBase.hex: return value.toRadixString(16).toUpperCase();
      }
    } catch (_) {
      return '0';
    }
  }

  int get _currentValue {
    try {
      switch (_base) {
        case NumberBase.dec: return int.parse(_input);
        case NumberBase.bin: return int.parse(_input, radix: 2);
        case NumberBase.oct: return int.parse(_input, radix: 8);
        case NumberBase.hex: return int.parse(_input, radix: 16);
      }
    } catch (_) {
      return 0;
    }
  }

  String _fromInt(int value) {
    switch (_base) {
      case NumberBase.dec: return value.toString();
      case NumberBase.bin: return value.toRadixString(2);
      case NumberBase.oct: return value.toRadixString(8);
      case NumberBase.hex: return value.toRadixString(16).toUpperCase();
    }
  }

  void _onButton(String label) {
    setState(() {
      if (label == 'C') {
        _input = '0';
        _operation = '';
        _num1 = 0;
        _shouldReset = false;
        return;
      }

      if (label == 'CE') {
        if (_input.length > 1) {
          _input = _input.substring(0, _input.length - 1);
        } else {
          _input = '0';
        }
        return;
      }

      // Bitwise operations
      if (['AND', 'OR', 'XOR', '<<', '>>'].contains(label)) {
        _num1 = _currentValue;
        _operation = label;
        _shouldReset = true;
        return;
      }

      if (label == 'NOT') {
        _input = _fromInt(~_currentValue);
        return;
      }

      if (label == '=') {
        if (_operation.isEmpty) return;
        final num2 = _currentValue;
        int result = 0;
        switch (_operation) {
          case 'AND': result = _num1 & num2; break;
          case 'OR':  result = _num1 | num2; break;
          case 'XOR': result = _num1 ^ num2; break;
          case '<<':  result = _num1 << num2; break;
          case '>>':  result = _num1 >> num2; break;
        }
        _input = _fromInt(result);
        _operation = '';
        _shouldReset = true;
        return;
      }

      // Nhập số
      if (_shouldReset || _input == '0') {
        _input = label;
        _shouldReset = false;
      } else {
        if (_input.length < 16) _input += label;
      }
    });
  }

  void _changeBase(NumberBase newBase) {
    setState(() {
      final val = _currentValue;
      _base = newBase;
      _input = _fromInt(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark    = context.watch<ThemeProvider>().isDark;
    final accent    = isDark ? AppColors.darkAccent  : AppColors.lightAccent;
    final bgColor   = isDark ? AppColors.darkBg      : AppColors.lightBg;
    final cardBg    = isDark ? AppColors.darkCard    : AppColors.lightCard;
    final btnBg     = isDark ? AppColors.darkBtn     : AppColors.lightBtn;
    final textColor = isDark ? AppColors.darkText    : AppColors.lightText;

    return Column(
      children: [
        // ── Display ─────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Hiển thị giá trị ở tất cả các base
              _baseRow('HEX', _convert(_input, _base, NumberBase.hex),
                  accent, textColor),
              _baseRow('DEC', _convert(_input, _base, NumberBase.dec),
                  accent, textColor),
              _baseRow('OCT', _convert(_input, _base, NumberBase.oct),
                  accent, textColor),
              _baseRow('BIN', _convert(_input, _base, NumberBase.bin),
                  accent, textColor),
              const SizedBox(height: 8),
              // Main display
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  _input,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 40,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              if (_operation.isNotEmpty)
                Text(
                  'Op: $_operation',
                  style: TextStyle(
                      color: accent, fontSize: 12),
                ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // ── Base selector ────────────────────────────────
        Row(
          children: NumberBase.values.map((b) {
            final labels = {
              NumberBase.dec: 'DEC',
              NumberBase.bin: 'BIN',
              NumberBase.oct: 'OCT',
              NumberBase.hex: 'HEX',
            };
            final isActive = _base == b;
            return Expanded(
              child: GestureDetector(
                onTap: () => _changeBase(b),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? accent : cardBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      labels[b]!,
                      style: TextStyle(
                        color: isActive ? Colors.white : textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 4),

        // ── Button grid ──────────────────────────────────
        Expanded(
          child: Column(
            children: [
              // Hàng bitwise
              Expanded(
                child: Row(
                  children: ['AND', 'OR', 'XOR', 'NOT']
                      .map((b) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: _buildBtn(b, accent, cardBg,
                                  textColor, isDark, isFn: true),
                            ),
                          ))
                      .toList(),
                ),
              ),
              // Hàng shift + C CE
              Expanded(
                child: Row(
                  children: ['<<', '>>', 'C', 'CE']
                      .map((b) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: _buildBtn(b, accent, cardBg,
                                  textColor, isDark, isFn: true),
                            ),
                          ))
                      .toList(),
                ),
              ),
              // Hex buttons A-F
              if (_base == NumberBase.hex)
                Expanded(
                  child: Row(
                    children: ['A', 'B', 'C', 'D', 'E', 'F']
                        .map((b) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: _buildBtn(b, accent, btnBg,
                                    textColor, isDark),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              // Số 7 8 9
              Expanded(
                child: Row(
                  children: [
                    '7', '8', '9',
                    _base == NumberBase.hex ? '÷' : '÷'
                  ].map((b) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: _buildBtn(b, accent, btnBg,
                              textColor, isDark,
                              isOp: b == '÷'),
                        ),
                      )).toList(),
                ),
              ),
              // Số 4 5 6
              Expanded(
                child: Row(
                  children: ['4', '5', '6', '×']
                      .map((b) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: _buildBtn(b, accent, btnBg,
                                  textColor, isDark,
                                  isOp: b == '×'),
                            ),
                          ))
                      .toList(),
                ),
              ),
              // Số 1 2 3
              Expanded(
                child: Row(
                  children: ['1', '2', '3', '-']
                      .map((b) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: _buildBtn(b, accent, btnBg,
                                  textColor, isDark,
                                  isOp: b == '-'),
                            ),
                          ))
                      .toList(),
                ),
              ),
              // 0 và =
              Expanded(
                child: Row(
                  children: ['0', '=']
                      .map((b) => Expanded(
                            flex: b == '0' ? 3 : 1,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: _buildBtn(b, accent, btnBg,
                                  textColor, isDark,
                                  isEq: b == '='),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _baseRow(
      String label, String value, Color accent, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: accent,
                fontSize: 11,
                fontWeight: FontWeight.bold)),
        Text(
          value.isEmpty ? '0' : value,
          style: TextStyle(
              color: textColor.withValues(alpha: 0.5), fontSize: 12),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildBtn(
    String label,
    Color accent,
    Color btnBg,
    Color textColor,
    bool isDark, {
    bool isFn = false,
    bool isOp = false,
    bool isEq = false,
  }) {
    // Disable buttons không hợp lệ với base hiện tại
    bool disabled = false;
    if (_base == NumberBase.bin &&
        !['0', '1', 'AND', 'OR', 'XOR', 'NOT', '<<', '>>', 'C', 'CE', '=']
            .contains(label)) {
      disabled = true;
    }
    if (_base == NumberBase.oct &&
        ['8', '9', 'A', 'B', 'C', 'D', 'E', 'F'].contains(label)) {
      disabled = true;
    }

    Color bg;
    Color fg = disabled
        ? textColor.withValues(alpha: 0.2)
        : textColor;

    if (isEq)       { bg = accent; fg = Colors.white; }
    else if (isOp)  { bg = isDark ? accent.withValues(alpha: 0.2) : accent.withValues(alpha: 0.85); fg = isDark ? accent : Colors.white; }
    else if (isFn)  { bg = isDark ? AppColors.darkCard : const Color(0xFFD1D9E6); }
    else            { bg = disabled ? btnBg.withValues(alpha: 0.3) : btnBg; }

    return GestureDetector(
      onTap: disabled ? null : () => _onButton(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: disabled ? [] : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isEq ? Colors.white : fg,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}