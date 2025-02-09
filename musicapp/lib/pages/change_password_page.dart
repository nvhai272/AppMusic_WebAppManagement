import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../dto/request/user_update_request.dart';
import '../providers/user_provider.dart';
import 'login_page.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;

  final TextEditingController _oldPassController = TextEditingController();

  final TextEditingController _newPassController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  TextFormField createTextBox(
    TextEditingController txtController,
    String label,
    FormFieldValidator<String> validator, {
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: txtController,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2.0),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }

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
              const SizedBox(
                height: 20,
              ),
              _buildChangePasswordForm(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChangePasswordForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            createTextBox(
                _oldPassController, "Enter old password", validatePassword,
                obscureText: !_passwordVisible1,
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible1 ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {});
                    _passwordVisible1 = !_passwordVisible1;
                  },
                )),
            const SizedBox(height: 20),
            createTextBox(
                _newPassController, "Enter new password", validatePassword,
                obscureText: !_passwordVisible2,
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible2 ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {});
                    _passwordVisible2 = !_passwordVisible2;
                  },
                )),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                final requestData = UpdateUserPassword(
                    id: userProvider.currentUser!.id!,
                    oldPassword: _oldPassController.text,
                    newPassword: _newPassController.text);
                _changePassword(requestData, context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text(
                "Save",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 800,
      height: 200,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/1.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _showErrorDialog(String message, BuildContext context) {
    _showDialog("Error!", message, context);
  }

  // Show Success Dialog
  void _showSuccessDialog(String message, BuildContext context) {
    _showDialog("Succeeded!", message, context);
  }

  // General Dialog Method
  void _showDialog(String title, String message, BuildContext context) {
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
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _changePassword(
      UpdateUserPassword requestData, BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      try {
        bool success =
            await userProvider.changeUserPassword(requestData, context);
        if (success) {
          _showSuccessDialog(
              "Password changed. Redirecting to login page", context);
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          });
        } else {
          _showErrorDialog("Please confirm old password", context);
        }
      } catch (e) {
        _showErrorDialog("Error occured. $e", context);
      }
    }
  }
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return "Enter your password, please";
  }
  if (password.length <= 6) {
    return "Password must have > 6 characters";
  }
  return null;
}
