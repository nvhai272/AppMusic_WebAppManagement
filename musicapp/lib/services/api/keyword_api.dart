import 'dart:async';
import 'package:flutter/cupertino.dart';

import 'dart:convert';  // For json.decode

import '../../dto/response/keyword_response.dart';
import 'api.dart';
import 'urlConsts.dart';  // For http.get

class KeywordApi extends Api {
  // final String baseUrl = "http://localhost:8080/api/public/keywords";
  Future<List<KeywordResponse>> fetchItems(BuildContext context) async {
    final response = await get(UrlConsts.KEYWORDS, context);

    // Check if the response is successful
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => KeywordResponse.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load keywords');
    }
  }
}