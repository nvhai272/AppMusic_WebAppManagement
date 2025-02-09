import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:musicapp/dto/response/playlist_response.dart';
import 'package:musicapp/services/api/favourite_api.dart';
import 'package:musicapp/services/api/playlist_api.dart';
import 'package:musicapp/services/api/song_api.dart';

import '../dto/request/like_request.dart';
import '../dto/request/playlist_song_request.dart';
import '../dto/response/song_response.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

import '../models/playlist_song.dart';
import '../shared_preference/share_preference_service.dart';

class SongProvider with ChangeNotifier {
  final SharedPreferencesService _prefsService = SharedPreferencesService();
  final SongApi _songApi = SongApi();
  final UserFavoritesAPI _favoritesAPI = UserFavoritesAPI();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<SongResponse> _songs = [];
  List<SongResponse> _playingSongs = [];

  bool _isLoading = false;
  int? _currentSongIndex;
  bool _isPlaying = false;
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  SongResponse? get currentSong {
    if (_currentSongIndex != null &&
        _currentSongIndex! >= 0 &&
        _currentSongIndex! < _playingSongs.length) {
      return _playingSongs[_currentSongIndex!];
    }
    return null;
  }

  bool shouldShow() {
    return isAudioCardVisible;
  }

  bool _isAudioCardVisible = false;

  bool get isAudioCardVisible => _isAudioCardVisible;

  void toggleAudioCardVisibility() {
    _isAudioCardVisible = !_isAudioCardVisible;
    notifyListeners();
  }

  final List<int> _likedSongs = [];
  final List<int> _hiddenSongs = [];

  // List<SongResponse> _favoriteSongs = [];
  // List<SongResponse> get favoriteSongs => _favoriteSongs;
  // Getter for liked songs list
  List<int> get likedSongs => _likedSongs;

  // Check if a song is liked
  bool isLiked(int songId) => _likedSongs.contains(songId);

  // Fetch liked songs from the database
  Future<void> fetchLikedSongs(BuildContext context) async {
    var userId = await _prefsService.getUserId();

    if (userId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("User not logged in")));
      return;
    }

    setLoading(true);

    try {
      // Lấy danh sách bài hát yêu thích từ API một lần
      _songs = await _songApi.fetchFavSongOfUser(context);
      print('Fetched favorite songs: $_songs');
      // Cập nhật danh sách bài hát yêu thích trong bộ nhớ
      _likedSongs.clear();
      _likedSongs.addAll(_songs.map((song) => song.id).toList());

      notifyListeners(); // Cập nhật UI
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch liked songs: $e')),
      );
    } finally {
      setLoading(false);
    }
  }

  // Toggle like status
  Future<void> toggleLikeStatus(BuildContext context, int songId) async {
    var userId = await _prefsService.getUserId();

    if (userId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("User not logged in")));
      return;
    }

    final request = SongLikeRequest(
      itemId: songId,
      userId: userId,
    );

    try {
      // Kiểm tra bài hát có được yêu thích hay không
      bool isCurrentlyLiked =
          await _favoritesAPI.checkIfSongIsLiked(request, context);

      if (isCurrentlyLiked) {
        // Nếu bài hát đã được yêu thích, bỏ thích
        await _songApi.unlikeSong(context, request);

        _likedSongs.remove(songId); // Xóa bài hát khỏi danh sách yêu thích
      } else {
        // Nếu bài hát chưa được yêu thích, thêm vào danh sách yêu thích
        await _songApi.likeSong(context, request);
        _likedSongs.add(songId); // Thêm bài hát vào danh sách yêu thích
      }

      notifyListeners(); // Cập nhật UI
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to toggle like status: $e')),
      );
    }
  }

  // Set loading state
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<PlaylistSong> playlists = [];
  final PlaylistApi _playlistApi = PlaylistApi();

  ///add Song to play list

  Future<void> addToPlaylist(BuildContext context, SongResponse track) async {
    // Fetch playlists and show a dialog for playlist selection
    var selectedPlaylist = await _showPlaylistSelector(context);

    if (selectedPlaylist != null) {
      // Fetch the playlist songs from the API
      List<PlaylistSong> playlistSongData =
          await _playlistApi.fetchPlaylistSongs(
        context,
        selectedPlaylist.id,
      );

      // Check if the song already exists in the playlist
      // bool songExists =
      //     playlistSongData.any((song) => song.songId == track.id);

      // Create a PlaylistSongRequest object
      PlaylistSongRequest request = PlaylistSongRequest(
        playlistId: selectedPlaylist.id,
        songId: track.id,
      );

      // Call the API to add the song to the playlist
      await _songApi.addSongToPlaylistByUser(context, request);

      notifyListeners(); // Update UI
    }
  }

// This function shows a dialog for playlist selection
  Future<PlaylistResponse?> _showPlaylistSelector(BuildContext context) async {
    try {
      // Gọi API để lấy danh sách playlist
      List<PlaylistResponse> fetchedPlaylists =
          await _playlistApi.fetchPlaylistByUser(context);

      if (fetchedPlaylists.isEmpty) {
        // Nếu không có playlist, hiển thị thông báo
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No playlists available')),
        );
        return null;
      }

      // Hiển thị dialog với danh sách playlist
      return showDialog<PlaylistResponse>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select a Playlist'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: fetchedPlaylists.map((playlist) {
                  return ListTile(
                    title: Text(playlist.title ?? 'Untitled Playlist'),
                    onTap: () {
                      Navigator.pop(
                          context, playlist); // Trả về playlist được chọn
                    },
                  );
                }).toList(),
              ),
            ),
          );
        },
      );
    } catch (e) {
      // Xử lý lỗi khi fetch API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching playlists: $e')),
      );
      return null;
    }
  }

  // String? _sourcePath;
  // bool _isLocal = false;
  //   void setAudioDetails(String sourcePath, {bool isLocal = false}) {
  //   _sourcePath = sourcePath;
  //   _isLocal = isLocal;
  //   notifyListeners();
  // }
  // Getters
  Uint8List? _songImage;
  Uint8List? get songImage => _songImage;

  List<SongResponse> get songs => _songs;
  List<SongResponse> get playingSongs => _playingSongs;
  bool get isLoading => _isLoading;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
  get audioPlayer => this._audioPlayer;
  static const String _baseAudioUrl =
      'http://localhost:8080/api/files/download/audio/';
  void setCurrentSongIndex(int index) {
    currentSongIndex = index;
    notifyListeners(); // Cập nhật UI
  }

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    // if (newIndex != null) {
    //   play();
    // }
    notifyListeners();
  }

  SongProvider() {
    listenToDuration();
  }

  Future<void> fetchSongsByPlaylist(
      int playlistId, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      _songs = await _songApi.fetchSongsByPlaylist(playlistId, context);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching songs: $e');
    } finally {
      _isLoading = false;
    }
  }

  Future<void> fetchSongsByGenre(int genreId, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      _songs = await _songApi.fetchSongsByGenre(genreId, context);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching songs: $e');
    } finally {
      _isLoading = false;
    }
  }

  Future<void> listenSong(int songId) async {
    try {
      await _songApi.listen(songId);
    } catch (e) {
      debugPrint('Error fetching songs: $e');
    }
  }

  ///album
  Future<void> fetchSongsByAlbum(int albumId, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      _songs = await _songApi.fetchSongsByAlbum(albumId, context);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching songs: $e');
    } finally {
      _isLoading = false;
    }
  }
  // Future<List<SongResponse>> fetchSongsByGenre(
  //     int genreId, BuildContext context) async {
  //   _isLoading = true;

  //   try {
  //     _songs = await _songApi.fetchSongsByGenre(genreId, context);
  //     return _songs; // Explicitly return the list of songs
  //   } catch (e) {
  //     print('Error fetching songs: $e');
  //     return []; // Return an empty list in case of an error
  //   } finally {
  //     _isLoading = false;
  //   }
  // }

  // Play and shuffle functions
  void shuffleAndPlay() {
    _moveSongsFromApiToCurrentList();
    if (_playingSongs.isEmpty) return;
    currentSongIndex = Random().nextInt(_playingSongs.length);
    play(isCalledFromUI: false);
  }

  void _moveSongsFromApiToCurrentList() {
    _playingSongs = _songs;
    // _songsFromApi.clear();
  }
  // Play audio (local/remote)
//   void play({bool isLocal = false}) async {
//     try {
//       await _audioPlayer.stop();
// // sourcePath just only = ten file
//       if (isLocal) {
//         final String sourcePath = _songs[currentSongIndex!].audioPath;
//         await _audioPlayer.stop();
//     await _audioPlayer.play(AssetSource(sourcePath));
//       } else {
//         // Phát âm thanh từ URL hoặc một nguồn từ xa
//         final audioUrl = '$_baseAudioUrl$sourcePath';
//         final response = await http.get(Uri.parse(audioUrl));
//         if (response.statusCode == 200) {
//           await _audioPlayer.play(BytesSource(response.bodyBytes));
//         } else {
//           debugPrint('Failed to fetch audio file: ${response.statusCode}');
//         }
//       }

//       _isPlaying = true;
//       notifyListeners();
//     } catch (e) {
//       debugPrint('Error playing audio: $e');
//     }
//   }
  Future<void> loadSongImage(String imagePath, BuildContext context) async {
    try {
      // Fetch the image data and store it
      final imageBytes = await _songApi.fetchImage(imagePath, context);
      _songImage = imageBytes;
      notifyListeners(); // Notify listeners to update the UI
    } catch (e) {
      debugPrint('Error fetching image: $e');
    }
  }

  Future<void> play({bool isCalledFromUI = true}) async {
    try {
      if (isCalledFromUI) {
        // _moveSongsFromApiToCurrentList();
        currentSongIndex = 0;
      }
      _moveSongsFromApiToCurrentList();
      print(
          'Current Song Index: $currentSongIndex'); // Kiểm tra giá trị của currentSongIndex
      // Stop any existing playback

      if (currentSongIndex == null) {
        debugPrint('Error: currentSongIndex is null');
        return; // Exit if no song is selected
      }
      final currentSong = _playingSongs[currentSongIndex!];
      final songId = currentSong.id;
      try {
        listenSong(songId);
        print('Song listened: ID = $songId');
      } catch (e) {
        debugPrint('Error logging song listen: $e');
      }
      await _audioPlayer.stop();
      final filename = _playingSongs[currentSongIndex!].audioPath;

      print('Playing file: $filename');
      final audioUrl = '$_baseAudioUrl$filename';
      print(audioUrl);
      // Fetch audio file
      final response = await http.get(Uri.parse(audioUrl));
      if (response.statusCode == 200) {
        // Save the file as a playable source (or directly stream)
        await _audioPlayer
            .play(BytesSource(response.bodyBytes)); // Use bytes directly
        _isAudioCardVisible = true;
        _isPlaying = true;
      } else {
        debugPrint('Failed to fetch audio file: ${response.statusCode}');
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

//play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playingSongs.length - 1) {
        _currentSongIndex = _currentSongIndex! + 1;
      } else {
        _currentSongIndex = 0;
      }
    }

    play(isCalledFromUI: false);
  }

  // Listen to duration and position changes
  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      playNextSong();
    });
  }
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
      _isAudioCardVisible = true;
      notifyListeners();
    }
    // notifyListeners();
  }

//seek to a specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

//play next song
  // void playNextSong() {
  //   if (_currentSongIndex != null) {
  //     if (_currentSongIndex! < _songs.length - 1) {
  //       currentSongIndex = _currentSongIndex! + 1;
  //     } else {
  //       currentSongIndex = 0;
  //     }
  //   }
  // }

//play previous song
  void playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        _currentSongIndex = _currentSongIndex! - 1;
      } else {
        _currentSongIndex = _playingSongs.length - 1;
      }
    }

    play(isCalledFromUI: false);
  }
}
