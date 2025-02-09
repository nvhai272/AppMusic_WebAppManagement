import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:musicapp/components/neu_box.dart';
import 'package:musicapp/pages/v1/playlist_provider.dart';
import 'package:musicapp/pages/lyrics_page2.dart';
import 'package:provider/provider.dart';

class SongPage2 extends StatelessWidget {
  // Convert duration into min:sec
  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "${duration.inMinutes}:${twoDigitSeconds}";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(builder: (context, value, child) {
      // Get playlist and current song
      final playlist = value.playlist;
      final currentSong = playlist[value.currentSongIndex ?? 0];

      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            // Background Image with Blur
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'http://localhost:8080/api/files/download/image/${currentSong.albumArtImagePath}'), // Background image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                color:
                    Colors.black.withOpacity(0.3), // Tint to improve contrast
              ),
            ),
            // Foreground Content
            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        Icon(Icons.more_vert, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Album Artwork
                    NeuBox(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'http://localhost:8080/api/files/download/image/${currentSong.albumArtImagePath}',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentSong.songName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      currentSong.artistName,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Icon(Icons.favorite, color: Colors.red),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          // Progress and Lyrics
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatTime(value.currentDuration),
                                  style: TextStyle(color: Colors.white),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => LyricsPages2(
                                    //       song: currentSong,
                                    //       player: context.read<PlaylistProvider>().audioPlayer,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  icon: Icon(Icons.lyrics_outlined,
                                      color: Colors.white),
                                ),
                                Icon(Icons.repeat, color: Colors.white),
                                Text(
                                  formatTime(value.totalDuration),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbShape:
                                  RoundSliderThumbShape(enabledThumbRadius: 0),
                            ),
                            child: Slider(
                              min: 0,
                              max: value.totalDuration.inSeconds.toDouble(),
                              value: value.currentDuration.inSeconds.toDouble(),
                              activeColor: Colors.green,
                              onChanged: (double double) {},
                              onChangeEnd: (double double) {
                                value.seek(Duration(seconds: double.toInt()));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Controls
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: value.playPreviousSong,
                            child: NeuBox(child: Icon(Icons.skip_previous)),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: value.pauseOrResume,
                            child: NeuBox(
                              child: Icon(
                                value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: value.playNextSong,
                            child: NeuBox(child: Icon(Icons.skip_next)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
