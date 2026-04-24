import 'package:flutter/material.dart';
import '../models/calculation_history.dart';
import '../services/storage_service.dart';
import '../utils/calculator_logic.dart';

enum CalculatorMode { basic, scientific, programmer }

class CalculatorProvider extends ChangeNotifier {
  String _expression = '';
  String _display = '0';
  String _memory = '0';
  bool _isDeg = true;
  int _decimalPrecision = 8;
  int _historySize = 50;
  CalculatorMode _mode = CalculatorMode.basic;
  List<CalculationHistory> _history = [];

  String get display => _display;
  String get expression => _expression;
  String get memory => _memory;
  bool get isDeg => _isDeg;
  int get decimalPrecision => _decimalPrecision;
  int get historySize => _historySize;
  CalculatorMode get mode => _mode;
  List<CalculationHistory> get history => _history;

  final _storage = StorageService();

  CalculatorProvider() {
    _loadAll();
  }

  Future<void> _loadAll() async {
    _history = await _storage.loadHistory();
    _isDeg = await _storage.loadBool('isDeg') ?? true;
    _decimalPrecision = await _storage.loadInt('decimalPrecision') ?? 8;
    _historySize = await _storage.loadInt('historySize') ?? 50;
    notifyListeners();
  }

  void setMode(CalculatorMode m) {
    _mode = m;
    notifyListeners();
  }

  void toggleDeg() {
    _isDeg = !_isDeg;
    _storage.saveBool('isDeg', _isDeg);
    notifyListeners();
  }

  void setDecimalPrecision(int value) {
    _decimalPrecision = value;
    _storage.saveInt('decimalPrecision', value);
    notifyListeners();
  }

  void setHistorySize(int value) {
    _historySize = value;
    _storage.saveInt('historySize', value);
    notifyListeners();
  }

  void onButton(String value) {
    switch (value) {
      case 'C':
        _clear();
        break;
      case 'CE':
        _clearEnd();
        break;
      case '=':
        _calculate();
        break;
      case 'M+':
        _memAdd();
        break;
      case 'M-':
        _memSub();
        break;
      case 'MR':
        _memRecall();
        break;
      case 'MC':
        _memClear();
        break;
      default:
        _append(value);
        break;
    }
    notifyListeners();
  }

  void _clear() {
    _expression = '';
    _display = '0';
  }

  void _clearEnd() {
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      _display = _expression.isEmpty ? '0' : _expression;
    }
  }

  void _append(String value) {
    final sciMap = {
      'sin': 'sin(',
      'cos': 'cos(',
      'tan': 'tan(',
      'asin': 'asin(',
      'acos': 'acos(',
      'atan': 'atan(',
      'ln': 'ln(',
      'log': 'log(',
      '√': 'sqrt(',
      'x²': '^2',
      'π': 'pi',
      'e': 'e',
    };

    if (value == '±') {
      if (_expression.startsWith('-')) {
        _expression = _expression.substring(1);
      } else if (_expression.isNotEmpty) {
        _expression = '-$_expression';
      }
      _display = _expression.isEmpty ? '0' : _expression;
      return;
    }

    final mapped = sciMap[value] ?? value;

    if (_expression == '0') {
      _expression = mapped;
    } else {
      _expression += mapped;
    }

    _display = _expression;
  }

  void _calculate() {
    if (_expression.isEmpty || _expression == '0') return;

    try {
      final result = CalculatorLogic.evaluate(_expression, _isDeg);

      String resultStr;
      if (result == result.truncateToDouble()) {
        resultStr = result.toInt().toString();
      } else {
        resultStr = double.parse(result.toStringAsFixed(_decimalPrecision))
            .toString()
            .replaceAll(RegExp(r'0+$'), '')
            .replaceAll(RegExp(r'\.$'), '');
      }

      _history.insert(
        0,
        CalculationHistory(
          expression: _expression,
          result: resultStr,
          timestamp: DateTime.now(),
        ),
      );

      if (_history.length > _historySize) {
        _history = _history.sublist(0, _historySize);
      }

      _storage.saveHistory(_history);

      _display = resultStr;
      _expression = resultStr;
    } catch (_) {
      _display = 'Error';
      _expression = '';
    }
  }

  void _memAdd() {
    final val = double.tryParse(_display) ?? 0;
    final mem = double.tryParse(_memory) ?? 0;
    _memory = (mem + val).toString();
  }

  void _memSub() {
    final val = double.tryParse(_display) ?? 0;
    final mem = double.tryParse(_memory) ?? 0;
    _memory = (mem - val).toString();
  }

  void _memRecall() {
    _expression = _memory;
    _display = _memory;
  }

  void _memClear() {
    _memory = '0';
  }

  void useHistory(CalculationHistory h) {
    _expression = h.result;
    _display = h.result;
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history = [];
    await _storage.clearHistory();
    notifyListeners();
  }
}