import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/theme.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductDetailsScreen({required this.product});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _isAddingToCart = false;

  Future<void> _addToCart() async {
    setState(() {
      _isAddingToCart = true;
    });

    try {
      final userId = 1; // Replace with actual user ID
      final cart = {
        'userId': userId,
        'date': DateTime.now().toIso8601String(),
        'products': [
          {'productId': widget.product['id'], 'quantity': 1}
        ]
      };

      final response = await http.post(
        Uri.parse('https://fakestoreapi.com/carts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(cart),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added to cart successfully'),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to add to cart');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding to cart: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isAddingToCart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final isMediumScreen = screenSize.width >= 600 && screenSize.width < 1200;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: isSmallScreen
          ? _buildMobileLayout()
          : _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: Image.network(
                  widget.product['image'],
                  fit: BoxFit.contain,
                  height: 300,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppTheme.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product['title'],
                  style: AppTheme.titleLarge,
                ),
                SizedBox(height: AppTheme.spacing),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.padding / 2,
                    vertical: AppTheme.padding / 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius / 2),
                  ),
                  child: Text(
                    widget.product['category'].toString().toUpperCase(),
                    style: AppTheme.labelMedium.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: AppTheme.spacing),
                Text(
                  '\$${widget.product['price'].toStringAsFixed(2)}',
                  style: AppTheme.titleLarge.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
                SizedBox(height: AppTheme.spacing),
                Text(
                  widget.product['description'],
                  style: AppTheme.bodyMedium,
                ),
                SizedBox(height: AppTheme.spacing * 2),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: AppTheme.elevatedButtonStyle,
                    onPressed: _isAddingToCart ? null : _addToCart,
                    child: _isAddingToCart
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(AppTheme.padding * 2),
            color: Colors.white,
            child: Center(
              child: Image.network(
                widget.product['image'],
                fit: BoxFit.contain,
                height: 400,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppTheme.padding * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product['title'],
                  style: AppTheme.titleLarge,
                ),
                SizedBox(height: AppTheme.spacing * 1.5),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.padding / 2,
                    vertical: AppTheme.padding / 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius / 2),
                  ),
                  child: Text(
                    widget.product['category'].toString().toUpperCase(),
                    style: AppTheme.labelMedium.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: AppTheme.spacing * 1.5),
                Text(
                  '\$${widget.product['price'].toStringAsFixed(2)}',
                  style: AppTheme.titleLarge.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
                SizedBox(height: AppTheme.spacing * 1.5),
                Text(
                  widget.product['description'],
                  style: AppTheme.bodyLarge,
                ),
                SizedBox(height: AppTheme.spacing * 3),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: AppTheme.elevatedButtonStyle,
                    onPressed: _isAddingToCart ? null : _addToCart,
                    child: _isAddingToCart
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
