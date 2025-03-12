// Import required packages and libraries
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/theme.dart';
import '../widgets/app_logo.dart';

/// CartScreen Widget
///
/// Displays the user's shopping cart with product details, quantities, and total cost.
/// Features include:
/// - Fetching cart data from the API
/// - Displaying cart items with images and details
/// - Quantity adjustments with API updates
/// - Order summary with subtotal, shipping, and total
/// - Responsive design for different screen sizes
class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

/// State class for CartScreen
///
/// Manages the state of the cart screen, including fetching cart data,
/// updating quantities, and calculating totals.
class _CartScreenState extends State<CartScreen> {
  // Cart data and loading state
  List<Map<String, dynamic>> _cartItems = [];
  bool _isLoading = true;
  double _subtotal = 0;
  final double _shippingCost = 10.0; // Fixed shipping cost for now

  @override
  void initState() {
    super.initState();
    // Fetch cart data when screen initializes
    _fetchCartWithProducts();
  }

  /// Fetches the user's cart and related product details from the API
  ///
  /// First gets the cart data, then fetches detailed product information
  /// for each item in the cart. Finally calculates the subtotal.
  Future<void> _fetchCartWithProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, this would be the actual user ID
      final userId = 1;
      
      // Fetch the user's cart from the API
      final cartResponse = await http.get(
        Uri.parse('https://fakestoreapi.com/carts/$userId'),
      );
      
      if (cartResponse.statusCode != 200) {
        throw Exception('Failed to load cart');
      }
      
      final cartData = json.decode(cartResponse.body);
      final cartProducts = cartData['products'] as List;

      // For each cart item, fetch the detailed product info
      final cartItemsWithDetails = <Map<String, dynamic>>[];
      _subtotal = 0;

      for (var product in cartProducts) {
        final productId = product['productId'];
        final quantity = product['quantity'];

        // Fetch product details from the API
        final productResponse = await http.get(
          Uri.parse('https://fakestoreapi.com/products/$productId'),
        );

        if (productResponse.statusCode == 200) {
          final productData = json.decode(productResponse.body);

          // Merge cart item with product details
          final cartItem = <String, dynamic>{
            ...productData as Map<String, dynamic>,
            'quantity': quantity,
          };

          cartItemsWithDetails.add(cartItem);
          _subtotal += (productData['price'] * quantity);
        }
      }

      setState(() {
        _cartItems = cartItemsWithDetails;
        _isLoading = false;
      });
    } catch (e) {
      // Show error message if request fails
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading cart: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Update the quantity of a product in the cart
  ///
  /// Makes an API request to update the cart with the new quantity
  /// and refreshes the cart data upon success.
  Future<void> _updateQuantity(int productId, int newQuantity) async {
    if (newQuantity < 1) return; // Prevent quantities less than 1
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final userId = 1; // In a real app, this would be the actual user ID
      
      // Prepare updated cart data for API request
      final updatedCart = {
        'userId': userId,
        'date': DateTime.now().toIso8601String(),
        'products': [
          {'productId': productId, 'quantity': newQuantity}
        ]
      };
      
      // Send PUT request to update cart
      final response = await http.put(
        Uri.parse('https://fakestoreapi.com/carts/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedCart),
      );
      
      if (response.statusCode == 200) {
        // Refresh cart data after successful update
        _fetchCartWithProducts();
      } else {
        throw Exception('Failed to update cart');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating cart: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Removes a product from the cart
  ///
  /// Makes an API request to delete the product from the cart
  /// and refreshes the cart data upon success.
  Future<void> _removeItem(int productId) async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final userId = 1; // In a real app, this would be the actual user ID
      
      // Send DELETE request to remove product from cart
      final response = await http.delete(
        Uri.parse('https://fakestoreapi.com/carts/$userId/product/$productId'),
      );
      
      if (response.statusCode == 200) {
        // Update local state to remove the item
        setState(() {
          _cartItems.removeWhere((item) => item['id'] == productId);
          // Recalculate subtotal
          _subtotal = _cartItems.fold(
            0,
            (sum, item) => sum + (item['price'] * item['quantity']),
          );
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item removed from cart'),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      } else {
        throw Exception('Failed to remove item from cart');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error removing item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Proceed to checkout
  ///
  /// Currently just displays a message, but would
  /// navigate to a checkout page in a complete implementation.
  void _proceedToCheckout() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Proceeding to checkout...'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
    // In a real app, navigate to checkout screen
  }

  @override
  Widget build(BuildContext context) {
    // Calculate responsive layout parameters based on screen size
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final isMediumScreen = screenSize.width >= 600 && screenSize.width < 1200;
    final contentWidth = isSmallScreen
        ? screenSize.width
        : (isMediumScreen ? 600.0 : 800.0);
    
    return Scaffold(
      appBar: AppBar(
        title: AppLogo(size: 28),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
              ? _buildEmptyCart()
              : _buildCart(contentWidth, isSmallScreen),
    );
  }

  /// Builds the empty cart view when no items are in cart
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: AppTheme.greyColor,
          ),
          SizedBox(height: AppTheme.spacing * 2),
          Text(
            'Your cart is empty',
            style: AppTheme.titleMedium,
          ),
          SizedBox(height: AppTheme.spacing),
          Text(
            'Add items to your cart to see them here',
            style: AppTheme.bodyMedium,
          ),
          SizedBox(height: AppTheme.spacing * 2),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: AppTheme.elevatedButtonStyle,
            child: Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  /// Builds the cart view with items and order summary
  Widget _buildCart(double contentWidth, bool isSmallScreen) {
    // Calculate total cost including shipping
    final totalCost = _subtotal + _shippingCost;
    
    return Center(
      child: Container(
        width: contentWidth,
        padding: EdgeInsets.all(AppTheme.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Shopping Cart',
              style: AppTheme.titleLarge,
            ),
            SizedBox(height: AppTheme.spacing * 2),
            // Main layout adjusts based on screen size
            Expanded(
              child: isSmallScreen
                  ? _buildCartItemsList()
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cart items list on the left
                        Expanded(
                          flex: 3,
                          child: _buildCartItemsList(),
                        ),
                        SizedBox(width: AppTheme.spacing * 2),
                        // Order summary on the right
                        Expanded(
                          flex: 2,
                          child: _buildOrderSummary(totalCost),
                        ),
                      ],
                    ),
            ),
            // Order summary appears at the bottom on small screens
            if (isSmallScreen) ...[
              SizedBox(height: AppTheme.spacing * 2),
              _buildOrderSummary(totalCost),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds the scrollable list of cart items
  Widget _buildCartItemsList() {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: ListView.separated(
        padding: EdgeInsets.all(AppTheme.padding),
        itemCount: _cartItems.length,
        separatorBuilder: (context, index) => Divider(height: AppTheme.spacing * 2),
        itemBuilder: (context, index) {
          final item = _cartItems[index];
          return _buildCartItem(item);
        },
      ),
    );
  }

  /// Builds an individual cart item card
  Widget _buildCartItem(Map<String, dynamic> item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product image
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius / 2),
          child: Image.network(
            item['image'],
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: AppTheme.spacing),
        // Product details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['title'],
                style: AppTheme.titleSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppTheme.spacing / 2),
              Text(
                '\$${item['price'].toStringAsFixed(2)}',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
              SizedBox(height: AppTheme.spacing),
              // Quantity controls and remove button
              Row(
                children: [
                  // Decrease quantity button
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius / 2),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.remove, size: 16),
                      onPressed: () => _updateQuantity(
                        item['id'],
                        item['quantity'] - 1,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  // Quantity display
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: AppTheme.spacing),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing,
                      vertical: AppTheme.spacing / 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius / 2),
                    ),
                    child: Text(
                      '${item['quantity']}',
                      style: AppTheme.titleSmall,
                    ),
                  ),
                  // Increase quantity button
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius / 2),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add, size: 16),
                      onPressed: () => _updateQuantity(
                        item['id'],
                        item['quantity'] + 1,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  Spacer(),
                  // Remove item button
                  TextButton.icon(
                    onPressed: () => _removeItem(item['id']),
                    icon: Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: Colors.red,
                    ),
                    label: Text(
                      'Remove',
                      style: AppTheme.labelMedium.copyWith(
                        color: Colors.red,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the order summary card with cost breakdown and checkout button
  Widget _buildOrderSummary(double totalCost) {
    return Container(
      padding: EdgeInsets.all(AppTheme.padding),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: AppTheme.titleMedium,
          ),
          SizedBox(height: AppTheme.spacing * 2),
          // Cost breakdown rows
          _buildSummaryRow('Subtotal', '\$${_subtotal.toStringAsFixed(2)}'),
          SizedBox(height: AppTheme.spacing),
          _buildSummaryRow('Shipping', '\$${_shippingCost.toStringAsFixed(2)}'),
          SizedBox(height: AppTheme.spacing),
          Divider(),
          SizedBox(height: AppTheme.spacing),
          // Total cost row
          _buildSummaryRow(
            'Total',
            '\$${totalCost.toStringAsFixed(2)}',
            isTotal: true,
          ),
          SizedBox(height: AppTheme.spacing * 2),
          // Checkout button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: AppTheme.elevatedButtonStyle,
              onPressed: _proceedToCheckout,
              child: Text('Proceed to Checkout'),
            ),
          ),
          SizedBox(height: AppTheme.spacing),
          // Continue shopping button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: AppTheme.outlinedButtonStyle,
              onPressed: () => Navigator.pop(context),
              child: Text('Continue Shopping'),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to build consistent summary rows
  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTheme.titleMedium
              : AppTheme.bodyLarge,
        ),
        Text(
          value,
          style: isTotal
              ? AppTheme.titleMedium.copyWith(
                  color: AppTheme.primaryColor,
                )
              : AppTheme.bodyLarge,
        ),
      ],
    );
  }
}
