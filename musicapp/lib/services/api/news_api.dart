import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:musicapp/services/api/api.dart';
import 'package:musicapp/services/api/urlConsts.dart';

import '../../models/news.dart';

class NewsApi extends Api {
  Future<List<News>> fetchNews(BuildContext context) async {
    final response = await get(UrlConsts.NEWS, context);
    if (response.statusCode == 200) {
      // Nếu API trả về dữ liệu thành công
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => News.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<News> fetchNewsById( int id,BuildContext context) async {
    var response = await get('${UrlConsts.NEWS}/$id', context);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return News.fromJson(data);
    } else {
      throw Exception('Failed to load genre with id $id');
    }
  }
}
