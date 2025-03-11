import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/theme.dart';
import '../widgets/app_logo.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _cartItems = [];
  bool _isLoading = true;
  double _total = 0;

  @override
  void initState() {
    super.initState();
    _fetchCartWithProducts();
  }

  Future<void> _fetchCartWithProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId') ?? 1;

      final cartResponse = await http.get(Uri.parse('https://fakestoreapi.com/carts/user/$userId'));
      
      if (cartResponse.statusCode == 200) {
        final List<dynamic> carts = json.decode(cartResponse.body);
        if (carts.isNotEmpty) {
          final cart = carts[0];
          final List<dynamic> products = cart['products'];
          
          List<Map<String, dynamic>> cartItems = [];
          double total = 0;
          
          for (var item in products) {
            final productResponse = await http.get(
              Uri.parse('https://fakestoreapi.com/products/${item['productId']}'),
            );
            
            if (productResponse.statusCode == 200) {
              final productData = json.decode(productResponse.body);
              final quantity = item['quantity'] as int;
              final price = (productData['price'] as num).toDouble();
              
              cartItems.add({
                ...productData,
                'quantity': quantity,
              });
              
              total += price * quantity;
            }
          }
          
          setState(() {
            _cartItems = cartItems;
            _total = total;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching cart: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateQuantity(int index, int newQuantity) async {
    if (newQuantity < 1) return;
    
    setState(() {
      _cartItems[index]['quantity'] = newQuantity;
      _total = _cartItems.fold(0, (sum, item) => 
        sum + (item['price'] as num).toDouble() * (item['quantity'] as int)
      );
    });
  }

  Future<void> _removeItem(int index) async {
    setState(() {
      _cartItems.removeAt(index);
      _total = _cartItems.fold(0, (sum, item) => 
        sum + (item['price'] as num).toDouble() * (item['quantity'] as int)
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final isMediumScreen = screenSize.width >= 600 && screenSize.width < 1200;
    
    return Scaffold(
      appBar: AppBar(
        title: AppLogo(size: 28),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: AppTheme.greyColor,
                      ),
                      SizedBox(height: AppTheme.spacing),
                      Text(
                        'Your cart is empty',
                        style: AppTheme.titleMedium,
                      ),
                      SizedBox(height: AppTheme.spacing / 2),
                      Text(
                        'Add items to start shopping',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.greyColor,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(AppTheme.padding),
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          final item = _cartItems[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: AppTheme.spacing),
                            child: Container(
                              decoration: AppTheme.cardDecoration,
                              child: isSmallScreen
                                  ? _buildMobileCartItem(item, index)
                                  : _buildDesktopCartItem(item, index),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(AppTheme.padding),
                      child: SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total:',
                                  style: AppTheme.titleMedium,
                                ),
                                Text(
                                  '\$${_total.toStringAsFixed(2)}',
                                  style: AppTheme.titleLarge.copyWith(
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppTheme.spacing),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: AppTheme.elevatedButtonStyle,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Checkout functionality coming soon!'),
                                      backgroundColor: AppTheme.primaryColor,
                                    ),
                                  );
                                },
                                child: Text('Proceed to Checkout'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildMobileCartItem(Map<String, dynamic> item, int index) {
    return Padding(
      padding: EdgeInsets.all(AppTheme.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                child: Image.network(
                  item['image'],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: AppTheme.spacing),
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
                      '\$${(item['price'] as num).toStringAsFixed(2)}',
                      style: AppTheme.titleMedium.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () => _updateQuantity(index, item['quantity'] - 1),
                  ),
                  Text(
                    item['quantity'].toString(),
                    style: AppTheme.titleMedium,
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _updateQuantity(index, item['quantity'] + 1),
                  ),
                ],
              ),
              TextButton.icon(
                icon: Icon(Icons.delete_outline),
                label: Text('Remove'),
                onPressed: () => _removeItem(index),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopCartItem(Map<String, dynamic> item, int index) {
    return Padding(
      padding: EdgeInsets.all(AppTheme.padding),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            child: Image.network(
              item['image'],
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: AppTheme.spacing),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: AppTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppTheme.spacing / 2),
                Text(
                  item['category'].toString().toUpperCase(),
                  style: AppTheme.labelMedium.copyWith(
                    color: AppTheme.greyColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppTheme.spacing),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${(item['price'] as num).toStringAsFixed(2)}',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
              SizedBox(height: AppTheme.spacing),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () => _updateQuantity(index, item['quantity'] - 1),
                  ),
                  Text(
                    item['quantity'].toString(),
                    style: AppTheme.titleMedium,
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _updateQuantity(index, item['quantity'] + 1),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: AppTheme.spacing),
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () => _removeItem(index),
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
