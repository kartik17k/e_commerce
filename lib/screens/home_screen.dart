import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/theme.dart';
import '../widgets/app_logo.dart';
import 'cart_screen.dart';
import 'product_details_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = ['All', 'Electronics', 'Jewelery', "Men's Clothing", "Women's Clothing"];
  String selectedCategory = 'All';
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  bool isLoading = true;
  String searchQuery = '';
  int _cartItems = 0;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchCartItems();
  }

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

  void _filterProducts() {
    setState(() {
      filteredProducts = products.where((product) {
        final matchesCategory = selectedCategory == 'All' || 
            product['category'].toString().toLowerCase() == selectedCategory.toLowerCase();
        final matchesSearch = searchQuery.isEmpty || 
            product['title'].toString().toLowerCase().contains(searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final isSmallScreen = screenSize.width < 600;
    final isMediumScreen = screenSize.width >= 600 && screenSize.width < 1200;
    final crossAxisCount = isSmallScreen ? 2 : (isMediumScreen ? 3 : 4);
    final childAspectRatio = isSmallScreen ? 0.75 : (isMediumScreen ? 0.8 : 0.85);

    return Scaffold(
      appBar: AppBar(
        title: AppLogo(),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart),
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
            ).then((_) => _fetchCartItems()),
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppTheme.padding),
                child: Column(
                  children: [
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
            if (isLoading)
              SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (filteredProducts.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No products found',
                    style: AppTheme.titleMedium,
                  ),
                ),
              )
            else
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
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(product: product),
                          ),
                        ).then((_) => _fetchCartItems()),
                        child: Container(
                          decoration: AppTheme.cardDecoration,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.all(AppTheme.padding ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['title'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTheme.titleSmall,
                                      ),
                                      SizedBox(height: 25.0,),
                                      Text(
                                        '\$${product['price'].toStringAsFixed(2)}',
                                        style: AppTheme.titleMedium.copyWith(
                                          color: AppTheme.primaryColor,
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
