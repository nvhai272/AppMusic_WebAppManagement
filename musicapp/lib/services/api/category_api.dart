import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:musicapp/dto/response/category_response.dart';
import 'package:musicapp/services/api/api.dart';
import 'package:musicapp/services/api/urlConsts.dart';

class CategoryApi extends Api{

  // Hàm gọi API và lấy danh sách category
  Future<List<CategoryResponse>> fetchCategories(BuildContext context) async {
    // API Endpoint để lấy danh sách category

    final response = await get(UrlConsts.CATEGORYALBUMS, context);

    if (response.statusCode == 200) {
      // Nếu API trả về dữ liệu thành công
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => CategoryResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

