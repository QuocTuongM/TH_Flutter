import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../providers/playlist_provider.dart';
import '../models/playlist_model.dart';
import '../utils/constants.dart';
import '../widgets/playlist_card.dart';
import '../widgets/mini_player.dart';
import 'now_playing_screen.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Playlists',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add,
                        color: AppColors.white, size: 28),
                    onPressed: () =>
                        _showCreatePlaylist(context),
                  ),
                ],
              ),
            ),

            // Playlist grid
            Expanded(
              child: Consumer<PlaylistProvider>(
                builder: (_, provider, __) {
                  if (provider.playlists.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.queue_music,
                              size: 80,
                              color: AppColors.darkGrey),
                          const SizedBox(height: 16),
                          const Text(
                            'Chưa có playlist nào',
                            style: TextStyle(
                                color: AppColors.white,
                                fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: () =>
                                _showCreatePlaylist(context),
                            icon: const Icon(Icons.add,
                                color: AppColors.primary),
                            label: const Text(
                              'Tạo playlist mới',
                              style: TextStyle(
                                  color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: provider.playlists.length,
                    itemBuilder: (_, i) {
                      final playlist = provider.playlists[i];
                      return PlaylistCard(
                        playlist: playlist,
                        songCount: playlist.songIds.length,
                        onTap: () => _openPlaylist(
                            context, playlist, provider),
                        onDelete: () => _confirmDelete(
                            context, provider, playlist.id),
                      );
                    },
                  );
                },
              ),
            ),

            // Mini player
            Consumer<AudioProvider>(
              builder: (_, provider, __) {
                if (provider.currentSong == null) {
                  return const SizedBox.shrink();
                }
                return const MiniPlayer();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePlaylist(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Tạo playlist mới',
            style: TextStyle(color: AppColors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.white),
          decoration: const InputDecoration(
            hintText: 'Tên playlist',
            hintStyle: TextStyle(color: AppColors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.darkGrey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.primary),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy',
                style: TextStyle(color: AppColors.grey)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context
                    .read<PlaylistProvider>()
                    .createPlaylist(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Tạo',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _openPlaylist(BuildContext context,
      PlaylistModel playlist, PlaylistProvider provider) {
    final audioProvider = context.read<AudioProvider>();
    final songs = provider.getSongsInPlaylist(
        playlist, audioProvider.playlist);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _PlaylistDetailScreen(
          playlist: playlist,
          songs: songs,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context,
      PlaylistProvider provider, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Xóa playlist?',
            style: TextStyle(color: AppColors.white)),
        content: const Text(
            'Bạn có chắc muốn xóa playlist này không?',
            style: TextStyle(color: AppColors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy',
                style: TextStyle(color: AppColors.grey)),
          ),
          TextButton(
            onPressed: () {
              provider.deletePlaylist(id);
              Navigator.pop(context);
            },
            child: const Text('Xóa',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _PlaylistDetailScreen extends StatelessWidget {
  final PlaylistModel playlist;
  final songs;

  const _PlaylistDetailScreen({
    required this.playlist,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(playlist.name,
            style: const TextStyle(color: AppColors.white)),
        iconTheme:
            const IconThemeData(color: AppColors.white),
      ),
      body: songs.isEmpty
          ? const Center(
              child: Text('Playlist trống',
                  style: TextStyle(color: AppColors.grey)),
            )
          : ListView.builder(
              itemCount: songs.length,
              itemBuilder: (_, i) => ListTile(
                leading: const Icon(Icons.music_note,
                    color: AppColors.grey),
                title: Text(songs[i].title,
                    style: const TextStyle(
                        color: AppColors.white)),
                subtitle: Text(songs[i].artist,
                    style: const TextStyle(
                        color: AppColors.grey)),
                onTap: () => context
                    .read<AudioProvider>()
                    .setPlaylist(songs, i),
              ),
            ),
    );
  }
}