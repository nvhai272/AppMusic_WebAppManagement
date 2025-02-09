import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dto/request/like_request.dart';
import '../dto/response/album_response.dart';
import '../models/album.dart';
import '../services/api/album_api.dart';
import '../services/api/favourite_api.dart';
import '../shared_preference/share_preference_service.dart';

class AlbumProvider with ChangeNotifier {
  final AlbumApi _albumService = AlbumApi();
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  final UserFavoritesAPI _favoritesAPI = UserFavoritesAPI();
  List<AlbumResponse> _albumList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  List<AlbumResponse> get albumList => _albumList;
  String get errorMessage => _errorMessage;

  // AlbumProvider(this.apiService);
  final List<int> _likedAlbums = [];

  List<AlbumResponse> _favoriteAlbums = [];
  List<AlbumResponse> get favoriteAlbums => _favoriteAlbums;

  // Getter for liked albums list
  List<int> get likedAlbums => _likedAlbums;

  // Check if an album is liked
  bool isLiked(int albumId) => _likedAlbums.contains(albumId);

  // Fetch liked albums from the database
  Future<void> fetchLikedAlbums(BuildContext context) async {
    var userId = await _prefsService.getUserId();

    if (userId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("User not logged in")));
      return;
    }

    setLoading(true);

    try {
      // Fetch the liked albums from the API
      _favoriteAlbums = await _albumService.fetchFavAlbumOfUser(context);
      print('Fetched favorite albums: $_favoriteAlbums');
      // Update the liked albums list in memory
      _likedAlbums.clear();
      _likedAlbums.addAll(_favoriteAlbums.map((album) => album.id).toList());

      notifyListeners(); // Update the UI
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch liked albums: $e')),
      );
    } finally {
      setLoading(false);
    }
  }

  // Toggle like status for albums
  Future<void> toggleLikeStatus(BuildContext context, int albumId) async {
    var userId = await _prefsService.getUserId();

    if (userId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("User not logged in")));
      return;
    }

    final request = SongLikeRequest(
      itemId: albumId,
      userId: userId,
    );

    try {
      // Check if the album is currently liked
      bool isCurrentlyLiked =
          await _favoritesAPI.checkIfAlbumIsLiked(request, context);

      if (isCurrentlyLiked) {
        // If the album is already liked, remove the like
        await _favoritesAPI.removeAlbumFromFavorites(request, context);

        _likedAlbums.remove(albumId); // Remove album from liked list
 
      } else {
        // If the album is not liked, add it to the liked list
        await _favoritesAPI.addAlbumToFavorites(request, context);
        _likedAlbums.add(albumId); // Add album to liked list
        
      }

      notifyListeners(); // Update the UI
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

  // Search albums by keyword
  Future<void> searchAlbumByKeyword(
      String keyword, BuildContext context) async {
    _isLoading = true;
    _errorMessage = ''; // Reset error message
    notifyListeners();

    try {
      _albumList = await _albumService.fetchItemByKeyWord(keyword, context);
    } catch (error) {
      _errorMessage = 'Failed to fetch albums: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch favorite albums of a user
  Future<void> getFavAlbumsOfUser(BuildContext context) async {
    _isLoading = true;
    _errorMessage = ''; // Reset error message
    notifyListeners();

    try {
      _albumList = await _albumService.fetchFavAlbumOfUser(context);
    } catch (error) {
      _errorMessage = 'Failed to fetch favorite albums: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch all albums
  Future<void> fetchAllAlbums(BuildContext context) async {
    _isLoading = true;
    _errorMessage = ''; // Reset error message
    notifyListeners();

    try {
      _albumList = await _albumService.fetchItems(context);
    } catch (error) {
      _errorMessage = 'Failed to fetch all albums: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear album list
  void clearAlbums() {
    _albumList = [];
    notifyListeners();
  }
}
