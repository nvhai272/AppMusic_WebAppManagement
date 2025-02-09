import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/neu_box.dart';
import '../providers/song_provider.dart';
import 'lyrics_page2.dart';

class SongPage extends StatelessWidget {
  const SongPage({Key? key}) : super(key: key);

  // Convert duration into mm:ss format
  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "${duration.inMinutes}:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SongProvider>(builder: (context, value, child) {
      // Get the current song
      final songs = value.playingSongs;
      final currentSong = songs[value.currentSongIndex ?? 0];

      // Return Scaffold
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            // Background Image with Blur
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'http://localhost:8080/api/files/download/image/${currentSong.albumImage}'), // Background image
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
                              'http://localhost:8080/api/files/download/image/${currentSong.albumImage}',
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
                                      currentSong.title,
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
                                IconButton(
                                  icon: Icon(
                                    value.isLiked(currentSong
                                            .id) // Check if the song is liked
                                        ? Icons
                                            .favorite // If liked, show the filled heart icon
                                        : Icons
                                            .favorite_border, // If not liked, show the border heart icon
                                    color: value.isLiked(currentSong
                                            .id) // Change color based on like status
                                        ? Colors
                                            .red // If liked, set the color to red
                                        : Colors
                                            .white, // If not liked, set the color to white
                                  ),
                                  onPressed: () async {
                                    // Make sure to fetch the liked songs before toggling the like status
                                    await value.fetchLikedSongs(
                                        context); // Fetch the latest liked songs

                                    // Now toggle the like status of the current song
                                    value.toggleLikeStatus(
                                      context,
                                      currentSong.id,
                                    );
                                  },
                                ),
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LyricsPages2(
                                          song: currentSong,
                                          player: context
                                              .read<SongProvider>()
                                              .audioPlayer,
                                        ),
                                      ),
                                    );
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
                            child: NeuBox(
                                child: Icon(
                              Icons.skip_previous,
                              color: Colors.white,
                            )),
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
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: value.playNextSong,
                            child: NeuBox(
                                child: Icon(
                              Icons.skip_next,
                              color: Colors.white,
                            )),
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
