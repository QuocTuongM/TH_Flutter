import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../providers/playlist_provider.dart';
import '../utils/constants.dart';
import '../utils/duration_formatter.dart';
import 'album_art.dart';

class SongTile extends StatelessWidget {
  final SongModel song;
  final VoidCallback onTap;
  final bool isPlaying;

  const SongTile({
    super.key,
    required this.song,
    required this.onTap,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Stack(
        children: [
          AlbumArt(albumArtPath: song.albumArt, size: 50),
          if (isPlaying)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.equalizer,
                    color: AppColors.primary, size: 24),
              ),
            ),
        ],
      ),
      title: Text(
        song.title,
        style: TextStyle(
          color: isPlaying ? AppColors.primary : AppColors.white,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${song.artist} • ${DurationFormatter.format(song.duration ?? Duration.zero)}',
        style: const TextStyle(color: AppColors.grey, fontSize: 12),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert, color: AppColors.grey),
        onPressed: () => _showOptionsMenu(context),
      ),
      onTap: onTap,
    );
  }

  void _showOptionsMenu(BuildContext context) {
    final playlists =
        context.read<PlaylistProvider>().playlists;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.darkGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.play_arrow, color: AppColors.white),
            title: const Text('Phát ngay',
                style: TextStyle(color: AppColors.white)),
            onTap: () {
              Navigator.pop(context);
              onTap();
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.playlist_add, color: AppColors.white),
            title: const Text('Thêm vào playlist',
                style: TextStyle(color: AppColors.white)),
            onTap: () {
              Navigator.pop(context);
              _showAddToPlaylist(context, playlists);
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.info_outline, color: AppColors.white),
            title: const Text('Thông tin bài hát',
                style: TextStyle(color: AppColors.white)),
            onTap: () {
              Navigator.pop(context);
              _showSongInfo(context);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showAddToPlaylist(BuildContext context, playlists) {
    if (playlists.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chưa có playlist nào!'),
          backgroundColor: AppColors.surface,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (_) => ListView.builder(
        shrinkWrap: true,
        itemCount: playlists.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.queue_music, color: AppColors.white),
          title: Text(playlists[i].name,
              style: const TextStyle(color: AppColors.white)),
          onTap: () {
            context
                .read<PlaylistProvider>()
                .addSongToPlaylist(playlists[i].id, song.id);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Đã thêm vào ${playlists[i].name}'),
                backgroundColor: AppColors.primary,
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSongInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Thông tin bài hát',
            style: TextStyle(color: AppColors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow('Tên', song.title),
            _infoRow('Nghệ sĩ', song.artist),
            _infoRow('Album', song.album ?? 'Unknown'),
            _infoRow('Thời lượng',
                DurationFormatter.format(song.duration ?? Duration.zero)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                  color: AppColors.grey, fontSize: 13),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                  color: AppColors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}