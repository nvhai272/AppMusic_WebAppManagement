import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:musicapp/models/lyrics.dart';
import 'package:musicapp/models/song.dart';

class LyricsPages extends StatefulWidget {
  final Song song;
  final AudioPlayer player;

  LyricsPages({super.key, required this.player, required this.song});

  @override
  State<LyricsPages> createState() => _LyricsPagesState();
}

class _LyricsPagesState extends State<LyricsPages> {
  List<Lyrics>? lyrics; // Parsed lyrics list
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  StreamSubscription? streamSubscription;

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchLyrics();
    syncLyricsWithAudio();
  }

  /// Fetches lyrics from an API and parses them into a list of [Lyrics].
  void fetchLyrics() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://paxsenixofc.my.id/server/getLyricsMusix.php?q=${widget.song.songName} ${widget.song.artistName}&type=default'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          lyrics = parseLyrics(data['lyrics']); // Parse the response
        });
      } else {
        throw Exception('Failed to load lyrics');
      }
    } catch (e) {
      setState(() {
        lyrics = []; // Fallback: Empty lyrics
      });
    }
  }

  /// Parses the raw lyrics string into a list of [Lyrics] objects.
  List<Lyrics> parseLyrics(String lyricsData) {
    final lines = lyricsData.split('\n'); // Split by newlines
    return lines.map((line) {
      final parts = line.split('] '); // Format: [mm:ss] line
      if (parts.length == 2) {
        final timestamp = parts[0].replaceAll('[', '').trim();
        final words = parts[1].trim();
        final time = Duration(
          minutes: int.parse(timestamp.split(':')[0]),
          seconds: int.parse(timestamp.split(':')[1]),
        );
        return Lyrics(timeStamp: DateTime(1970, 1, 1).add(time), words: words);
      }
      return Lyrics(timeStamp: DateTime(1970, 1, 1), words: line.trim());
    }).toList();
  }

  /// Syncs the scrolling of lyrics with the audio player's current position.
  void syncLyricsWithAudio() {
    streamSubscription = widget.player.onPositionChanged.listen((duration) {
      final currentTime = DateTime(1970, 1, 1).add(duration);
      if (lyrics != null) {
        for (int index = 0; index < lyrics!.length; index++) {
          if (lyrics![index].timeStamp.isAfter(currentTime)) {
            itemScrollController.scrollTo(
              index: index > 3 ? index - 3 : 0, // Scroll with buffer
              duration: const Duration(milliseconds: 600),
            );
            break;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.song.songName)),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: lyrics == null
          ? Center(child: CircularProgressIndicator()) // Loading state
          : lyrics!.isEmpty
              ? Center(child: Text('No lyrics available')) // No lyrics state
              : SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0)
                        .copyWith(top: 20),
                    child: StreamBuilder<Duration>(
                        stream: widget.player.onPositionChanged,
                        builder: (context, snapshot) {
                          final currentDuration =
                              snapshot.data ?? const Duration();
                          final currentTime = DateTime(1970, 1, 1)
                              .add(currentDuration);
                          return ScrollablePositionedList.builder(
                            itemCount: lyrics!.length,
                            itemBuilder: (context, index) {
                              final lyric = lyrics![index];
                              final isCurrent = lyric.timeStamp
                                  .isBefore(currentTime);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Text(
                                  lyric.words,
                                  style: TextStyle(
                                    color: isCurrent
                                        ? Colors.yellow
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
                        }),
                  ),
                ),
    );
  }
}
