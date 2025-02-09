import 'package:flutter/material.dart';
import '../models/genre.dart';
import '../services/api/genre_api.dart';

class GenreProvider with ChangeNotifier {
  final GenreApi apiService;
  List<Genre> _items = [];
  bool _isLoading = false;
  String? _errorMessage;
  int? _genreId;
  Future<List<Genre>>? _loadItemsFuture;
  int? get genreId => _genreId;

  void setGenreId(int id) {
    _genreId = id;
    notifyListeners();
  }

  // Getter methods to access the state
  List<Genre> get items => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Constructor for injecting the GenreApi service
  GenreProvider(this.apiService);

  // Method to load the list of items (genres)
  // Future<List<Genre>> loadItems(BuildContext context) async {
  //   if (_isLoading) return _items; // Ngăn chặn nhiều lần tải cùng lúc

  //   _isLoading = true;
  //   _errorMessage = null;

  //   try {
  //     _items = await apiService.fetchItems(context);
  //     return _items; // Trả về danh sách đã tải
  //   } catch (e) {
  //     _errorMessage = 'Failed to load genres: $e';
  //     return []; // Trả về danh sách trống nếu có lỗi
  //   } finally {
  //     _isLoading = false;
  //   }
  // }
   Future<List<Genre>> loadItems(BuildContext context) {
    // Trả về Future đã tồn tại để tránh gọi lại nhiều lần
    if (_loadItemsFuture != null) return _loadItemsFuture!;

    _loadItemsFuture = _fetchItems(context);
    return _loadItemsFuture!;
  }

  Future<List<Genre>> _fetchItems(BuildContext context) async {
    try {
      _items = await apiService.fetchItems(context);
      return _items;
    } catch (e) {
      _errorMessage = 'Failed to load genres: $e';
      return [];
    }
  }

  // Method to get a single genre by its ID
  Future<Genre?> getItemById(int id, BuildContext context) async {
    try {
      return await apiService.fetchItemById(id, context);
    } catch (e) {
      _errorMessage = 'Failed to load genre with ID $id: $e';
      return null; // Trả về null khi có lỗi
    }
  }
}
