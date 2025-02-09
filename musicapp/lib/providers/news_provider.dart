import 'package:flutter/material.dart';

import '../models/news.dart';
import '../services/api/news_api.dart';

class NewsProvider with ChangeNotifier {
  final NewsApi _newsApi = NewsApi();
  List<News> _newsList = [];
  bool _isLoading = false;
  String _errorMessage = '';
  News? _selectedNews; // Hold selected news by id
  Future<List<News>>? _loadItemsFuture;
  List<News> get newsList => _newsList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  News? get selectedNews => _selectedNews;
  // Future<List<News>> loadItems(BuildContext context) {
  //   if (_loadItemsFuture != null) return _loadItemsFuture!;

  //   _loadItemsFuture = _fetchNews(context);
  //   return _loadItemsFuture!;
  // }

  Future<List<News>> fetchNews(BuildContext context) async {
    try {
      _newsList = await _newsApi.fetchNews(context);
      print("Fetched news: $_newsList");
      return _newsList;
    } catch (e) {
      _errorMessage = 'Failed to load genres: $e';
      return [];
    }
  }
// Future<void> loadItems(BuildContext context) async {
//   if (_isLoading) return;

//   _isLoading = true;

//   try {
//     _newsList = await _newsApi.fetchNews(context);
//     _errorMessage = ''; // Clear any previous error
//   } catch (e) {
//     _errorMessage = 'Failed to load news: $e';
//   } finally {
//     _isLoading = false;

//   }
// }

  // Fetch a single news item by ID
  Future<News?> fetchNewsById(int id, BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();
      _selectedNews = await _newsApi.fetchNewsById(
          id, context); // Replace with your API method
      _isLoading = false;
    } catch (error) {
      _errorMessage = error.toString();
      _isLoading = false;
    } finally {
      notifyListeners();
    }
    return null;
  }
}
