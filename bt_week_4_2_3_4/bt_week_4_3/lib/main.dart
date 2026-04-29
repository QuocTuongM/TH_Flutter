import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shared Preferences',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const SharedPrefScreen(),
    );
  }
}

class SharedPrefScreen extends StatefulWidget {
  const SharedPrefScreen({super.key});
  @override
  State<SharedPrefScreen> createState() => _SharedPrefScreenState();
}

class _SharedPrefScreenState extends State<SharedPrefScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _displayName = '';
  String _displayAge = '';
  String _displayEmail = '';
  String _displayTime = '';
  bool _hasData = false;

  // ---- Save ----
  Future<void> _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = _nameController.text.trim();
    final age = _ageController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty) {
      _showSnackBar('Vui lòng nhập tên!', Colors.red);
      return;
    }

    final now = DateTime.now();
    final timestamp =
        '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    await prefs.setString('name', name);
    await prefs.setString('age', age);
    await prefs.setString('email', email);
    await prefs.setString('timestamp', timestamp);

    _showSnackBar('Đã lưu thành công!', Colors.teal);
  }

  // ---- Show ----
  Future<void> _showName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name');

    if (name == null || name.isEmpty) {
      setState(() => _hasData = false);
      _showSnackBar('Chưa có dữ liệu nào được lưu!', Colors.orange);
      return;
    }

    setState(() {
      _hasData = true;
      _displayName = prefs.getString('name') ?? '';
      _displayAge = prefs.getString('age') ?? '';
      _displayEmail = prefs.getString('email') ?? '';
      _displayTime = prefs.getString('timestamp') ?? '';
    });
  }

  // ---- Clear ----
  Future<void> _clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _nameController.clear();
    _ageController.clear();
    _emailController.clear();
    setState(() => _hasData = false);
    _showSnackBar('Đã xóa dữ liệu!', Colors.red);
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Preferences'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // ---- Input fields ----
            const Text('Nhập thông tin',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Tên *',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Tuổi (bonus)',
                prefixIcon: const Icon(Icons.cake),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email (bonus)',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),

            // ---- Buttons ----
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveName,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Name'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showName,
                    icon: const Icon(Icons.visibility),
                    label: const Text('Show Name'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ---- Clear button (Bonus) ----
            OutlinedButton.icon(
              onPressed: _clearData,
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              label: const Text('Clear', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 28),

            // ---- Hiển thị kết quả ----
            if (_hasData) ...[
              const Divider(),
              const SizedBox(height: 12),
              const Text('Thông tin đã lưu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _infoCard(Icons.person, 'Tên', _displayName, Colors.teal),
              if (_displayAge.isNotEmpty)
                _infoCard(Icons.cake, 'Tuổi', _displayAge, Colors.orange),
              if (_displayEmail.isNotEmpty)
                _infoCard(Icons.email, 'Email', _displayEmail, Colors.indigo),
              if (_displayTime.isNotEmpty)
                _infoCard(Icons.access_time, 'Lưu lúc', _displayTime, Colors.grey),
            ],

          ],
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 12, color: color, fontWeight: FontWeight.w500)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}