import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import '../widgets/calculator_button.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'programmer_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with SingleTickerProviderStateMixin {
  // ✅ Shake animation controller
  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;
  String _prevDisplay = '';

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _triggerShake() {
    _shakeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final calc      = context.watch<CalculatorProvider>();
    final isDark    = context.watch<ThemeProvider>().isDark;
    final accent    = isDark ? AppColors.darkAccent  : AppColors.lightAccent;
    final bgColor   = isDark ? AppColors.darkBg      : AppColors.lightBg;
    final cardBg    = isDark ? AppColors.darkCard    : AppColors.lightCard;
    final btnBg     = isDark ? AppColors.darkBtn     : AppColors.lightBtn;
    final textColor = isDark ? AppColors.darkText    : AppColors.lightText;

    final isProg = calc.mode == CalculatorMode.programmer;
    final isSci  = calc.mode == CalculatorMode.scientific;

    // ✅ Trigger shake khi display = 'Error'
    if (calc.display == 'Error' && _prevDisplay != 'Error') {
      WidgetsBinding.instance.addPostFrameCallback((_) => _triggerShake());
    }
    _prevDisplay = calc.display;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              16, isProg ? 2 : 4, 16, isProg ? 2 : 4),
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _modeBtn(context, 'Basic',
                            CalculatorMode.basic, accent, textColor),
                        _modeBtn(context, 'Sci',
                            CalculatorMode.scientific, accent, textColor),
                        _modeBtn(context, 'Prog',
                            CalculatorMode.programmer, accent, textColor),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isProg)
                        GestureDetector(
                          onTap: () => calc.toggleDeg(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              calc.isDeg ? 'DEG' : 'RAD',
                              style: TextStyle(
                                color: accent,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      IconButton(
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HistoryScreen()),
                        ),
                        icon: Icon(Icons.history, color: accent, size: 20),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SettingsScreen()),
                        ),
                        icon: Icon(Icons.settings, color: accent, size: 20),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(),
                        onPressed: () =>
                            context.read<ThemeProvider>().toggle(),
                        icon: Icon(
                          isDark ? Icons.light_mode : Icons.dark_mode,
                          color: accent,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // ── Programmer mode ───────────────────────────
              if (isProg)
                const Expanded(child: ProgrammerScreen())
              else ...[
                // ── Display với Swipe + Shake ────────────────
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity! > 0) {
                        context
                            .read<CalculatorProvider>()
                            .onButton('CE');
                      }
                    },
                    onVerticalDragEnd: (details) {
                      if (details.primaryVelocity! < 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HistoryScreen()),
                        );
                      }
                    },
                    // ✅ Shake animation bọc quanh display
                    child: AnimatedBuilder(
                      animation: _shakeAnim,
                      builder: (_, child) {
                        final offset = _shakeController.isAnimating
                            ? 8 *
                                (0.5 -
                                    (_shakeAnim.value * 10 % 1).abs())
                            : 0.0;
                        return Transform.translate(
                          offset: Offset(offset, 0),
                          child: child,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          // ✅ Đổi màu nền khi Error
                          color: calc.display == 'Error'
                              ? Colors.red.withValues(alpha: 0.15)
                              : cardBg,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: calc.display == 'Error'
                                  ? Colors.red.withValues(alpha: 0.3)
                                  : Colors.black.withValues(alpha: 0.15),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Hint swipe
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '← swipe to delete',
                                  style: TextStyle(
                                    color:
                                        textColor.withValues(alpha: 0.2),
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  'swipe up for history ↑',
                                  style: TextStyle(
                                    color:
                                        textColor.withValues(alpha: 0.2),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            if (calc.memory != '0')
                              Text(
                                'M: ${calc.memory}',
                                style: TextStyle(
                                    color: accent, fontSize: 11),
                              ),
                            Text(
                              calc.expression.isEmpty
                                  ? ''
                                  : calc.expression,
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
                  ),
                ),

                const SizedBox(height: 4),

                // ── Button grid ──────────────────────────────
                Expanded(
                  flex: isSci ? 7 : 6,
                  child: calc.mode == CalculatorMode.basic
                      ? _basicGrid(context, accent, btnBg, cardBg,
                          textColor, isDark)
                      : _sciGrid(context, accent, btnBg, cardBg,
                          textColor, isDark),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _modeBtn(BuildContext context, String label,
      CalculatorMode m, Color accent, Color textColor) {
    final isActive = context.watch<CalculatorProvider>().mode == m;
    return GestureDetector(
      onTap: () => context.read<CalculatorProvider>().setMode(m),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? accent : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? Colors.white
                : textColor.withValues(alpha: 0.5),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _basicGrid(BuildContext ctx, Color accent, Color btnBg,
      Color cardBg, Color textColor, bool isDark) {
    final rows = [
      ['C', 'CE', '%', '÷'],
      ['7', '8',  '9', '×'],
      ['4', '5',  '6', '-'],
      ['1', '2',  '3', '+'],
      ['±', '0',  '.', '='],
    ];
    return Column(
      children: rows.map((row) => Expanded(
        child: Row(
          children: row.map((b) => Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: _buildBtn(
                  ctx, b, accent, btnBg, cardBg, textColor, isDark),
            ),
          )).toList(),
        ),
      )).toList(),
    );
  }

  Widget _sciGrid(BuildContext ctx, Color accent, Color btnBg,
      Color cardBg, Color textColor, bool isDark) {
    final rows = [
      ['sin', 'cos', 'tan', 'ln',  'log', '÷'],
      ['x²',  '√',  'MC',  'MR',  'M+',  '×'],
      ['(',   ')',   '7',   '8',   '9',   '-'],
      ['M-',  'π',  '4',   '5',   '6',   '+'],
      ['C',   'CE', '1',   '2',   '3',   '%'],
      ['±',   '0',  '.',   'e',   '=',   '='],
    ];
    return Column(
      children: rows.map((row) => Expanded(
        child: Row(
          children: row.map((b) => Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: _buildBtn(ctx, b, accent, btnBg, cardBg, textColor,
                  isDark, sci: true),
            ),
          )).toList(),
        ),
      )).toList(),
    );
  }

  Widget _buildBtn(BuildContext ctx, String label, Color accent,
      Color btnBg, Color cardBg, Color textColor, bool isDark,
      {bool sci = false}) {
    final isEq = label == '=';
    final isOp = ['+', '-', '×', '÷'].contains(label);
    final isFn = [
      'sin', 'cos', 'tan', 'ln', 'log', '√', 'x²', 'π', 'e',
      '(', ')', 'M+', 'M-', 'MR', 'MC', 'C', 'CE', '%', '±'
    ].contains(label);

    Color bg;
    Color fg = textColor;

    if (isEq) {
      bg = accent;
      fg = Colors.white;
    } else if (isOp) {
      bg = isDark
          ? accent.withValues(alpha: 0.2)
          : accent.withValues(alpha: 0.85);
      fg = isDark ? accent : Colors.white;
    } else if (isFn) {
      bg = isDark ? cardBg : const Color(0xFFD1D9E6);
      fg = textColor;
    } else {
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