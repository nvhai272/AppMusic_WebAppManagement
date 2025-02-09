import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../dto/request/like_request.dart';
import 'api.dart';
import 'urlConsts.dart';

class UserFavoritesAPI extends Api {
  // API to check if a song is already liked by the user
  Future<bool> checkIfSongIsLiked(
      SongLikeRequest requestData, BuildContext context) async {
    final String url =
        '${UrlConsts.FAVOURITE_SONGS}/check'; // Ensure the URL is correct

    try {
      // Sending POST request to check if song is liked
      final response = await post(
          url, requestData, context); // Correctly calling the `post` method

      if (response.statusCode == 200) {
        // Assuming the response is a JSON containing 'isLike'
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['isLike'] ??
            false; // Return the "isLike" status, default to false if null
      } else {
        print(
            "Failed to check if song is liked. Status code: ${response.statusCode}");
        return false; // Return false if there's an error
      }
    } catch (e) {
      print("Error checking song like status: $e");
      return false; // Return false in case of exception
    }
  }

  // API to add a song to the user's favorites
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

  Future<bool> checkIfAlbumIsLiked(
      SongLikeRequest requestData, BuildContext context) async {
    final String url = '${UrlConsts.FAVOURITE_ALBUMS}/check';

    // LikeRequest requestData = LikeRequest(userId: userId, itemId: albumId);

    // Sending POST request to check if song is liked
    final response = await post(url, requestData, context);

    // Check the response from API
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['isLike']; // Return the "isLike" status
    } else {
      print('Request Data: ${json.encode(requestData)}');
      print("responseStatus: ${response.statusCode}");
      print("Failed to check if album is liked. Error: ${response.body}");
      return false; // Return false if there's an error
    }
  }

  // API to add a album to the user's favorites
  Future<void> addAlbumToFavorites(
      SongLikeRequest requestData, BuildContext context) async {
    // Check if the song is already liked by the user
    bool isLiked = await checkIfAlbumIsLiked(requestData, context);

    if (isLiked) {
      print(
          "Album with ID ${requestData.itemId} is already in the favorites list for user ${requestData.userId}.");
      return; // The song is already liked, no need to add again
    }

    final String url = '${UrlConsts.ALBUMS}/like';

    final response = await post(url, requestData, context);
    final message = jsonDecode(response.body)['message'];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    if (response.statusCode == 200) {
      print(
          "Album with ID ${requestData.itemId} added to favorites for user ${requestData.userId}.");
    } else {
      print("Failed to add album to favorites. Error: ${response.body}");
    }
  }

  Future<void> removeAlbumFromFavorites(
      SongLikeRequest requestData, BuildContext context) async {
    final String url = '${UrlConsts.ALBUMS}/unlike'; // Your API endpoint

    try {
      // Send the DELETE request with the request body
      final response = await delete(url, context, requestData);
      final message = jsonDecode(response.body)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      if (response.statusCode == 200) {
        print(
            "Album with ID ${requestData.itemId} removed from favorites for user ${requestData.userId}.");
      } else {
        print("Failed to remove album from favorites. Error: ${response.body}");
      }
    } catch (error) {
      print("Error during removal: $error");
    }
  }
}



  // Future<void> removeAlbumFromFavorites(LikeRequest requestData, BuildContext context) async {
  //   final String url = 'http://${UrlConsts.HOST}${UrlConsts.ALBUMS}/unlike';
  //
  //   // Prepare the request data as a JSON object
  //   final Map<String, dynamic> body = {
  //     'userId': requestData.userId,
  //     'itemId': requestData.itemId,
  //   };
  //
  //   // Send DELETE request to remove the album from favorites
  //   final response = await http.delete(
  //     Uri.parse(url),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode(body), // Encode the body as JSON
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print(
  //         "Album with ID ${requestData.itemId} removed from favorites for user ${requestData.userId}.");
  //   } else {
  //     print("Failed to remove album from favorites. Error: ${response.body}");
  //   }

