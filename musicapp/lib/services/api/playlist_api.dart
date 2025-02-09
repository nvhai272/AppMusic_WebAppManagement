import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:musicapp/dto/request/playlist_request.dart';
import 'package:musicapp/dto/response/playlist_response.dart';
import 'package:musicapp/dto/response/song_response.dart';
import 'package:musicapp/services/api/api.dart';
import 'package:musicapp/services/api/urlConsts.dart';

import '../../models/playlist_song.dart';
import '../../shared_preference/share_preference_service.dart';

class PlaylistApi extends Api {
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  Future<List<PlaylistResponse>> fetchPlaylistByUser(
      BuildContext context) async {
    final int? userId = await _prefsService.getUserId();
    final response = await get('${UrlConsts.USERPLAYLIST}/$userId', context);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => PlaylistResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load songs for user $userId');
    }
  }

 Future<List<PlaylistSong>> fetchPlaylistSongs(
    BuildContext context, int playlistId) async {
  final response =
      await get('${UrlConsts.PLAYLISTSONGS}/$playlistId', context);

  if (response.statusCode == 200) {
    // Decode the response as a single map, not a list
    Map<String, dynamic> data = jsonDecode(response.body);

    // Create a list containing the single PlaylistSong object
    List<PlaylistSong> playlistSongs = [PlaylistSong.fromJson(data)];

    return playlistSongs;
  } else {
    throw Exception('Failed to fetch songs for playlist $playlistId');
  }
}


  Future<void> deletePlaylist(BuildContext context, int playlistId) async {
    // Replace with your actual API call to delete the playlist
    final response =
        await delete('${UrlConsts.PLAYLISTBYUSER}/$playlistId', context, null);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete playlist');
    }
  }

  Future<void> addPlayListByCurrentUser(
      BuildContext context, PlaylistRequest request) async {
    try {
      // Use the provided `request` object directly
      final response = await post(
        UrlConsts.PLAYLISTBYUSER, // Path to your API endpoint
        request.toJson(), // Convert the request object to JSON
        context,
      );

      // Handle the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to add playlist: ${response.statusCode}')),
        );
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<List<SongResponse>> fetchItemsInPlaylist(
      int playlistId, BuildContext context) async {
    var response = await get('${UrlConsts.USERPLAYLIST}/$playlistId', context);

    // Check if the response is successful
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SongResponse.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load song in playlist');
    }
  }
}
