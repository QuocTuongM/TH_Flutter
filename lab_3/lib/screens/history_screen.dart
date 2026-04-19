import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calc   = context.watch<CalculatorProvider>();
    final isDark = context.watch<ThemeProvider>().isDark;
    final accent = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        title: Text(
          'Lịch sử tính toán',
          style: TextStyle(color: textColor),
        ),
        iconTheme: IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep, color: accent),
            onPressed: () {
              calc.clearHistory();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: calc.history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64,
                      color: textColor.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text(
                    'Chưa có lịch sử nào',
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.5),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: calc.history.length,
              itemBuilder: (_, i) {
                final h = calc.history[i];
                return Card(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    title: Text(
                      h.expression,
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      '= ${h.result}',
                      style: TextStyle(
                        color: accent,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      '${h.timestamp.hour}:'
                      '${h.timestamp.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withValues(alpha: 0.4),
                      ),
                    ),
                    onTap: () {
                      calc.useHistory(h);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
    );
  }
}