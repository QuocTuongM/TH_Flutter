import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final StorageService _storage = StorageService();
  String _tempUnit    = 'celsius';
  String _windUnit    = 'kmh';
  String _timeFormat  = '24h';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final tempUnit   = await _storage.getTempUnit();
    final windUnit   = await _storage.getWindUnit();
    final timeFormat = await _storage.getTimeFormat();
    setState(() {
      _tempUnit   = tempUnit;
      _windUnit   = windUnit;
      _timeFormat = timeFormat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF87CEEB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // Temperature unit
                    _sectionHeader('🌡️ Temperature Unit'),
                    _settingsCard(
                      children: [
                        _radioTile(
                          title: 'Celsius (°C)',
                          value: 'celsius',
                          groupValue: _tempUnit,
                          onChanged: (v) async {
                            setState(() => _tempUnit = v!);
                            await _storage.saveTempUnit(v!);
                          },
                        ),
                        _divider(),
                        _radioTile(
                          title: 'Fahrenheit (°F)',
                          value: 'fahrenheit',
                          groupValue: _tempUnit,
                          onChanged: (v) async {
                            setState(() => _tempUnit = v!);
                            await _storage.saveTempUnit(v!);
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Wind speed unit 
                    _sectionHeader('💨 Wind Speed Unit'),
                    _settingsCard(
                      children: [
                        _radioTile(
                          title: 'Kilometers per hour (km/h)',
                          value: 'kmh',
                          groupValue: _windUnit,
                          onChanged: (v) async {
                            setState(() => _windUnit = v!);
                            await _storage.saveWindUnit(v!);
                          },
                        ),
                        _divider(),
                        _radioTile(
                          title: 'Meters per second (m/s)',
                          value: 'ms',
                          groupValue: _windUnit,
                          onChanged: (v) async {
                            setState(() => _windUnit = v!);
                            await _storage.saveWindUnit(v!);
                          },
                        ),
                        _divider(),
                        _radioTile(
                          title: 'Miles per hour (mph)',
                          value: 'mph',
                          groupValue: _windUnit,
                          onChanged: (v) async {
                            setState(() => _windUnit = v!);
                            await _storage.saveWindUnit(v!);
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    //Time format
                    _sectionHeader('🕐 Time Format'),
                    _settingsCard(
                      children: [
                        _radioTile(
                          title: '24-hour format (14:00)',
                          value: '24h',
                          groupValue: _timeFormat,
                          onChanged: (v) async {
                            setState(() => _timeFormat = v!);
                            await _storage.saveTimeFormat(v!);
                          },
                        ),
                        _divider(),
                        _radioTile(
                          title: '12-hour format (2:00 PM)',
                          value: '12h',
                          groupValue: _timeFormat,
                          onChanged: (v) async {
                            setState(() => _timeFormat = v!);
                            await _storage.saveTimeFormat(v!);
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // About 
                    _sectionHeader('ℹ️ About'),
                    _settingsCard(
                      children: [
                        _infoTile(
                            Icons.person, 'Developer',
                            'Nguyễn Quốc Tường'),
                        _divider(),
                        _infoTile(
                            Icons.badge, 'Student ID',
                            '2224802010908'),
                        _divider(),
                        _infoTile(
                            Icons.school, 'University',
                            'Đại học Thủ Dầu Một'),
                        _divider(),
                        _infoTile(
                            Icons.cloud, 'API',
                            'OpenWeatherMap'),
                        _divider(),
                        _infoTile(
                            Icons.info, 'Version',
                            'Weather App v1.0.0'),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _settingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(children: children),
    );
  }

  Widget _radioTile({
    required String title,
    required String value,
    required String groupValue,
    required Function(String?) onChanged,
  }) {
    return RadioListTile<String>(
      title: Text(title,
          style: const TextStyle(color: Colors.white, fontSize: 14)),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: Colors.white,
      dense: true,
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon,
          color: Colors.white.withValues(alpha: 0.8), size: 20),
      title: Text(label,
          style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12)),
      trailing: Text(value,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500)),
      dense: true,
    );
  }

  Widget _divider() => Divider(
        height: 1,
        color: Colors.white.withValues(alpha: 0.15),
        indent: 16,
      );
}