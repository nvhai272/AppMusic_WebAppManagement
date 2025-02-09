import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:musicapp/dto/response/song_response.dart';
import 'package:musicapp/models/lyrics.dart';
import 'package:musicapp/models/song.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LyricsPages2 extends StatefulWidget {
  final SongResponse song;
  final AudioPlayer player;

  LyricsPages2({Key? key, required this.player, required this.song})
      : super(key: key);

  @override
  State<LyricsPages2> createState() => _LyricsPagesState2();
}

class _LyricsPagesState2 extends State<LyricsPages2> {
  bool hasLyrics = true;
  int lastScrolledIndex = -1;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();
  List<Lyrics>? lyrics;
  StreamSubscription? streamSubscription;
  static const String _baseAudioUrl =
      'http://localhost:8080/api/files/download/lrc/';
  @override
  void initState() {
    syncLyricsWithAudio();
    // positionSubscription = widget.player.onPositionChanged.listen((duration) {
    //   DateTime dt = DateTime(1970, 1, 1).copyWith(
    //       hour: duration.inHours,
    //       minute: duration.inMinutes.remainder(60),
    //       second: duration.inSeconds.remainder(60));
    //   if (lyrics != null) {
    //     for (int index = 0; index < lyrics!.length; index++) {
    //       if (index > 4 && lyrics![index].timeStamp.isAfter(dt)) {
    //         itemScrollController.scrollTo(
    //             index: index - 3, duration: const Duration(milliseconds: 600));
    //         break;
    //       }
    //     }
    //   }
    // });
    // loadAndParseLyrics();
    fetchLyrics();
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  /// Load and parse lyrics from the .lrc file.
  // Future<void> loadAndParseLyrics() async {
  //   try {
  //     final lrcContent =
  //         await rootBundle.loadString('${widget.song.lyricFilePath}');
  //     setState(() {
  //       lyrics = parseLrc(lrcContent);
  //     });
  //   } catch (e) {
  //     print('Error loading lyrics: $e');
  //     setState(() {
  //       lyrics = [];
  //     });
  //   }
  // }

  void fetchLyrics() async {
    final lyricsUrl = '$_baseAudioUrl${widget.song.lyricFilePath}';
    print(lyricsUrl);
    try {
      final response = await http.get(Uri.parse(lyricsUrl));
      if (response.statusCode == 200) {
        setState(() {
          lyrics = parseLrc(response.body); // Parse lyrics from response body.
          hasLyrics = lyrics != null && lyrics!.isNotEmpty;
        });
      } else {
        debugPrint('Failed to load lyrics: ${response.statusCode}');
        setState(() {
          lyrics = []; // Fallback: Empty lyrics
        });
      }
    } catch (e) {
      debugPrint('Error fetching lyrics: $e');
      setState(() {
        lyrics = []; // Fallback: Empty lyrics
        hasLyrics = false;
      });
    }
  }

  /// Parse LRC content into a list of `Lyrics` objects.
  List<Lyrics> parseLrc(String lrcContent) {
    final lines = lrcContent.split('\n');
    final List<Lyrics> parsedLyrics = [];

    for (var line in lines) {
      final match = RegExp(r'\[(\d+):(\d+\.\d+)\](.+)').firstMatch(line);
      if (match != null) {
        final minutes = int.parse(match.group(1)!);
        final seconds = double.parse(match.group(2)!);
        final text = match.group(3)!.trim();
        final time = Duration(
          minutes: minutes,
          seconds: seconds.floor(),
          milliseconds: ((seconds % 1) * 1000).toInt(),
        );
        parsedLyrics.add(Lyrics(
          timeStamp: DateTime(1970, 1, 1).add(time),
          words: text,
        ));
      }
    }
    return parsedLyrics;
  }

  //  Sync lyrics with audio playback.
  // void syncLyricsWithAudio() {
  //   positionSubscription = widget.player.onPositionChanged.listen((duration) {
  //     final currentTime = DateTime(1970, 1, 1).add(duration);
  //     if (lyrics == null || lyrics!.isEmpty) return;

  //     for (int index = 0; index < lyrics!.length; index++) {
  //       if (lyrics![index].timeStamp.isAfter(currentTime)) {
  //         itemScrollController.scrollTo(
  //           index: index > 3 ? index - 3 : 0, // Center the current lyric
  //           duration: const Duration(milliseconds: 500),
  //         );
  //         break;
  //       }
  //     }
  //   });
  // }
  void syncLyricsWithAudio() {
    streamSubscription = widget.player.onPositionChanged.listen((duration) {
      if (lyrics == null || lyrics!.isEmpty) return;

      final currentTime = DateTime(1970, 1, 1).add(duration);

      // Find the first lyric that corresponds to the current time.
      for (int index = 0; index < lyrics!.length; index++) {
        if (lyrics![index].timeStamp.isAfter(currentTime)) {
          // Scroll to the current lyric only if it's necessary (avoid redundant scrolls).
          if (lastScrolledIndex != index) {
            itemScrollController.scrollTo(
              index: index > 3 ? index - 3 : 0, // Center the lyric
              duration: const Duration(milliseconds: 500),
            );
            lastScrolledIndex = index;
          }
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.song.title)),
      backgroundColor: Colors.black,
      body: lyrics == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: lyrics!.isEmpty || !hasLyrics
                    ? const Center(
                        child: Text(
                          "No lyrics for this song",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : StreamBuilder<Duration>(
                        stream: widget.player.onPositionChanged,
                        builder: (context, snapshot) {
                          final currentDuration =
                              snapshot.data ?? const Duration();
                          final currentTime =
                              DateTime(1970, 1, 1).add(currentDuration);

                          return ScrollablePositionedList.builder(
                            itemCount: lyrics!.length,
                            itemBuilder: (context, index) {
                              final lyric = lyrics![index];
                              final isCurrent =
                                  lyric.timeStamp.isBefore(currentTime) &&
                                      (index == lyrics!.length - 1 ||
                                          lyrics![index + 1]
                                              .timeStamp
                                              .isAfter(currentTime));

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Text(
                                  lyric.words,
                                  style: TextStyle(
                                    color: isCurrent
                                        ? Colors.white
                                        : Colors.white38,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                            itemScrollController: itemScrollController,
                            itemPositionsListener: itemPositionsListener,
                          );
                        },
                      ),
              ),
            ),
    );
  }
}// Loading state
//           : SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 20.0, vertical: 10.0),
//                 child: StreamBuilder<Duration>(
//                   stream: widget.player.onPositionChanged,
//                   builder: (context, snapshot) {
//                     final currentDuration = snapshot.data ?? const Duration();
//                     final currentTime =
//                         DateTime(1970, 1, 1).add(currentDuration);

//                     return ScrollablePositionedList.builder(
//                       itemCount: lyrics!.length,
//                       itemBuilder: (context, index) {
//                         final lyric = lyrics![index];
//                         final isCurrent =
//                             lyric.timeStamp.isBefore(currentTime) &&
//                                 (index == lyrics!.length - 1 ||
//                                     lyrics![index + 1]
//                                         .timeStamp
//                                         .isAfter(currentTime));

//                         return Padding(
//                           padding: const EdgeInsets.only(bottom: 16.0),
//                           child: Text(
//                             lyric.words,
//                             style: TextStyle(
//                               color: isCurrent ? Colors.white : Colors.white38,
//                               fontSize: 26,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         );
//                       },
//                       itemScrollController: itemScrollController,
//                       scrollOffsetController: scrollOffsetController,
//                       itemPositionsListener: itemPositionsListener,
//                     );
//                   },
//                 ),
//               ),
//             ),
//     );
//   }
// }
