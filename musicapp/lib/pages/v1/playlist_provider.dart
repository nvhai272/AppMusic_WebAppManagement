import 'package:flutter/material.dart';
import 'package:musicapp/models/song.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

class PlaylistProvider extends ChangeNotifier {
  final List<Song> _playlist = [
    Song(
        songName: 'Limbo',
        artistName: "Keshi",
        albumArtImagePath: "assets/images/2.webp",
        audioPath: "audio/Limbo.mp3",
        lyricsFile: "lyrics/Limbo.lrc"),
    Song(
        songName: 'Señorita',
        artistName: "Shawn Mendes",
        albumArtImagePath: "assets/images/3.jpg",
        audioPath: "audio/Señorita.mp3",
        lyricsFile: "lyrics/Senorita.lrc"),
    Song(
        songName: 'As You Fade Away',
        artistName: "NEFFEX",
        albumArtImagePath: "assets/images/3.jpg",
        audioPath: "audio/music1.mp3",
        lyricsFile: "lyrics/Limbo.lrc"),
    Song(
        songName: 'Exit Sign',
        artistName: "HIEUTHUHAI",
        albumArtImagePath: "assets/images/4.jpg",
        audioPath: "audio/Exit Sign.mp3",
        lyricsFile: "lyrics/ExitSign.lrc"),
    Song(
        songName: 'Không Thể Say',
        artistName: "HIEUTHUHAI",
        albumArtImagePath: "assets/images/2.jpg",
        audioPath: "audio/Không Thể Say.mp3",
        lyricsFile: "lyrics/Limbo.lrc"),
    Song(
        songName: 'NOLOVENOLIFE',
        artistName: "HIEUTHUHAI",
        albumArtImagePath: "assets/images/2.jpg",
        audioPath: "audio/NOLOVENOLIFE.mp3",
        lyricsFile: "lyrics/Limbo.lrc"),
  ];
  int? _currentSongIndex;
  /* Audio Player*/
//audio player
  final AudioPlayer _audioPlayer = AudioPlayer();
  get audioPlayer => this._audioPlayer;
  static const String _baseUrl =
      'http://localhost:8080/api/public/files/download/audio/d5629224-fb04-44a8-8cd6-4a52022fc3a5.mp3';

//duration
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
//constructor
  PlaylistProvider() {
    listenToDuration();
  }
//initiallity not playing

  bool _isPlaying = false;
  Future<void> play() async {
    try {
      // Stop any existing playback
      await _audioPlayer.stop();

      // Fetch audio file
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        // Save the file as a playable source (or directly stream)
        await _audioPlayer
            .play(BytesSource(response.bodyBytes)); // Use bytes directly
        _isPlaying = true;
      } else {
        debugPrint('Failed to fetch audio file: ${response.statusCode}');
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

//play the song
  // void play() async {

  //       final String path = _playlist[currentSongIndex!].audioPath;
  //   await _audioPlayer.stop();
  //   await _audioPlayer.play(AssetSource(path));

  //   _isPlaying = true;
  //   notifyListeners();
  // }
// pause current song

  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

//resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

//pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

//seek to a specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

//play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
    }
  }

//play previous song
  void playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

// list to duration
  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

//display audio player

  int? get currentSongIndex => _currentSongIndex;

  List<Song> get playlist => _playlist;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      play();
    }
    notifyListeners();
  }
}
