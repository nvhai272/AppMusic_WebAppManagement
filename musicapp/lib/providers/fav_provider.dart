import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:musicapp/providers/album_provider.dart';
import 'package:provider/provider.dart';

import '../dto/request/like_request.dart';
import '../services/api/favourite_api.dart';
import 'song_provider.dart';
// Ensure you import UserFavoritesAPI

class UserFavoritesProvider with ChangeNotifier {
  final UserFavoritesAPI _userFavService = UserFavoritesAPI();
  bool _isLoading = false;
  String _errorMessage = '';
  List<int> _favoriteSongIds = []; // Store the favorite song IDs
  List<int> _favoriteAlbumIds = []; // Store the favorite album IDs

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<int> get favoriteSongIds => _favoriteSongIds;
  List<int> get favoriteAlbumIds => _favoriteAlbumIds;

  // Add a song to user favorites
  Future<void> addUserFavoriteSong(
      SongLikeRequest requestData, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Check if the song is already in favorites before adding
      bool isLiked =
          await _userFavService.checkIfSongIsLiked(requestData, context);

      if (!isLiked) {
        // If song is not already liked, add to favorites
        await _userFavService.likeSong(context, requestData);
        _favoriteSongIds.add(requestData.itemId); // Update local list
        _likedSongs[requestData.itemId] = true; // Update cache for song
      } else {
        _errorMessage = 'Song is already in your favorites!';
      }
    } catch (error) {
      _errorMessage = 'Failed to add song to favorites: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Remove a song from user favorites
  Future<void> removeUserFavoriteSong(
      SongLikeRequest requestData, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Call API to remove from favorites
      await _userFavService.unlikeSong(context, requestData);
      _favoriteSongIds.remove(requestData.itemId); // Update local list
      _likedSongs[requestData.itemId] = false; // Update cache for song
    } catch (error) {
      _errorMessage = 'Failed to remove song from favorites: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<int, bool> _likedSongs = {}; // Cache for liked songs

  // Method to check if a song is liked (synchronously)
  bool isFavouriteSong(SongLikeRequest requestData) {
    return _likedSongs[requestData.itemId] ??
        false; // Return cached value or false if not found
  }

  // Fetch favorite status of a song asynchronously and update the cache
  Future<void> fetchFavoriteSongStatus(
      SongLikeRequest requestData, BuildContext context) async {
    bool isLiked =
        await _userFavService.checkIfSongIsLiked(requestData, context);

    // Update the cache with the result
    _likedSongs[requestData.itemId] = isLiked;

    // Update local list (in case of multiple sources of truth)
    if (isLiked) {
      _favoriteSongIds.add(requestData.itemId);
    } else {
      _favoriteSongIds.remove(requestData.itemId);
    }

    // Notify listeners that the data has changed
    notifyListeners();
  }

  // Optionally, a method to clear the cache
  void clearSongCache() {
    _likedSongs.clear();
    notifyListeners();
  }

  // Similar logic for album favorites
  Future<void> addUserFavoriteAlbum(
      SongLikeRequest requestData, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool isLiked =
          await _userFavService.checkIfAlbumIsLiked(requestData, context);

      if (!isLiked) {
        await _userFavService.addAlbumToFavorites(requestData, context);
        _favoriteAlbumIds.add(requestData.itemId); // Update local list
        _likedAlbums[requestData.itemId] = true; // Update cache for album
      } else {
        _errorMessage = 'Album is already in your favorites!';
      }
    } catch (error) {
      _errorMessage = 'Failed to add album to favorites: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Remove an album from user favorites
  Future<void> removeUserFavoriteAlbum(
      SongLikeRequest requestData, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _userFavService.removeAlbumFromFavorites(requestData, context);
      _favoriteAlbumIds.remove(requestData.itemId); // Update local list
      _likedAlbums[requestData.itemId] = false; // Update cache for album
      await Provider.of<AlbumProvider>(context, listen: false)
          .fetchLikedAlbums(context);
    } catch (error) {
      _errorMessage = 'Failed to remove album from favorites: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<int, bool> _likedAlbums = {}; // Cache for liked albums

  // Method to check if an album is liked (synchronously)
  bool isFavouriteAlbum(SongLikeRequest requestData) {
    return _likedAlbums[requestData.itemId] ??
        false; // Return cached value or false if not found
  }

  // Fetch favorite status of an album asynchronously and update the cache
  Future<void> fetchFavoriteAlbumStatus(
      SongLikeRequest requestData, BuildContext context) async {
    bool isLiked =
        await _userFavService.checkIfAlbumIsLiked(requestData, context);

    // Update the cache with the result
    _likedAlbums[requestData.itemId] = isLiked;

    // Update local list (in case of multiple sources of truth)
    if (isLiked) {
      _favoriteAlbumIds.add(requestData.itemId);
    } else {
      _favoriteAlbumIds.remove(requestData.itemId);
    }

    // Notify listeners that the data has changed
    notifyListeners();
  }

  // Optionally, a method to clear the cache
  void clearAlbumCache() {
    _likedAlbums.clear();
    notifyListeners();
  }
}
