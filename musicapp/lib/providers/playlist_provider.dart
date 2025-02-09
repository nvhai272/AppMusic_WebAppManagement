import 'package:flutter/material.dart';
import 'package:musicapp/dto/request/playlist_request.dart';
import 'package:musicapp/services/api/playlist_api.dart';

import '../dto/response/playlist_response.dart';

class PlaylistProvider extends ChangeNotifier {
  final PlaylistApi _playlistApi = PlaylistApi();
  List<PlaylistResponse> _playlists = [];

  List<PlaylistResponse> get playlists => _playlists;

  Future<void> fetchPlaylists(BuildContext context) async {
    try {
      final playlists = await PlaylistApi().fetchPlaylistByUser(context);
      _playlists = playlists;

      notifyListeners(); // Notify listeners when the data changes
    } catch (e) {
      print('Error fetching playlists: $e');
    }
  }

  /// Add a new playlist for the current user
  Future<void> addPlaylist(
      BuildContext context, PlaylistRequest request) async {
    try {
      await _playlistApi.addPlayListByCurrentUser(context, request);
      await fetchPlaylists(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Playlist added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add playlist: $e')),
      );
    }
  }

  Future<void> deletePlaylist(BuildContext context,
      PlaylistProvider playlistProvider, int playlistId) async {
    try {
      // Call your API or service to delete the playlist by its ID
      await PlaylistApi().deletePlaylist(context, playlistId);

      // Update the provider to remove the playlist from the list
      playlistProvider.fetchPlaylists(context);

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Playlist deleted successfully")),
      );
    } catch (e) {
      // Show error message if deletion fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete playlist: $e")),
      );
    }
  }
}
