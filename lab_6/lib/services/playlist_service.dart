import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import '../models/song_model.dart';

class PlaylistService {
  static List<SongModel> _cachedSongs = [];

  // Lấy cache hiện tại
  List<SongModel> getCachedSongs() => _cachedSongs;

  // Thêm nhạc mới (không xóa cache cũ)
  Future<List<SongModel>> addSongs() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );

      if (result == null) return _cachedSongs;

      for (final f in result.files) {
        if (f.path == null) continue;

        // Tránh duplicate
        if (_cachedSongs.any((s) => s.id == f.path)) continue;

        String title = f.name.replaceAll(RegExp(r'\.[^.]+$'), '');
        String artist = 'Unknown Artist';
        String? album;
        Duration? duration;

        try {
          final metadata = await MetadataRetriever.fromFile(File(f.path!));
          if (metadata.trackName != null && metadata.trackName!.isNotEmpty) {
            title = metadata.trackName!;
          }
          if (metadata.authorName != null && metadata.authorName!.isNotEmpty) {
            artist = metadata.authorName!;
          }
          album = metadata.albumName;
          if (metadata.trackDuration != null) {
            duration = Duration(milliseconds: metadata.trackDuration!);
          }
        } catch (_) {}

        _cachedSongs.add(SongModel(
          id: f.path!,
          title: title,
          artist: artist,
          album: album,
          filePath: f.path!,
          duration: duration,
        ));
      }

      return _cachedSongs;
    } catch (e) {
      throw Exception('Error loading songs: $e');
    }
  }

  Future<List<SongModel>> getAllSongs() async => _cachedSongs;

  Future<List<SongModel>> searchSongs(String query) async {
    final q = query.toLowerCase();
    return _cachedSongs.where((s) =>
      s.title.toLowerCase().contains(q) ||
      s.artist.toLowerCase().contains(q) ||
      (s.album?.toLowerCase().contains(q) ?? false)
    ).toList();
  }

  Future<List<SongModel>> getSongsByArtist(String artist) async =>
      _cachedSongs.where((s) => s.artist == artist).toList();

  Future<List<SongModel>> getSongsByAlbum(String album) async =>
      _cachedSongs.where((s) => s.album == album).toList();

  void clearCache() => _cachedSongs = [];
}