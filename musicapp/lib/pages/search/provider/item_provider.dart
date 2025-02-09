import 'package:flutter/material.dart';

import '../api/mock_api.dart';
import '../model/item.dart';

class ItemProvider with ChangeNotifier {
  List<Item> _items = [];
  bool _isLoading = false;

  List<Item> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> searchItems(String query) async {
    _isLoading = true;
    // Đảm bảo notifyListeners() không bị gọi trong quá trình xây dựng
    await Future.delayed(
        Duration(milliseconds: 100)); // Trì hoãn trước khi gọi notifyListeners
    notifyListeners();

    // Fetch search results
    final searchResults = await MockApi().searchItems(query);

    if (searchResults.isNotEmpty) {
      _items = searchResults; // Cập nhật _items với kết quả tìm kiếm
    } else {
      _items = []; // Nếu không có kết quả, làm trống danh sách
    }

    _isLoading = false;

    // Chỉ gọi notifyListeners() sau khi tất cả đã hoàn tất
    notifyListeners();
  }

  Future<void> fetchItems() async {
    _isLoading = true;
    notifyListeners();

    _items = await MockApi().fetchItems();

    _isLoading = false;
    notifyListeners();
  }
   void clearItems() {
    _items = [];
    notifyListeners();
  }
}
