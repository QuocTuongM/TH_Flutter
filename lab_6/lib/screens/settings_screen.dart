import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/audio_provider.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final audioProvider = context.watch<AudioProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Cài đặt',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _sectionHeader('🎨 Giao diện'),
                  _settingsCard([
                    SwitchListTile(
                      title: const Text('Chế độ tối',
                          style: TextStyle(
                              color: AppColors.white)),
                      value: themeProvider.isDark,
                      onChanged: (_) =>
                          themeProvider.toggle(),
                      activeColor: AppColors.primary,
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _sectionHeader('🔊 Âm thanh'),
                  _settingsCard([
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Âm lượng: ${(audioProvider.volume * 100).toInt()}%',
                            style: const TextStyle(
                                color: AppColors.white),
                          ),
                          Slider(
                            value: audioProvider.volume,
                            onChanged: (v) =>
                                audioProvider.setVolume(v),
                            activeColor: AppColors.primary,
                            inactiveColor: AppColors.darkGrey,
                          ),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _sectionHeader('ℹ️ Thông tin'),
                  _settingsCard([
                    _infoTile(Icons.person, 'Sinh viên',
                        'Nguyễn Quốc Tường'),
                    _infoTile(Icons.badge, 'MSSV',
                        '2224802010908'),
                    _infoTile(Icons.school, 'Trường',
                        'Đại học Thủ Dầu Một'),
                    _infoTile(Icons.music_note, 'Phiên bản',
                        'Music Player v1.0.0'),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.grey,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _settingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 20),
      title: Text(label,
          style: const TextStyle(
              color: AppColors.grey, fontSize: 12)),
      trailing: Text(value,
          style: const TextStyle(
              color: AppColors.white, fontSize: 13)),
      dense: true,
    );
  }
}