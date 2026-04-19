import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import '../widgets/calculator_button.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calc = context.watch<CalculatorProvider>();
    final isDark = context.watch<ThemeProvider>().isDark;
    final accent = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final btnBg = isDark ? AppColors.darkBtn : AppColors.lightBtn;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Column(
            children: [
              // ── Top bar ──────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _modeBtn(
                          context,
                          'Basic',
                          CalculatorMode.basic,
                          accent,
                          textColor,
                        ),
                        _modeBtn(
                          context,
                          'Scientific',
                          CalculatorMode.scientific,
                          accent,
                          textColor,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => calc.toggleDeg(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            calc.isDeg ? 'DEG' : 'RAD',
                            style: TextStyle(
                              color: accent,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HistoryScreen(),
                          ),
                        ),
                        icon: Icon(Icons.history, color: accent, size: 22),
                      ),
                      const SizedBox(width: 2),
                      // nút Settings
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        ),
                        icon: Icon(Icons.settings, color: accent, size: 22),
                      ),
                      const SizedBox(width: 2),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => context.read<ThemeProvider>().toggle(),
                        icon: Icon(
                          isDark ? Icons.light_mode : Icons.dark_mode,
                          color: accent,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // ── Display ───────────────────────────────────
              Expanded(
                flex: 3,
                child: Container(
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (calc.memory != '0')
                        Text(
                          'M: ${calc.memory}',
                          style: TextStyle(color: accent, fontSize: 11),
                        ),
                      Text(
                        calc.expression.isEmpty ? '' : calc.expression,
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.4),
                          fontSize: 15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 6),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          calc.display,
                          style: TextStyle(
                            color: calc.display == 'Error'
                                ? Colors.red
                                : textColor,
                            fontSize: 52,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // ── Button grid ───────────────────────────────
              Expanded(
                flex: calc.mode == CalculatorMode.scientific ? 7 : 6,
                child: calc.mode == CalculatorMode.basic
                    ? _basicGrid(
                        context,
                        accent,
                        btnBg,
                        cardBg,
                        textColor,
                        isDark,
                      )
                    : _sciGrid(
                        context,
                        accent,
                        btnBg,
                        cardBg,
                        textColor,
                        isDark,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modeBtn(
    BuildContext context,
    String label,
    CalculatorMode m,
    Color accent,
    Color textColor,
  ) {
    final isActive = context.watch<CalculatorProvider>().mode == m;
    return GestureDetector(
      onTap: () => context.read<CalculatorProvider>().setMode(m),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? accent : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : textColor.withValues(alpha: 0.5),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _basicGrid(
    BuildContext ctx,
    Color accent,
    Color btnBg,
    Color cardBg,
    Color textColor,
    bool isDark,
  ) {
    final rows = [
      ['C', 'CE', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['±', '0', '.', '='],
    ];
    return Column(
      children: rows
          .map(
            (row) => Expanded(
              child: Row(
                children: row
                    .map(
                      (b) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: _buildBtn(
                            ctx,
                            b,
                            accent,
                            btnBg,
                            cardBg,
                            textColor,
                            isDark,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _sciGrid(
    BuildContext ctx,
    Color accent,
    Color btnBg,
    Color cardBg,
    Color textColor,
    bool isDark,
  ) {
    final rows = [
      ['sin', 'cos', 'tan', 'ln', 'log', '÷'],
      ['x²', '√', 'MC', 'MR', 'M+', '×'],
      ['(', ')', '7', '8', '9', '-'],
      ['M-', 'π', '4', '5', '6', '+'],
      ['C', 'CE', '1', '2', '3', '%'],
      ['±', '0', '.', 'e', '=', '='],
    ];
    return Column(
      children: rows
          .map(
            (row) => Expanded(
              child: Row(
                children: row
                    .map(
                      (b) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: _buildBtn(
                            ctx,
                            b,
                            accent,
                            btnBg,
                            cardBg,
                            textColor,
                            isDark,
                            sci: true,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildBtn(
    BuildContext ctx,
    String label,
    Color accent,
    Color btnBg,
    Color cardBg,
    Color textColor,
    bool isDark, {
    bool sci = false,
  }) {
    final isEq = label == '=';
    final isOp = ['+', '-', '×', '÷'].contains(label);
    final isFn = [
      'sin',
      'cos',
      'tan',
      'ln',
      'log',
      '√',
      'x²',
      'π',
      'e',
      '(',
      ')',
      'M+',
      'M-',
      'MR',
      'MC',
      'C',
      'CE',
      '%',
      '±',
    ].contains(label);

    Color bg;
    Color fg = textColor;

    if (isEq) {
      // ✅ Nút = luôn cam nổi bật cả 2 mode
      bg = accent;
      fg = Colors.white;
    } else if (isOp) {
      // ✅ Light mode: nền cam đậm hơn, chữ trắng cho dễ nhìn
      bg = isDark
          ? accent.withValues(alpha: 0.2)
          : accent.withValues(alpha: 0.85);
      fg = isDark ? accent : Colors.white;
    } else if (isFn) {
      // ✅ Light mode: nút function xám nhạt
      bg = isDark ? cardBg : const Color(0xFFD1D9E6);
      fg = textColor;
    } else {
      // Nút số
      bg = btnBg;
      fg = textColor;
    }

    return CalculatorButton(
      label: label,
      bgColor: bg,
      textColor: fg,
      fontSize: sci ? 13 : (isEq ? 26 : 20),
      onTap: () => ctx.read<CalculatorProvider>().onButton(label),
    );
  }
}
