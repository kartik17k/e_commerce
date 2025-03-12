// Import required packages and libraries
import 'dart:convert';
import 'package:e_commerce/screens/home_screen.dart';
import 'package:e_commerce/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// LoginScreen Widget
/// 
/// Provides user authentication functionality including form validation,
/// API integration with FakeStoreAPI, and navigation to HomeScreen upon successful login.
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

/// State class for LoginScreen
/// 
/// Manages the state and logic for the login form, including user credentials,
/// validation, and authentication process.
class _LoginScreenState extends State<LoginScreen> {
  // Form key to handle validation
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for the input fields
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // State variables
  bool _isLoading = false;
  String _errorMessage = '';

  /// Handles the login process
  /// 
  /// Validates form inputs, sends authentication request to the API,
  /// stores the token on successful authentication, and navigates to HomeScreen.
  Future<void> _handleLogin() async {
    // Validate form before proceeding
    if (!_formKey.currentState!.validate()) return;

    // Set loading state and clear any previous error messages
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Send login request to the API
      final response = await http.post(
        Uri.parse('https://fakestoreapi.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      // Handle response based on status code
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Store authentication token and username in SharedPreferences
        await SharedPreferences.getInstance().then((prefs) {
          prefs.setString('token', data['token']);
          prefs.setString('username', _usernameController.text);
        });
        
        // Navigate to the home screen on successful login
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
      } else {
        // Display error message for invalid credentials
        setState(() {
          _errorMessage = 'Invalid username or password';
        });
      }
    } catch (e) {
      // Handle network or other errors
      setState(() {
        _errorMessage = 'Connection error. Please try again.';
      });
    } finally {
      // Reset loading state regardless of outcome
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome heading
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                
                // Username input field with validation
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                // Password input field with validation
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                
                // Error message display (conditionally shown)
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                
                // Login button with loading indicator
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text('Login'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                SizedBox(height: 16),
                
                // Sign up navigation option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupScreen(),));
                      },
                      child: Text('Sign Up'),
                    ),
                  ],
                ),
                
                // Demo credentials for testing purposes
                Text(
                  'Demo: username: "johnd", password: "m38rmF\$"',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
