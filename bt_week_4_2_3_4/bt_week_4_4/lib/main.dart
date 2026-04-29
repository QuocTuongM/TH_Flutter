import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Async Programming',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AsyncScreen(),
    );
  }
}

class AsyncScreen extends StatefulWidget {
  const AsyncScreen({super.key});
  @override
  State<AsyncScreen> createState() => _AsyncScreenState();
}

class _AsyncScreenState extends State<AsyncScreen> {
  String _status = 'Nhấn nút để bắt đầu';
  bool _isLoading = false;
  bool _isDone = false;

  // Hàm async giả lập load user (đợi 3 giây)
  Future<String> _fetchUser() async {
    await Future.delayed(const Duration(seconds: 3));
    return 'User loaded successfully!';
  }

  Future<void> _loadUser() async {
    // Nếu đang loading thì không làm gì
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _isDone = false;
      _status = 'Loading user...';
    });

    // Gọi hàm async, đợi kết quả
    final result = await _fetchUser();

    setState(() {
      _isLoading = false;
      _isDone = true;
      _status = result;
    });
  }

  void _reset() {
    setState(() {
      _status = 'Nhấn nút để bắt đầu';
      _isLoading = false;
      _isDone = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Async Programming'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Icon trạng thái
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        key: ValueKey('loading'),
                        strokeWidth: 3,
                      )
                    : Icon(
                        key: ValueKey(_isDone ? 'done' : 'idle'),
                        _isDone ? Icons.check_circle : Icons.cloud_download,
                        size: 80,
                        color: _isDone ? Colors.green : Colors.grey,
                      ),
              ),

              const SizedBox(height: 32),

              // Text trạng thái
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _status,
                  key: ValueKey(_status),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: _isDone ? Colors.green : Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Hiện đếm ngược khi đang loading
              if (_isLoading)
                const _CountdownWidget(),

              const SizedBox(height: 40),

              // Nút Load User
              if (!_isLoading && !_isDone)
                ElevatedButton.icon(
                  onPressed: _loadUser,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Load User'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),

              // Nút Reset
              if (_isDone)
                ElevatedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Thử lại'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget đếm ngược 3 giây
class _CountdownWidget extends StatefulWidget {
  const _CountdownWidget();
  @override
  State<_CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<_CountdownWidget> {
  int _seconds = 3;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() async {
    for (int i = 3; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() => _seconds = i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Còn $_seconds giây...',
      style: const TextStyle(fontSize: 16, color: Colors.grey),
    );
  }
}