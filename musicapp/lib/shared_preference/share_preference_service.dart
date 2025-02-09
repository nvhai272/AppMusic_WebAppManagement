import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/user.dart';

class SharedPreferencesService {
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('jwt_token', token);
    print(token);
  }

  Future<DateTime?> getTokenExpiryDate() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        print("Không có token để kiểm tra thời gian hết hạn.");
        return null;
      }

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      if (decodedToken.containsKey('exp')) {
        int exp = decodedToken['exp'];
        final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
        print("Thời gian hết hạn của token: $expiryDate");
        return expiryDate;
      }
      print("Token không chứa thông tin hết hạn (exp).");
      return null;
    } catch (e) {
      print("Lỗi khi kiểm tra thời gian hết hạn của token: $e");
      return null;
    }
  }

  Future<bool> isTokenValid() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        print("Token không tồn tại hoặc rỗng.");
        return false; // Không có token
      }

      // Lấy thời gian hết hạn của token
      DateTime? expiryDate = await getTokenExpiryDate();
      if (expiryDate == null) {
        print("Không thể xác định thời gian hết hạn của token.");
        return false;
      }

      // Lấy thời gian hiện tại
      DateTime currentDate = DateTime.now();

      // So sánh thời gian hiện tại với thời gian hết hạn của token
      if (currentDate.isAfter(expiryDate)) {
        print(
            "Token đã hết hạn. Thời gian hiện tại: $currentDate, Thời gian hết hạn: $expiryDate");
        return false; // Token hết hạn
      } else {
        print(
            "Token còn hợp lệ. Thời gian hiện tại: $currentDate, Thời gian hết hạn: $expiryDate");
        return true; // Token hợp lệ
      }
    } catch (e) {
      print("Lỗi khi kiểm tra tính hợp lệ của token: $e");
      return false; // Xử lý lỗi khi kiểm tra token
    }
  }

  // Future<bool> isTokenValid() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('jwt_token');
  //   final expiryTime = prefs.getInt('token_expiry_time');

  //   if (token == null || token.isEmpty || expiryTime == null) {
  //     print("Token không tồn tại hoặc đã hết hạn.");
  //     return false;
  //   }

  //   // Lấy thời gian hiện tại (UTC)
  //   final nowUtc = DateTime.now().toUtc();

  //   print("Thời gian hiện tại (UTC): $nowUtc");
  //   print(
  //       "Thời điểm hết hạn (UTC): ${DateTime.fromMillisecondsSinceEpoch(expiryTime, isUtc: true)}");

  //   // So sánh thời gian hiện tại với thời điểm hết hạn
  //   if (nowUtc.millisecondsSinceEpoch > expiryTime) {
  //     print("Token đã hết hạn.");
  //     await clear();
  //     return false;
  //   }
  //   bool isExpired = JwtDecoder.isExpired(token);
  //   if (isExpired) {
  //     print("Token đã hết hạn theo payload.");
  //     return false;
  //   }
  //   print("Token hợp lệ.");
  //   return true;
  // }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.remove('token_expiry_time');
  }

  // Future<void> saveUserToPreferences(User user) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt('id', user.id!);
  //   await prefs.setString('username', user.username!);
  //   await prefs.setString('email', user.email!);
  //   await prefs.setString('phone', user.phone!);
  //   await prefs.setString(
  //       'avatar', user.avatar ?? ''); // Store avatar if available
  // }

  Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', userId); // Save user ID to preferences
  }

  // Retrieve the user ID from SharedPreferences
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id');
  }

  Future<void> saveFullUserToPreferences(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', user.id!);
    await prefs.setString('username', user.username!);
    await prefs.setString('fullname', user.fullName!);
    await prefs.setString('dob', user.dob!.toIso8601String());

    await prefs.setString('email', user.email!);
    await prefs.setString('phone', user.phone!);
    await prefs.setString(
        'avatar', user.avatar ?? ''); // Store avatar if available
  }

  Future<User?> getUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Lấy thông tin người dùng từ SharedPreferences
    final int? id = prefs.getInt('id');
    final String? username = prefs.getString('username');
    final String? fullname = prefs.getString('fullname');
    final String? dob = prefs.getString('dob');
    final String? email = prefs.getString('email');
    final String? phone = prefs.getString('phone');
    final String? avatar = prefs.getString('avatar');

    if (id != null &&
        username != null &&
        email != null &&
        phone != null &&
        fullname != null &&
        dob != null) {
      // Tạo đối tượng User từ dữ liệu lấy được
      return User(
        id: id,
        username: username,
        fullName: fullname,
        dob: DateTime.parse(dob),
        email: email,
        phone: phone,
        avatar: avatar, // Avatar có thể là null
      );
    }

    // Trả về null nếu không có thông tin người dùng trong SharedPreferences
    return null;
  }
  // Add other methods as needed for user data or other preferences
}
