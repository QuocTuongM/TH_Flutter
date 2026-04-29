import 'dart:isolate';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isolate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const IsolateScreen(),
    );
  }
}

class IsolateScreen extends StatefulWidget {
  const IsolateScreen({super.key});
  @override
  State<IsolateScreen> createState() => _IsolateScreenState();
}

class _IsolateScreenState extends State<IsolateScreen> {
  // ---- Challenge 1 ----
  final TextEditingController _numberController =
      TextEditingController(text: '30000');
  bool _c1Loading = false;
  String _c1Result = '';

  // ---- Challenge 2 ----
  bool _c2Running = false;
  int _c2Sum = 0;
  final List<String> _c2Log = [];
  Isolate? _workerIsolate;
  ReceivePort? _receivePort;
  SendPort? _workerSendPort;

  // ======================
  // CHALLENGE 1
  // ======================
  static BigInt _computeFactorial(int n) {
    BigInt result = BigInt.one;
    for (int i = 2; i <= n; i++) {
      result *= BigInt.from(i);
    }
    return result;
  }

  Future<void> _startChallenge1() async {
    final input = int.tryParse(_numberController.text.trim());
    if (input == null || input <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập số nguyên dương hợp lệ!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _c1Loading = true;
      _c1Result = '';
    });

    final result = await compute(_computeFactorial, input);
    final resultStr = result.toString();

    setState(() {
      _c1Loading = false;
      _c1Result = resultStr.length > 50
          ? '${resultStr.substring(0, 50)}...\n(Tổng ${resultStr.length} chữ số)'
          : resultStr;
    });
  }

  // ======================
  // CHALLENGE 2
  // ======================
  static void _workerIsolateFunc(SendPort mainSendPort) async {
    final workerReceivePort = ReceivePort();
    mainSendPort.send(workerReceivePort.sendPort);

    final random = Random();
    bool running = false;

    await for (final msg in workerReceivePort) {
      if (msg == 'stop') {
        Isolate.exit(mainSendPort, 'exited');
      }
      if (msg == 'start' && !running) {
        running = true;
        while (running) {
          await Future.delayed(const Duration(seconds: 1));
          final num = random.nextInt(20) + 1;
          mainSendPort.send(num);
        }
      }
    }
  }

  Future<void> _startChallenge2() async {
    if (_c2Running) return;

    setState(() {
      _c2Running = true;
      _c2Sum = 0;
      _c2Log.clear();
      _c2Log.add('🚀 Bắt đầu worker isolate...');
    });

    _receivePort = ReceivePort();
    _workerIsolate =
        await Isolate.spawn(_workerIsolateFunc, _receivePort!.sendPort);

    _receivePort!.listen((message) {
      if (message is SendPort) {
        _workerSendPort = message;
        _workerSendPort!.send('start');
        return;
      }

      if (message is int && _c2Running) {
        setState(() {
          _c2Sum += message;
          _c2Log.add('📨 Nhận: +$message → Tổng = $_c2Sum');

          if (_c2Sum > 100) {
            _c2Log.add('⚠️ Tổng vượt 100!');
            _c2Log.add('🛑 Gửi lệnh stop cho worker...');
            _workerSendPort?.send('stop');
            _c2Running = false;
          }
        });
      }

      if (message == 'exited') {
        setState(() {
          _c2Log.add('✅ Worker isolate đã thoát gracefully!');
        });
        _receivePort?.close();
      }
    });
  }

  void _resetChallenge2() {
    _workerSendPort?.send('stop');
    _workerIsolate?.kill(priority: Isolate.immediate);
    _receivePort?.close();
    setState(() {
      _c2Running = false;
      _c2Sum = 0;
      _c2Log.clear();
      _workerSendPort = null;
    });
  }

  @override
  void dispose() {
    _numberController.dispose();
    _workerIsolate?.kill();
    _receivePort?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolate Exercises'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // ======== CHALLENGE 1 ========
            _sectionHeader('Challenge 1: Tính giai thừa!', Colors.orange),
            const SizedBox(height: 6),
            const Text(
              'Nhập số cần tính giai thừa, dùng compute() isolate.\nUI vẫn mượt trong khi tính toán.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 14),

            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nhập số (ví dụ: 30000)',
                prefixIcon:
                    const Icon(Icons.numbers, color: Colors.orange),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.orange, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 14),

            if (_c1Loading) ...[
              const Center(
                  child: CircularProgressIndicator(color: Colors.orange)),
              const SizedBox(height: 8),
              const Center(
                child: Text('Đang tính toán, vui lòng chờ...',
                    style: TextStyle(color: Colors.grey)),
              ),
              const SizedBox(height: 14),
            ],

            if (_c1Result.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('✅ Kết quả:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange)),
                    const SizedBox(height: 8),
                    Text(_c1Result,
                        style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            ElevatedButton.icon(
              onPressed: _c1Loading ? null : _startChallenge1,
              icon: const Icon(Icons.calculate),
              label:
                  Text(_c1Loading ? 'Đang tính...' : 'Tính giai thừa!'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 28),
            const Divider(thickness: 1.5),
            const SizedBox(height: 16),

            // ======== CHALLENGE 2 ========
            _sectionHeader('Challenge 2: Random Isolate', Colors.teal),
            const SizedBox(height: 6),
            const Text(
              'Worker gửi số random mỗi giây.\nMain cộng dồn → khi tổng > 100 gửi stop.\nWorker thoát bằng Isolate.exit().',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: _c2Sum > 100
                    ? Colors.red.shade50
                    : Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _c2Sum > 100
                      ? Colors.red.shade200
                      : Colors.teal.shade200,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tổng hiện tại:',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  Text(
                    '$_c2Sum',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: _c2Sum > 100 ? Colors.red : Colors.teal,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            if (_c2Log.isNotEmpty)
              Container(
                height: 180,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ListView.builder(
                  itemCount: _c2Log.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Text(
                      _c2Log[i],
                      style: TextStyle(
                        fontSize: 12,
                        color: _c2Log[i].contains('🛑') ||
                                _c2Log[i].contains('✅') ||
                                _c2Log[i].contains('⚠️')
                            ? Colors.red.shade700
                            : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _c2Running ? null : _startChallenge2,
                    icon: const Icon(Icons.play_arrow),
                    label:
                        Text(_c2Running ? 'Đang chạy...' : 'Start'),
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
                  child: OutlinedButton.icon(
                    onPressed: _resetChallenge2,
                    icon:
                        const Icon(Icons.refresh, color: Colors.teal),
                    label: const Text('Reset',
                        style: TextStyle(color: Colors.teal)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.teal),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          color: color,
          margin: const EdgeInsets.only(right: 10),
        ),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}