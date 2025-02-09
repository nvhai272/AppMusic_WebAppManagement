import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:musicapp/dto/request/register_request.dart';
import 'package:musicapp/pages/login_page.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

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

class _SignUpPageState extends State<SignUpPage> {
  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;
  bool _isLoading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Container
              Container(
                width: 700,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/musicix2.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // SignUp Form
              Container(
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
                      createTextBox(_usernameController, "Enter username",
                          validateUsername),
                      const SizedBox(height: 20),
                      createTextBox(_fullNameController, "Enter full name",
                          validateFullName),
                      const SizedBox(height: 20),

                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Select Date",
                          border: OutlineInputBorder(),
                        ),
                        controller: _dobController,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),
                      const SizedBox(height: 20),
                      createTextBox(_passwordController, "Enter password",
                          validatePassword,
                          obscureText: !_passwordVisible1,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible1
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible1 = !_passwordVisible1;
                              });
                            },
                          )),
                      const SizedBox(height: 20),
                      createTextBox(
                          _repasswordController,
                          "Re-enter password",
                          (value) => validateRePassword(
                              value, _passwordController.text),
                          obscureText: !_passwordVisible2,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible2 = !_passwordVisible2;
                              });
                            },
                          )),
                      const SizedBox(height: 20),
                      createTextBox(_emailController, "Email", validateEmail),
                      const SizedBox(height: 20),
                      createTextBox(
                          _phoneController, "Phone Number", validatePhoneNo),
                      const SizedBox(height: 20),
                      const SizedBox(height: 10),
                      // Sign-Up Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Bạn  có tài khoản?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null // Disable the button when _isLoading is true
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  final request = _buildRegisterRequest();
                                  _signup(request); // Call the signup function
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        _dobController.text = formattedDate;
      });
    }
  }

  void _signup(RegisterRequest request) async {
    setState(() {
      _isLoading = true; // Disable the button when starting the request
    });
    print("Username: ${request.username}");
    print("Fullname: ${request.fullName}");
    print("Password: ${request.password}");
    print("Phone: ${request.phone}");
    print("Email: ${request.email}");
    print("Date of Birth: ${request.dob}");
    print("Request body: ${jsonEncode(request.toJson())}");

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final result = await userProvider.register(request, context);

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration Successful!")));

        // Clear the form fields after successful signup
        _clearFormFields();

        // Navigate to the login page (replace the current SignUpPage with LoginPage)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration Failed!")));
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $error")));
    } finally {
      setState(() {
        _isLoading = false; // Re-enable the button after the request finishes
      });
    }
  }

  void _clearFormFields() {
    // Clear the form fields
    _usernameController.clear();
    _passwordController.clear();
    _repasswordController.clear();
    _emailController.clear();
    _phoneController.clear();
    _dobController.clear();
    _fullNameController.clear();
  }

  RegisterRequest _buildRegisterRequest() {
    print("Full name: ${_fullNameController.text.trim()}");
    return RegisterRequest(
      username: _usernameController.text.trim(),
      fullName: _fullNameController.text.trim(),
      // Ensure this is not null or empty
      password: _passwordController.text,
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      dob: _dobController.text.isNotEmpty
          ? DateTime.tryParse(_dobController.text)
          : null,
    );
  }
}

String? validateFullName(String? fullName) {
  if (fullName == null || fullName.trim().isEmpty) {
    return "Please enter your full name.";
  }

  if (fullName.trim().split(' ').length < 2) {
    return "Please enter both first and last name.";
  }

  if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(fullName.trim())) {
    return "Name can only contain letters and spaces.";
  }

  return null;
}

String? validateOptionalField(String? value) {
  return null; // No error for empty fields, optional
}

String? validateUsername(String? username) {
  if (username == null || username.isEmpty) {
    return "Enter your name, please:";
  }
  if (username.length <= 5) {
    return "Must have > 5 characters";
  }
  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return "Enter your password, please:";
  }
  if (password.length <= 6) {
    return "Must have > 6 characters";
  }
  return null;
}

String? validateRePassword(String? repassword, String? password) {
  if (repassword == null || repassword.isEmpty) {
    return "Enter your repassword, please:";
  }
  if (password == null || password != repassword) {
    return "Passwords do not match.";
  }
  return null;
}

String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return "Enter your email, please:";
  }
  if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
      .hasMatch(email)) {
    return "Email is not valid.";
  }
  return null;
}

String? validatePhoneNo(String? phoneNo) {
  if (phoneNo == null || phoneNo.isEmpty) {
    return "Enter your phone number, please:";
  }
  if (!RegExp(r'^\d+$').hasMatch(phoneNo)) {
    return "Phone number must contain only digits.";
  }
  if (phoneNo.length != 10) {
    return "Phone number must be exactly 10 digits.";
  }
  return null;
}
