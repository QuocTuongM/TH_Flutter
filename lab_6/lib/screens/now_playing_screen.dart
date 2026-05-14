import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../models/playback_state_model.dart';
import '../utils/constants.dart';
import '../widgets/album_art.dart';
import '../widgets/player_controls.dart';
import '../widgets/progress_bar.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, provider, _) {
        final song = provider.currentSong;
        if (song == null) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Text('No song playing',
                  style: TextStyle(color: AppColors.white)),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // AppBar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.white,
                            size: 32),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Đang phát',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert,
                            color: AppColors.white),
                        onPressed: () =>
                            _showOptions(context, provider),
                      ),
                    ],
                  ),
                ),

                // Album art
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: 0.5),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(8),
                            child: AlbumArt(
                              albumArtPath: song.albumArt,
                              size: double.infinity,
                              borderRadius: 8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Song info
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              song.artist,
                              style: const TextStyle(
                                color: AppColors.grey,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Progress bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16),
                  child: StreamBuilder<PlaybackStateModel>(
                    stream: provider.playbackStateStream,
                    builder: (_, snapshot) {
                      final state = snapshot.data;
                      return ProgressBar(
                        position:
                            state?.position ?? Duration.zero,
                        duration:
                            state?.duration ?? Duration.zero,
                        onSeek: (pos) => provider.seek(pos),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Player controls
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16),
                  child: PlayerControls(provider: provider),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showOptions(BuildContext context, AudioProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
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
            leading: const Icon(Icons.playlist_add,
                color: AppColors.white),
            title: const Text('Thêm vào playlist',
                style: TextStyle(color: AppColors.white)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.share,
                color: AppColors.white),
            title: const Text('Chia sẻ',
                style: TextStyle(color: AppColors.white)),
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}