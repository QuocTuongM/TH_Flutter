import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark    = context.watch<ThemeProvider>().isDark;
    final calc      = context.watch<CalculatorProvider>();
    final accent    = isDark ? AppColors.darkAccent  : AppColors.lightAccent;
    final bgColor   = isDark ? AppColors.darkBg      : AppColors.lightBg;
    final cardBg    = isDark ? AppColors.darkCard    : AppColors.lightCard;
    final textColor = isDark ? AppColors.darkText    : AppColors.lightText;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        title: Text(
          'Cài đặt',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ── Giao diện ─────────────────────────────────
          _sectionHeader('🎨 Giao diện', textColor),
          _settingsCard(
            cardBg: cardBg,
            children: [
              _switchTile(
                icon: Icons.dark_mode,
                title: 'Chế độ tối',
                subtitle: isDark ? 'Đang bật' : 'Đang tắt',
                value: isDark,
                accent: accent,
                textColor: textColor,
                onChanged: (_) =>
                    context.read<ThemeProvider>().toggle(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Tính toán ──────────────────────────────────
          _sectionHeader('🔢 Tính toán', textColor),
          _settingsCard(
            cardBg: cardBg,
            children: [
              // DEG/RAD
              _switchTile(
                icon: Icons.rotate_right,
                title: 'Chế độ góc',
                subtitle: calc.isDeg ? 'Degrees (DEG)' : 'Radians (RAD)',
                value: calc.isDeg,
                accent: accent,
                textColor: textColor,
                onChanged: (_) => calc.toggleDeg(),
              ),
              _divider(isDark),

              // Decimal precision
              _sliderTile(
                icon: Icons.numbers,
                title: 'Độ chính xác thập phân',
                subtitle: '${calc.decimalPrecision} chữ số',
                value: calc.decimalPrecision.toDouble(),
                min: 2,
                max: 10,
                divisions: 8,
                accent: accent,
                textColor: textColor,
                onChanged: (v) =>
                    calc.setDecimalPrecision(v.toInt()),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Lịch sử ───────────────────────────────────
          _sectionHeader('📋 Lịch sử', textColor),
          _settingsCard(
            cardBg: cardBg,
            children: [
              // History size
              _dropdownTile(
                icon: Icons.history,
                title: 'Số lượng lịch sử lưu',
                value: calc.historySize,
                items: const [25, 50, 100],
                accent: accent,
                textColor: textColor,
                cardBg: cardBg,
                onChanged: (v) => calc.setHistorySize(v!),
              ),
              _divider(isDark),

              // Clear history
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.delete_sweep,
                      color: Colors.red, size: 20),
                ),
                title: Text(
                  'Xóa toàn bộ lịch sử',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  '${calc.history.length} mục đang lưu',
                  style: TextStyle(
                      color: textColor.withValues(alpha: 0.5),
                      fontSize: 12),
                ),
                onTap: () => _confirmClearHistory(context, calc, accent),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Thông tin ──────────────────────────────────
          _sectionHeader('ℹ️ Thông tin', textColor),
          _settingsCard(
            cardBg: cardBg,
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.person, color: accent, size: 20),
                ),
                title: Text('Sinh viên',
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.w500)),
                subtitle: Text('Nguyễn Quốc Tường - 2224802010908',
                    style: TextStyle(
                        color: textColor.withValues(alpha: 0.5),
                        fontSize: 12)),
              ),
              _divider(isDark),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.school, color: accent, size: 20),
                ),
                title: Text('Môn học',
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.w500)),
                subtitle: Text(
                    'Phát triển ứng dụng đa nền tảng - ĐH Thủ Dầu Một',
                    style: TextStyle(
                        color: textColor.withValues(alpha: 0.5),
                        fontSize: 12)),
              ),
              _divider(isDark),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.info_outline, color: accent, size: 20),
                ),
                title: Text('Phiên bản',
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.w500)),
                subtitle: Text('Advanced Calculator v1.0.0',
                    style: TextStyle(
                        color: textColor.withValues(alpha: 0.5),
                        fontSize: 12)),
              ),
            ],
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ── Helper widgets ─────────────────────────────────────

  Widget _sectionHeader(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: textColor.withValues(alpha: 0.6),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _settingsCard({
    required Color cardBg,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Color accent,
    required Color textColor,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: accent, size: 20),
      ),
      title: Text(title,
          style: TextStyle(
              color: textColor, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle,
          style: TextStyle(
              color: textColor.withValues(alpha: 0.5), fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: accent,
      ),
    );
  }

  Widget _sliderTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required Color accent,
    required Color textColor,
    required Function(double) onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: accent, size: 20),
      ),
      title: Text(title,
          style: TextStyle(
              color: textColor, fontWeight: FontWeight.w500)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle,
              style: TextStyle(
                  color: textColor.withValues(alpha: 0.5),
                  fontSize: 12)),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: accent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _dropdownTile({
    required IconData icon,
    required String title,
    required int value,
    required List<int> items,
    required Color accent,
    required Color textColor,
    required Color cardBg,
    required Function(int?) onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: accent, size: 20),
      ),
      title: Text(title,
          style: TextStyle(
              color: textColor, fontWeight: FontWeight.w500)),
      trailing: DropdownButton<int>(
        value: value,
        dropdownColor: cardBg,
        underline: const SizedBox(),
        style: TextStyle(color: textColor, fontSize: 14),
        items: items
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text('$e'),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      indent: 56,
      color: isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.08),
    );
  }

  void _confirmClearHistory(
      BuildContext context, CalculatorProvider calc, Color accent) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa lịch sử'),
        content: const Text('Bạn có chắc muốn xóa toàn bộ lịch sử không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              calc.clearHistory();
              Navigator.pop(context);
            },
            child: Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}