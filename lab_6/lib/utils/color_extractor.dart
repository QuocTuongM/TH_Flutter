import 'dart:io';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class ColorExtractor {
  static Future<Color> getDominantColor(String? imagePath) async {
    if (imagePath == null) return const Color(0xFF282828);

    try {
      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        FileImage(File(imagePath)),
        size: const Size(100, 100),
      );
      return paletteGenerator.dominantColor?.color ??
          const Color(0xFF282828);
    } catch (_) {
      return const Color(0xFF282828);
    }
  }
}