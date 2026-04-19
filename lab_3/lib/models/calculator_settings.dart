class CalculatorSettings {
  final bool isDark;
  final int decimalPrecision;
  final bool isDeg;
  final bool hapticFeedback;
  final int historySize;

  const CalculatorSettings({
    this.isDark = true,
    this.decimalPrecision = 8,
    this.isDeg = true,
    this.hapticFeedback = true,
    this.historySize = 50,
  });

  CalculatorSettings copyWith({
    bool? isDark,
    int? decimalPrecision,
    bool? isDeg,
    bool? hapticFeedback,
    int? historySize,
  }) {
    return CalculatorSettings(
      isDark: isDark ?? this.isDark,
      decimalPrecision: decimalPrecision ?? this.decimalPrecision,
      isDeg: isDeg ?? this.isDeg,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      historySize: historySize ?? this.historySize,
    );
  }

  Map<String, dynamic> toJson() => {
    'isDark': isDark,
    'decimalPrecision': decimalPrecision,
    'isDeg': isDeg,
    'hapticFeedback': hapticFeedback,
    'historySize': historySize,
  };

  factory CalculatorSettings.fromJson(Map<String, dynamic> json) =>
      CalculatorSettings(
        isDark: json['isDark'] ?? true,
        decimalPrecision: json['decimalPrecision'] ?? 8,
        isDeg: json['isDeg'] ?? true,
        hapticFeedback: json['hapticFeedback'] ?? true,
        historySize: json['historySize'] ?? 50,
      );
}