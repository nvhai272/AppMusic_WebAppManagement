// import 'dart:async';
// import 'package:audioplayers/audioplayers.dart';

// import 'package:http/http.dart' as http;
// import 'package:musicapp/dto/response/song_response.dart';
// import 'package:musicapp/models/lyrics.dart';

// class LyricsProvider {
//   static const String _baseAudioUrl =
//       'http://localhost:8080/api/public/files/download/lrc/';

//   final AudioPlayer player;
//   final SongResponse song;
//   List<Lyrics>? lyrics;
//   StreamSubscription? streamSubscription;
//   int lastScrolledIndex = -1;

//   LyricsProvider({required this.player, required this.song});

//   Future<void> fetchLyrics() async {
//     final lyricsUrl = '$_baseAudioUrl${song.lyricFilePath}';
//     try {
//       final response = await http.get(Uri.parse(lyricsUrl));
//       if (response.statusCode == 200) {
//         lyrics = parseLrc(response.body);
//       } else {
//         lyrics = [];
//       }
//     } catch (e) {
//       lyrics = [];
//     }
//   }

//   List<Lyrics> parseLrc(String lrcContent) {
//     final lines = lrcContent.split('\n');
//     final List<Lyrics> parsedLyrics = [];

//     for (var line in lines) {
//       final match = RegExp(r'\[(\d+):(\d+\.\d+)\](.+)').firstMatch(line);
//       if (match != null) {
//         final minutes = int.parse(match.group(1)!);
//         final seconds = double.parse(match.group(2)!);
//         final text = match.group(3)!.trim();
//         final time = Duration(
//           minutes: minutes,
//           seconds: seconds.floor(),
//           milliseconds: ((seconds % 1) * 1000).toInt(),
//         );
//         parsedLyrics.add(Lyrics(
//           timeStamp: DateTime(1970, 1, 1).add(time),
//           words: text,
//         ));
//       }
//     }
//     return parsedLyrics;
//   }

//   void syncLyricsWithAudio(
//       Function(int index) scrollToLyric, Function() scrollToCurrentLyric) {
//     streamSubscription = player.onPositionChanged.listen((duration) {
//       if (lyrics == null || lyrics!.isEmpty) return;

//       final currentTime = DateTime(1970, 1, 1).add(duration);

//       for (int index = 0; index < lyrics!.length; index++) {
//         if (lyrics![index].timeStamp.isAfter(currentTime)) {
//           if (lastScrolledIndex != index) {
//             scrollToLyric(index);
//             lastScrolledIndex = index;
//           }
//           break;
//         }
//       }
//     });
//   }

//   void dispose() {
//     streamSubscription?.cancel();
//   }
//    void syncLyricsWithAudio() {
//     streamSubscription = widget.player.onPositionChanged.listen((duration) {
//       if (lyrics == null || lyrics!.isEmpty) return;

//       final currentTime = DateTime(1970, 1, 1).add(duration);

//       // Find the first lyric that corresponds to the current time.
//       for (int index = 0; index < lyrics!.length; index++) {
//         if (lyrics![index].timeStamp.isAfter(currentTime)) {
//           // Scroll to the current lyric only if it's necessary (avoid redundant scrolls).
//           if (lastScrolledIndex != index) {
//             itemScrollController.scrollTo(
//               index: index > 3 ? index - 3 : 0, // Center the lyric
//               duration: const Duration(milliseconds: 500),
//             );
//             lastScrolledIndex = index;
//           }
//           break;
//         }
//       }
//     });
//   }
// }
