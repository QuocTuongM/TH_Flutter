import 'package:flutter/material.dart';
import '../models/playlist_model.dart';
import '../models/song_model.dart';
import '../services/storage_service.dart';

class PlaylistProvider extends ChangeNotifier {
  final StorageService _storage;

  List<PlaylistModel> _playlists = [];
  List<PlaylistModel> get playlists => _playlists;

  PlaylistProvider(this._storage) {
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    _playlists = await _storage.getPlaylists();
    notifyListeners();
  }

  // Tạo playlist mới
  Future<void> createPlaylist(String name) async {
    final playlist = PlaylistModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      songIds: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _playlists.add(playlist);
    await _storage.savePlaylists(_playlists);
    notifyListeners();
  }

  // Xóa playlist
  Future<void> deletePlaylist(String id) async {
    _playlists.removeWhere((p) => p.id == id);
    await _storage.savePlaylists(_playlists);
    notifyListeners();
  }

  // Thêm bài hát vào playlist
  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    final index = _playlists.indexWhere((p) => p.id == playlistId);
    if (index == -1) return;

    final playlist = _playlists[index];
    if (!playlist.songIds.contains(songId)) {
      final updated = playlist.copyWith(
        songIds: [...playlist.songIds, songId],
      );
      _playlists[index] = updated;
      await _storage.savePlaylists(_playlists);
      notifyListeners();
    }
  }

  // Xóa bài hát khỏi playlist
  Future<void> removeSongFromPlaylist(
      String playlistId, String songId) async {
    final index = _playlists.indexWhere((p) => p.id == playlistId);
    if (index == -1) return;

    final playlist = _playlists[index];
    final updated = playlist.copyWith(
      songIds: playlist.songIds.where((id) => id != songId).toList(),
    );
    _playlists[index] = updated;
    await _storage.savePlaylists(_playlists);
    notifyListeners();
  }

  // Đổi tên playlist
  Future<void> renamePlaylist(String id, String newName) async {
    final index = _playlists.indexWhere((p) => p.id == id);
    if (index == -1) return;

    _playlists[index] = _playlists[index].copyWith(name: newName);
    await _storage.savePlaylists(_playlists);
    notifyListeners();
  }

  // Lấy bài hát trong playlist
  List<SongModel> getSongsInPlaylist(
      PlaylistModel playlist, List<SongModel> allSongs) {
    return allSongs
        .where((s) => playlist.songIds.contains(s.id))
        .toList();
  }
}