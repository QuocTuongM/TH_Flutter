import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../utils/constants.dart';
import '../widgets/song_tile.dart';

class AllSongsScreen extends StatelessWidget {
  final List<SongModel> songs;

  const AllSongsScreen({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    final audioProvider = context.watch<AudioProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Tất cả bài hát',
            style: TextStyle(color: AppColors.white)),
        iconTheme:
            const IconThemeData(color: AppColors.white),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (_, i) {
          final song = songs[i];
          final isPlaying =
              audioProvider.currentSong?.id == song.id;
          return SongTile(
            song: song,
            isPlaying: isPlaying,
            onTap: () =>
                audioProvider.setPlaylist(songs, i),
          );
        },
      ),
    );
  }
}