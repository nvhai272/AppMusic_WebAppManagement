import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:musicapp/pages/home.dart';
import 'package:musicapp/providers/user_provider.dart';
import 'signup_page.dart';
import '../dto/request/login_request.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(),
              const SizedBox(height: 20),
              _buildLoginForm(),
            ],
          ),
        ),
      ),
    );
  }

  // Build Logo Widget
  Widget _buildLogo() {
    return Container(
      width: 800,
      height: 200,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/musicix3.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Build Login Form Widget
  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildUsernameField(),
          const SizedBox(height: 20),
          _buildPasswordField(),
          const SizedBox(height: 10),
          _buildSignUpLink(),
          const SizedBox(height: 20),
          _buildLoginButton(),
        ],
      ),
    );
  }

  // Build Username Input Field
  Widget _buildUsernameField() {
    return TextField(
      controller: _usernameController,
      decoration: const InputDecoration(
        labelText: "Tên Đăng Nhập",
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2.0),
        ),
      ),
    );
  }

  // Build Password Input Field
  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        labelText: "Mật Khẩu",
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
    );
  }

  // Build Sign Up Link
  Widget _buildSignUpLink() {
    return Wrap(
       alignment: WrapAlignment.center,
      children: [
        const Text(
          "Bạn chưa có tài khoản?",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpPage()),
            );
          },
          child: const Text(
            "Tạo tài khoản mới",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // Build Login Button
  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: const Size.fromHeight(50),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
              "Đăng Nhập",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
    );
  }

  // Login function
  Future<void> _login() async {
    // final SharedPreferencesService _prefsService = SharedPreferencesService();
    // final token = await _prefsService.getToken();
    // if (token != null) {
    //   final expiryTime =
    //       JwtDecoder.getExpirationDate(token).millisecondsSinceEpoch;
    //   final prefs = await SharedPreferences.getInstance();
    //   await prefs.setInt('token_expiry_time', expiryTime); // Save expiry time
    // }
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog("Vui lòng nhập đầy đủ thông tin.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final loginRequest = LoginRequest(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
    );

    try {
      bool loginSuccess = await userProvider.login(loginRequest, context);
      if (loginSuccess) {
        _showSuccessDialog("Đăng nhập thành công!");
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        });
      } else {
        _showErrorDialog("Tên đăng nhập hoặc mật khẩu không chính xác.");
      }
    } catch (e) {
      _showErrorDialog("Đã xảy ra lỗi: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Show Error Dialog
  void _showErrorDialog(String message) {
    _showDialog("Lỗi", message);
  }

  // Show Success Dialog
  void _showSuccessDialog(String message) {
    _showDialog("Thành công", message);
  }

  // General Dialog Method
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Đóng"),
            ),
          ],
        );
      },
    );
  }
}
