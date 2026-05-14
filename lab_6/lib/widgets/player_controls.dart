import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../providers/audio_provider.dart';
import '../utils/constants.dart';

class PlayerControls extends StatelessWidget {
  final AudioProvider provider;

  const PlayerControls({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Shuffle & Repeat
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                Icons.shuffle,
                color: provider.isShuffleEnabled
                    ? AppColors.primary
                    : AppColors.grey,
              ),
              onPressed: () => provider.toggleShuffle(),
            ),
            const SizedBox(width: 40),
            _buildRepeatButton(),
          ],
        ),

        const SizedBox(height: 20),

        // Main controls
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.skip_previous,
                  color: AppColors.white, size: 40),
              onPressed: () => provider.previous(),
            ),
            StreamBuilder<bool>(
              stream: provider.playingStream,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data ?? false;
                return GestureDetector(
                  onTap: () => provider.playPause(),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: AppColors.white,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.skip_next,
                  color: AppColors.white, size: 40),
              onPressed: () => provider.next(),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Volume slider
        Row(
          children: [
            const Icon(Icons.volume_down, color: AppColors.grey, size: 20),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 2,
                  thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6),
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.darkGrey,
                  thumbColor: AppColors.white,
                ),
                child: Slider(
                  value: provider.volume,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (v) => provider.setVolume(v),
                ),
              ),
            ),
            const Icon(Icons.volume_up, color: AppColors.grey, size: 20),
          ],
        ),
      ],
    );
  }

  Widget _buildRepeatButton() {
    IconData icon;
    Color color;

    switch (provider.loopMode) {
      case LoopMode.off:
        icon  = Icons.repeat;
        color = AppColors.grey;
        break;
      case LoopMode.all:
        icon  = Icons.repeat;
        color = AppColors.primary;
        break;
      case LoopMode.one:
        icon  = Icons.repeat_one;
        color = AppColors.primary;
        break;
    }

    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: () => provider.toggleRepeat(),
    );
  }
}