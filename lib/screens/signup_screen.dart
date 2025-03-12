// Import required packages and libraries
import 'dart:convert';
import 'package:e_commerce/screens/home_screen.dart';
import 'package:e_commerce/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// SignupScreen Widget
///
/// Provides user registration functionality including form validation,
/// API integration with FakeStoreAPI for creating new accounts,
/// and navigation to HomeScreen upon successful registration.
class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

/// State class for SignupScreen
///
/// Manages the state and logic for the signup form, including user information collection,
/// validation, and account creation process.
class _SignupScreenState extends State<SignupScreen> {
  // Form key to handle validation
  final _formKey = GlobalKey<FormState>();
  
  // State variables
  bool _isLoading = false;
  String _errorMessage = '';

  // Controllers for all input fields
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _zipcodeController = TextEditingController();

  /// Handles the signup process
  ///
  /// Validates form inputs, checks password confirmation,
  /// sends registration request to the API, and navigates to HomeScreen on success.
  Future<void> _handleSignup() async {
    // Validate form before proceeding
    if (!_formKey.currentState!.validate()) return;

    // Validate password confirmation matching
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    // Set loading state and clear any previous error messages
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Prepare user data in the format expected by the API
      final userData = {
        'email': _emailController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'name': {
          'firstname': _firstNameController.text,
          'lastname': _lastNameController.text,
        },
        'address': {
          'city': _cityController.text,
          'street': _streetController.text,
          'number': int.parse(_numberController.text),
          'zipcode': _zipcodeController.text,
          'geolocation': {
            'lat': '0',
            'long': '0'
          }
        },
        'phone': _phoneController.text
      };

      // Send registration request to the API
      final response = await http.post(
        Uri.parse('https://fakestoreapi.com/users'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      // Handle response based on status code
      if (response.statusCode == 200) {
        // Registration successful - show success message and navigate to home
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful! Please login.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
      } else {
        // Registration failed - show error message
        setState(() {
          _errorMessage = 'Registration failed. Please try again.';
        });
      }
    } catch (e) {
      // Handle errors during the registration process
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      // Reset loading state regardless of outcome
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Builds a styled text field with common properties
  ///
  /// Creates a consistent text field widget with label, icon, validation,
  /// and optional properties like keyboard type and password masking.
  /// @param controller The text editing controller for the field
  /// @param label The label text to display
  /// @param icon The icon to display before the field
  /// @param isPassword Whether to obscure text (for password fields)
  /// @param keyboardType Optional keyboard type for specialized input
  /// @param validator Optional custom validator function
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        obscureText: isPassword,
        keyboardType: keyboardType,
        // Use provided validator or default to required field validation
        validator: validator ?? (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Form header
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              
              // Personal Information section
              Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildTextField(
                controller: _firstNameController,
                label: 'First Name',
                icon: Icons.person_outline,
              ),
              _buildTextField(
                controller: _lastNameController,
                label: 'Last Name',
                icon: Icons.person_outline,
              ),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              
              // Account Information section
              Text(
                'Account Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildTextField(
                controller: _usernameController,
                label: 'Username',
                icon: Icons.account_circle,
              ),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _passwordController,
                label: 'Password',
                icon: Icons.lock,
                isPassword: true,
              ),
              _buildTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                icon: Icons.lock,
                isPassword: true,
              ),
              SizedBox(height: 16),
              
              // Address Information section
              Text(
                'Address Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildTextField(
                controller: _streetController,
                label: 'Street',
                icon: Icons.home,
              ),
              _buildTextField(
                controller: _numberController,
                label: 'Number',
                icon: Icons.numbers,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                controller: _cityController,
                label: 'City',
                icon: Icons.location_city,
              ),
              _buildTextField(
                controller: _zipcodeController,
                label: 'Zipcode',
                icon: Icons.local_post_office,
              ),
              
              // Error message display (conditionally shown)
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: 24),
              
              // Sign Up button with loading indicator
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSignup,
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text('Sign Up'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              SizedBox(height: 16),
              
              // Login navigation option
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _zipcodeController.dispose();
    super.dispose();
  }
}
