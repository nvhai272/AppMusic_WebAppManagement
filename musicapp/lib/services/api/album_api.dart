import 'dart:async';
import 'package:flutter/cupertino.dart';

import 'dart:convert'; // For json.decode
import '../../dto/response/album_response.dart';
import '../../shared_preference/share_preference_service.dart';
import 'api.dart';
import 'urlConsts.dart'; // For http.get

class AlbumApi extends Api {
  final SharedPreferencesService _prefsService = SharedPreferencesService();
  Future<List<AlbumResponse>> fetchItems(BuildContext context) async {
    final response = await get(UrlConsts.ALBUMS, context);

    // Check if the response is successful
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => AlbumResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load albums');
    }
  }

  Future<List<AlbumResponse>> fetchItemByKeyWord(
      String keyword, BuildContext context) async {
    final response =
        await getSearch('${UrlConsts.ALBUMS}/search/$keyword', context);

    // Check if the response is successful
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => AlbumResponse.fromJson(item)).toList();
    } else {
      return [];
      // throw Exception('Failed to load album with keyword $keyword');
    }
  }

  Future<List<AlbumResponse>> fetchFavAlbumOfUser(BuildContext context) async {
    final int? userId = await _prefsService.getUserId();
    final response =
        await get('${UrlConsts.ALBUMS}/byUser/display/$userId', context);

    // Check if the response is successful
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => AlbumResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load albums with id $userId');
    }
  }
}
