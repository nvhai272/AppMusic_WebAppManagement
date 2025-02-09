import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:musicapp/services/api/api.dart';
import 'package:musicapp/services/api/urlConsts.dart';

import '../../dto/request/like_request.dart';
import '../../dto/request/playlist_song_request.dart';
import '../../dto/response/song_response.dart';
import '../../shared_preference/share_preference_service.dart';

class SongApi extends Api {
  final SharedPreferencesService _prefsService = SharedPreferencesService();
  Future<List<SongResponse>> fetchSongsByGenre(
      int genreId, BuildContext context) async {
    final response = await get('${UrlConsts.SONGBYGENREID}/$genreId', context);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => SongResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load songs for genre $genreId');
    }
  }

  Future<List<SongResponse>> fetchFavSongOfUser(BuildContext context) async {
    final int? userId = await _prefsService.getUserId();
    final response = await get('${UrlConsts.FAVOURITESONG}/$userId', context);

    // Check if the response is successful
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => SongResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load favourite songs of userId $userId');
    }
  }

  Future<List<SongResponse>> fetchSongsByAlbum(
      int albumId, BuildContext context) async {
    final response = await get('${UrlConsts.SONGBYGENREID}/$albumId', context);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => SongResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load songs for album $albumId');
    }
  }

  Future<Uint8List> fetchImage(String imagePath, BuildContext context) async {
    final response = await get('${UrlConsts.IMAGE}/$imagePath', context);

    if (response.statusCode == 200) {
      // Assuming the response body contains the image in binary format
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<void> likeSong(BuildContext context, SongLikeRequest request) async {
    try {
      final response = await post(UrlConsts.LIKESONG, request, context);

      final message = jsonDecode(response.body)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to like song: $e')),
      );
    }
  }

  Future<void> unlikeSong(BuildContext context, SongLikeRequest request) async {
    try {
      final response = await delete(UrlConsts.UNLIKESONG, context, request);
      final message = jsonDecode(response.body)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to unlike song: $e')),
      );
    }
  }

  Future<void> addSongToPlaylistByUser(
      BuildContext context, PlaylistSongRequest request) async {
    try {
      // Use the provided `request` object directly
      final response = await post(
        UrlConsts.ADDTOPLAYLIST, // Path to your API endpoint
        request.toJson(), // Convert the request object to JSON
        context,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Show the message from the API response if successful
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Song added successfully')),
        );
      }
    } catch (e) {
      // If the status is 400, use the message from the response
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Song already exists in playlist')),
      );

      // Handle exceptions
    }
  }

  Future<void> listen(int id) async {
    try {
      final response = await put('${UrlConsts.LISTENSONG}/$id', null);
      final message = jsonDecode(response.body)['message'];
    } catch (e) {
      print("Loi roi, heeheehe");
    }
  }

  Future<List<SongResponse>> fetchSongsByPlaylist(
      int playlistId, BuildContext context) async {
    final response =
        await get('${UrlConsts.SONGBYPLAYLIST}/$playlistId', context);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => SongResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load songs for album $playlistId');
    }
  }
}
