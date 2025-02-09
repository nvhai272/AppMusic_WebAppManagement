import 'package:flutter/material.dart';
import 'package:musicapp/providers/song_provider.dart';
import 'package:provider/provider.dart';

// class Position {
//   final double? top;
//   final double? left;
//   final double? right;
//   const Position({this.top = 560, this.left = 0, this.right = 0});
// }

class AudioCard extends StatelessWidget {
  // Position position;
  AudioCard({
    Key? key,
    // this.position = const Position()
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SongProvider>(
      builder: (context, value, child) {
        final currentSong = value.currentSong;
        if (currentSong == null) {
          return Card(
            child: Text(""),
          ); // Return empty if no song is available
        }
        return Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity, // Full width
          height: 75.0, // Fixed height of 120
          decoration: BoxDecoration(
            color: Colors.brown,
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
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
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          'http://localhost:8080/api/files/download/image/${currentSong.albumImage}',
                          width: 35,
                          height: 35,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          Text(
                            currentSong.artistName,
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon:  Icon(Icons.skip_previous,color: Colors.white,),
                        onPressed: () => value.playPreviousSong(),
                      ),
                      IconButton(
                        icon: Icon(
                            value.isPlaying ? Icons.pause_circle : Icons.play_circle,color: Colors.white,size: 35,),
                        onPressed: () => value.pauseOrResume(),
                      ),
                      IconButton(
                        icon:  Icon(Icons.skip_next,color: Colors.white),
                        onPressed: () => value.playNextSong(),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
                      trackHeight: 2,
                    ),
                    child: Slider(
                      min: 0,
                      max: value.totalDuration.inSeconds.toDouble(),
                      value: value.currentDuration.inSeconds.toDouble(),
                      activeColor: Colors.white,
                      onChanged: (double newValue) {},
                      onChangeEnd: (double newValue) {
                        value.seek(Duration(seconds: newValue.toInt()));
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
