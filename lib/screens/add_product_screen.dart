import 'package:e_commerce/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // Controllers for text input fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Method to add product
  Future<void> _addProduct() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Prepare product data from user inputs
    final product = {
      "title": _titleController.text.trim(),
      "price": double.parse(_priceController.text.trim()),
      "description": _descriptionController.text.trim(),
      "category": _categoryController.text.trim(),
      "image": _imageUrlController.text.trim()
    };

    try {
      final response = await http.post(
        Uri.parse('https://fakestoreapi.com/products'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(product),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Show success dialog
        _showResultDialog('Product Added Successfully', true);
      } else {
        // Show error dialog
        _showResultDialog('Failed to Add Product', false);
      }
    } catch (e) {
      // Show error dialog for network or other errors
      _showResultDialog('Error: ${e.toString()}', false);
    }
  }

  // Method to show result dialog
  void _showResultDialog(String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isSuccess ? 'Success' : 'Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
              
              if (isSuccess) {
                _formKey.currentState!.reset();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Input
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Product Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Price Input
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Description Input
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Category Input
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Image URL Input
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  // Optional: Add URL validation
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _addProduct,
                child: Text('Add Product'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dispose controllers to prevent memory leaks
  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}