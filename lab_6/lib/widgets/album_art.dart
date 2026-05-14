import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AlbumArt extends StatelessWidget {
  final String? albumArtPath;
  final double size;
  final double borderRadius;

  const AlbumArt({
    super.key,
    this.albumArtPath,
    this.size = 50,
    this.borderRadius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: AppColors.surface,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: albumArtPath != null && File(albumArtPath!).existsSync()
            ? Image.file(
                File(albumArtPath!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildDefault(),
              )
            : _buildDefault(),
      ),
    );
  }

  Widget _buildDefault() {
    return Container(
      color: AppColors.surface,
      child: Icon(
        Icons.music_note,
        color: AppColors.grey,
        size: size * 0.5,
      ),
    );
  }
}