import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:musicapp/dto/request/register_request.dart';

import 'package:musicapp/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dto/request/login_request.dart';
// import '../services/api/user_api.dart';
import '../dto/request/user_update_request.dart';
import '../services/api/user_api2222.dart';
import '../shared_preference/share_preference_service.dart';

class UserProvider with ChangeNotifier {
  final UserApi _userApi = UserApi();
  final SharedPreferencesService _prefsService = SharedPreferencesService();
  User? _currentUser;
  // List<User> _users = [];
  // List<User> _artists = [];
  bool _isLoggedIn = false;
  get isLoggedIn => _isLoggedIn;
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  // List<User> get users => _users;
  // List<User> get artists => _artists;

  // Fetch all users
  // void fetchUsers() {
  //   _users = _userApi.getAllUsers();
  //   notifyListeners();
  // }

  // Fetch all artists
  // void fetchArtists() {
  //   _artists = _userApi.getArtists();
  //   notifyListeners();
  // }

  // Find user by ID
  // void findUser(String id) {
  //   final user = _userApi.findUserById(id);
  //   if (user != null) {
  //     _currentUser = user;
  //     notifyListeners();
  //   }
  // }

  Future<bool> login(LoginRequest request, BuildContext context) async {
    try {
      // Making the login request
      final loginResponse = await _userApi.login(request, context);

      if (loginResponse != null) {
        final token = loginResponse.token;
        final userId = loginResponse.user.id;
        final user = await _userApi.fetchUserData(userId!, context);
        // Save token and userId to SharedPreferences
        await _prefsService.saveFullUserToPreferences(user!);
        await _prefsService.saveToken(token);

        final savedToken = await _prefsService.getToken();
        if (savedToken != null && savedToken.isNotEmpty) {
          print('Token saved successfully');
        } else {
          print('Failed to save token');
        }

        // Fetch user data after successful login

        // Save user data to preferences and set current user

        _currentUser = await _prefsService.getUserFromPreferences();
        _isLoggedIn = true;
        notifyListeners();

        return true;
      } else {
        return false;
      }
    } catch (error) {
      // Log the error and handle it
      _isLoggedIn = false;

      print('Login error: $error');

      // Check for specific network error
      if (error is ClientException) {
        print(
            'Network error: Unable to connect to server. Check your API URL.');
      } else if (error is SocketException) {
        print('Network error: No internet connection.');
      } else {
        print('Unknown error: $error');
      }

      return false;
    }
  }

  Future<void> fetchUserData(BuildContext context) async {
    try {
      final user = await _prefsService.getUserFromPreferences();
      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;
        notifyListeners();
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> signOut() async {
    await _prefsService.clear();
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> _fetchCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    if (username != null) {
      _currentUser = User(
        id: prefs.getInt('id') ?? 0, // Assuming 'id' is an integer
        username: username,
        email: prefs.getString('email') ?? '',
        phone: prefs.getString('phone') ?? '',
        avatar: prefs.getString('avatar'),
      );
      notifyListeners();
    }
  }

  Future<bool> register(RegisterRequest request, BuildContext context) async {
    return await _userApi.register(request, context);
  }

  // Login user
  // Future<bool> login(String username, String password) async {
  //   final success = await _userApi.login(username, password);
  //   if (success) {
  //     // Await the result of fetchCurrentUser() to get the actual user data
  //     _currentUser = await _userApi.fetchCurrentUser();
  //     notifyListeners();
  //   }
  //   return success;
  // }

  Future<void> checkLoginStatus() async {
    final token = await _prefsService.getToken();
    if (token != null) {
      _isLoggedIn = true;
      _currentUser = await _prefsService.getUserFromPreferences();
      print("Current User: $_currentUser");
    } else {
      _isLoggedIn = false;
      _currentUser = null;
    }
    notifyListeners();
  }

  Future<bool> editUserInfoByPart(
      UpdateUserWithAttribute requestData, BuildContext context) async {
    try {
      // Set loading state
      // _isLoading = true;
      // notifyListeners();

      // Call the API to edit the user information
      bool success = await _userApi.editUserInfoByPart(requestData, context);

      // If the update is successful, update the user data
      if (success) {
        // Optionally, fetch the updated user data if needed
        final updateUser =
            await _userApi.fetchUserData(requestData.id, context);
        await _prefsService.saveFullUserToPreferences(updateUser!);
        // await fetchUserData(context);
      }

      // Set loading state to false and notify listeners
      // _isLoading = false;
      // notifyListeners();

      return success;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error during update: $e');
      return false;
    }
  }

  Future<bool> changeUserPassword(
      UpdateUserPassword requestData, BuildContext context) async {
    try {
      // Set loading state
      _isLoading = true;
      notifyListeners();

      // Call the API to edit the user information
      bool success = await _userApi.changeUserPassword(requestData, context);

      // If the update is successful, update the user data
      if (success) {
        // // Optionally, fetch the updated user data if needed
        // _currentUser = await _userApi.fetchUserData(requestData.id, context);
        _prefsService.clear();
      }

      // Set loading state to false and notify listeners
      _isLoading = false;
      notifyListeners();

      return success;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error during update: $e');
      return false;
    }
  }
}
