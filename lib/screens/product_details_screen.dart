// Import required packages and libraries
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/theme.dart';

/// ProductDetailsScreen Widget
///
/// Displays detailed information about a selected product and allows the user
/// to add it to their cart. Features responsive layouts for different screen sizes.
/// Receives product data as a parameter from the previous screen.
class ProductDetailsScreen extends StatefulWidget {
  /// Product data from API, passed from the product listing screen
  final Map<String, dynamic> product;

  ProductDetailsScreen({required this.product});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

/// State class for ProductDetailsScreen
///
/// Manages the state of the product details screen, including the cart
/// addition process and rendering different layouts based on screen size.
class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // Tracks the loading state when adding product to cart
  bool _isAddingToCart = false;

  /// Adds the current product to the user's cart
  ///
  /// Makes an API request to add the product to the cart and displays
  /// appropriate feedback to the user based on the result.
  Future<void> _addToCart() async {
    setState(() {
      _isAddingToCart = true; // Show loading indicator
    });

    try {
      final userId = 1; // Replace with actual user ID
      // Prepare cart data for API request
      final cart = {
        'userId': userId,
        'date': DateTime.now().toIso8601String(),
        'products': [
          {'productId': widget.product['id'], 'quantity': 1}
        ]
      };

      // Send POST request to add item to cart
      final response = await http.post(
        Uri.parse('https://fakestoreapi.com/carts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(cart),
      );

      if (response.statusCode == 200) {
        // Show success message and navigate back
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
      // Show error message if request fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding to cart: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Reset loading state whether successful or not
      setState(() {
        _isAddingToCart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate responsive layout parameters based on screen size
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final isMediumScreen = screenSize.width >= 600 && screenSize.width < 1200;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      // Choose layout based on screen size
      body: isSmallScreen
          ? _buildMobileLayout()
          : _buildDesktopLayout(),
    );
  }

  /// Builds the mobile layout for smaller screens
  ///
  /// Creates a vertically scrolling layout with the product image at the top
  /// followed by product details and the add to cart button.
  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image section - full width and square aspect ratio
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
          // Product details section
          Padding(
            padding: EdgeInsets.all(AppTheme.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product title
                Text(
                  widget.product['title'],
                  style: AppTheme.titleLarge,
                ),
                SizedBox(height: AppTheme.spacing),
                // Product category badge
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
                // Product price
                Text(
                  '\$${widget.product['price'].toStringAsFixed(2)}',
                  style: AppTheme.titleLarge.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
                SizedBox(height: AppTheme.spacing),
                // Product description
                Text(
                  widget.product['description'],
                  style: AppTheme.bodyMedium,
                ),
                SizedBox(height: AppTheme.spacing * 2),
                // Add to cart button
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

  /// Builds the desktop/tablet layout for larger screens
  ///
  /// Creates a two-column layout with the product image on the left
  /// and product details with add to cart button on the right.
  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column - Product image
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
        // Right column - Product details
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppTheme.padding * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product title
                Text(
                  widget.product['title'],
                  style: AppTheme.titleLarge,
                ),
                SizedBox(height: AppTheme.spacing * 1.5),
                // Product category badge
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
                // Product price
                Text(
                  '\$${widget.product['price'].toStringAsFixed(2)}',
                  style: AppTheme.titleLarge.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
                SizedBox(height: AppTheme.spacing * 1.5),
                // Product description
                Text(
                  widget.product['description'],
                  style: AppTheme.bodyLarge,
                ),
                SizedBox(height: AppTheme.spacing * 3),
                // Add to cart button
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
