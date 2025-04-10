// Import required packages and libraries
import 'package:e_commerce/screens/add_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/theme.dart';
import '../widgets/app_logo.dart';
import 'cart_screen.dart';
import 'product_details_screen.dart';
import 'profile_screen.dart';

/// HomeScreen Widget
///
/// Main product browsing interface of the StyleHub e-commerce application.
/// Features include:
/// - Product listing in a responsive grid layout
/// - Category filtering
/// - Search functionality
/// - Navigation to cart, product details, and user profile
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/// State class for HomeScreen
///
/// Manages the state of the home screen including product data fetching,
/// filtering, searching, and UI rendering based on screen size.
class _HomeScreenState extends State<HomeScreen> {
  // List of available product categories
  final List<String> categories = ['All', 'Electronics', 'Jewelery', "Men's Clothing", "Women's Clothing"];
  // Currently selected category for filtering
  String selectedCategory = 'All';
  // All products fetched from API
  List<dynamic> products = [];
  // Products after applying category and search filters
  List<dynamic> filteredProducts = [];
  // Loading state indicator
  bool isLoading = true;
  // Current search query text
  String searchQuery = '';
  // Number of items in the user's cart
  int _cartItems = 0;

  @override
  void initState() {
    super.initState();
    // Fetch products and cart data when screen initializes
    _fetchProducts();
    _fetchCartItems();
  }

  /// Fetches product data from the Fake Store API
  ///
  /// Retrieves all products and updates the state with the fetched data.
  /// Sets loading state to false when complete or on error.
  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));
      if (response.statusCode == 200) {
        setState(() {
          products = json.decode(response.body);
          _filterProducts();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Fetches the current user's cart items from the API
  ///
  /// Retrieves cart data for a specific user and calculates the total
  /// number of items in the cart for badge display.
  Future<void> _fetchCartItems() async {
    try {
      final userId = 1; // Replace with actual user ID
      final response = await http.get(Uri.parse('https://fakestoreapi.com/carts/user/$userId'));
      if (response.statusCode == 200) {
        final List<dynamic> carts = json.decode(response.body);
        if (carts.isNotEmpty) {
          final products = carts[0]['products'] as List;
          setState(() {
            _cartItems = products.fold(0, (sum, item) => sum + (item['quantity'] as int));
          });
        }
      }
    } catch (e) {
      print('Error fetching cart: $e');
    }
  }

  /// Filters products based on selected category and search query
  ///
  /// Updates the filteredProducts list by applying the current category filter
  /// and search text filter to the full products list.
  void _filterProducts() {
    setState(() {
      filteredProducts = products.where((product) {
        // Check if product matches selected category or 'All' is selected
        final matchesCategory = selectedCategory == 'All' || 
            product['category'].toString().toLowerCase() == selectedCategory.toLowerCase();
        // Check if product title contains the search query text
        final matchesSearch = searchQuery.isEmpty || 
            product['title'].toString().toLowerCase().contains(searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate responsive layout parameters based on screen size
    final screenSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final isSmallScreen = screenSize.width < 600;
    final isMediumScreen = screenSize.width >= 600 && screenSize.width < 1200;
    // Determine grid columns and aspect ratio based on screen size
    final crossAxisCount = isSmallScreen ? 2 : (isMediumScreen ? 3 : 4);
    final childAspectRatio = isSmallScreen ? 0.65 : (isMediumScreen ? 0.7 : 0.75);

    return Scaffold(
      appBar: AppBar(
        title: AppLogo(),
        actions: [
          // Cart button with item count badge
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart),
                // Show badge with item count if cart is not empty
                if (_cartItems > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        _cartItems.toString(),
                        style: AppTheme.labelSmall.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()),
            ).then((_) => _fetchCartItems()), // Refresh cart count when returning
          ),
          // Profile button
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => AddProductScreen()))
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Search and filter section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppTheme.padding),
                child: Column(
                  children: [
                    // Search text field
                    TextField(
                      decoration: AppTheme.inputDecoration.copyWith(
                        hintText: 'Search products...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                          _filterProducts();
                        });
                      },
                    ),
                    SizedBox(height: AppTheme.spacing),
                    // Horizontal scrolling category filter chips
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = category == selectedCategory;
                          return Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  selectedCategory = category;
                                  _filterProducts();
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Conditional content based on loading state and filter results
            if (isLoading)
              // Show loading indicator when fetching products
              SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (filteredProducts.isEmpty)
              // Show message when no products match filters
              SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No products found',
                    style: AppTheme.titleMedium,
                  ),
                ),
              )
            else
              // Product grid display
              SliverPadding(
                padding: EdgeInsets.all(AppTheme.padding),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    mainAxisSpacing: AppTheme.spacing,
                    crossAxisSpacing: AppTheme.spacing,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = filteredProducts[index];
                      // Product card with tap navigation
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(product: product),
                          ),
                        ).then((_) => _fetchCartItems()), // Refresh cart count when returning
                        child: Container(
                          decoration: AppTheme.cardDecoration,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product image section (top 60% of card)
                              Expanded(
                                flex: 3,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(AppTheme.borderRadius),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(AppTheme.borderRadius),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(AppTheme.padding),
                                      child: Center(
                                        child: Image.network(
                                          product['image'],
                                          fit: BoxFit.contain,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress.expectedTotalBytes != null
                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                        loadingProgress.expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Product details section (bottom 40% of card)
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.all(AppTheme.padding),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Product title with ellipsis for overflow
                                      Text(
                                        product['title'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTheme.titleSmall,
                                      ),
                                      // Product price with accent color
                                      Text(
                                        '\$${product['price'].toStringAsFixed(2)}',
                                        style: AppTheme.titleLarge.copyWith(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: filteredProducts.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
