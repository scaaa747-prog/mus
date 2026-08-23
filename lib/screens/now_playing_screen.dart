import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_player_service.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 32),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              'PLAYING FROM PLAYLIST',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Today\'s Top Hits',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<AudioPlayerService>(
        builder: (context, audioService, child) {
          final currentSong = audioService.currentSong;
          if (currentSong == null) {
            return const Center(
              child: Text('No song playing', style: TextStyle(color: Colors.white54)),
            );
          }

          final currentPos = audioService.currentPosition;
          final totalDur = audioService.totalDuration;
          final maxSec = totalDur.inSeconds > 0 ? totalDur.inSeconds.toDouble() : 1.0;
          final currSec = currentPos.inSeconds.toDouble().clamp(0.0, maxSec);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Album Art Card
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.82,
                    height: MediaQuery.of(context).size.width * 0.82,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C5CE7).withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        currentSong.coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade900,
                          child: const Icon(Icons.music_note, color: Colors.white54, size: 80),
                        ),
                      ),
                    ),
                  ),
                ),

                // Title & Artist & Favorite
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            currentSong.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        currentSong.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: currentSong.isFavorite ? const Color(0xFFFF4757) : Colors.white,
                        size: 28,
                      ),
                      onPressed: () => audioService.toggleFavorite(currentSong),
                    ),
                  ],
                ),

                // Progress Bar & Duration Labels
                Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                        activeTrackColor: const Color(0xFF6C5CE7),
                        inactiveTrackColor: Colors.white12,
                        thumbColor: Colors.white,
                        overlayColor: const Color(0xFF6C5CE7).withOpacity(0.2),
                      ),
                      child: Slider(
                        value: currSec,
                        min: 0.0,
                        max: maxSec,
                        onChanged: (value) {
                          audioService.seek(Duration(seconds: value.toInt()));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(currentPos),
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                          Text(
                            _formatDuration(totalDur),
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Player Controls (Shuffle, Previous, Play/Pause, Next, Repeat)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.shuffle_rounded,
                        color: audioService.isShuffle ? const Color(0xFF6C5CE7) : Colors.white54,
                        size: 24,
                      ),
                      onPressed: () => audioService.toggleShuffle(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 36),
                      onPressed: () => audioService.previousSong(),
                    ),
                    GestureDetector(
                      onTap: () => audioService.togglePlayPause(),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF6C5CE7),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF6C5CE7),
                              blurRadius: 16,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          audioService.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 36),
                      onPressed: () => audioService.nextSong(),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.repeat_rounded,
                        color: audioService.isLoop ? const Color(0xFF6C5CE7) : Colors.white54,
                        size: 24,
                      ),
                      onPressed: () => audioService.toggleLoop(),
                    ),
                  ],
                ),

                // Bottom Extras (Device Connect, Share, Playlist Queue)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.speaker_group_outlined, color: Colors.white54, size: 20),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined, color: Colors.white54, size: 20),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.queue_music_rounded, color: Colors.white54, size: 22),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
