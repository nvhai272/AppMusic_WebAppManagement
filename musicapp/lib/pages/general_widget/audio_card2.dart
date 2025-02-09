import 'package:flutter/material.dart';
import 'package:musicapp/providers/song_provider.dart';
import 'package:provider/provider.dart';
import '../../dto/response/song_response.dart';

class AudioCard extends StatelessWidget {
  final bool isPlaying;
  final SongResponse? currentSong;

  const AudioCard({Key? key, required this.isPlaying, this.currentSong})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SongProvider>(
      builder: (context, provider, child) {
        final currentSong = provider.currentSong;

        if (currentSong == null) {
          return Container();
          //   return Card(
          //     child: Center(
          //       child: Padding(
          //         padding: const EdgeInsets.all(16.0),
          //         child: Text(
          //           "No song playing",
          //           style: Theme.of(context).textTheme.bodyMedium,
          //         ),
          //       ),
          //     ),
          //   ); // Return a placeholder if no song is available
        }

        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Song thumbnail
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: currentSong.albumImage != null &&
                                currentSong.albumImage.isNotEmpty
                            ? Image.network(
                                'http://localhost:8080/api/files/download/image/${currentSong.albumImage}',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.music_note,
                                size: 50), // Placeholder for missing image
                      ),
                      const SizedBox(width: 8),
                      // Song details
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.albumTitle,
                            // style: Theme.of(context).textTheme.subtitle1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            currentSong.artistName,
                            // style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Playback controls
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        onPressed: provider.playPreviousSong,
                      ),
                      IconButton(
                        icon: Icon(provider.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow),
                        onPressed: provider.pauseOrResume,
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        onPressed: provider.playNextSong,
                      ),
                    ],
                  ),
                ],
              ),
              // Playback progress slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 12),
                ),
                child: Slider(
                  min: 0,
                  max: provider.totalDuration.inSeconds.toDouble(),
                  value: provider.currentDuration.inSeconds
                      .toDouble()
                      .clamp(0.0, provider.totalDuration.inSeconds.toDouble()),
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveColor: Colors.grey,
                  onChanged: (value) {
                    provider.seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
