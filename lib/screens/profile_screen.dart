// Import required packages and libraries
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/theme.dart';
import 'login_screen.dart';

/// ProfileScreen Widget
///
/// Displays user profile information and provides access to various settings
/// including notifications, privacy, and help & support.
/// Features a responsive layout for different screen sizes and a logout function.
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

/// State class for ProfileScreen
///
/// Manages user profile data, preferences, and the UI for various settings panels.
class _ProfileScreenState extends State<ProfileScreen> {
  // User information fields
  String _username = '';
  String _email = '';
  bool _isLoading = true;
  bool _notificationsEnabled = true;
  String _selectedPrivacy = 'Public';
  
  // Notification preferences with default values
  Map<String, bool> _notificationSettings = {
    'Order Updates': true,
    'Promotions': false,
    'New Arrivals': true,
    'Price Drops': true,
  };

  // Privacy setting options with default values
  Map<String, String> _privacySettings = {
    'Profile Visibility': 'Public',
    'Show Email': 'Friends Only',
    'Activity Status': 'Everyone',
    'Order History': 'Only Me',
  };

  // Help and support topics for the help section
  List<Map<String, dynamic>> _helpTopics = [
    {
      'title': 'Frequently Asked Questions',
      'icon': Icons.question_answer,
      'content': [
        'How do I track my order?',
        'What payment methods are accepted?',
        'How can I return an item?',
        'What is your shipping policy?',
      ],
    },
    {
      'title': 'Contact Support',
      'icon': Icons.support_agent,
      'content': [
        'Email: support@shopease.com',
        'Phone: 1-800-SHOP-EASE',
        'Live Chat: Available 24/7',
      ],
    },
    {
      'title': 'Shipping Information',
      'icon': Icons.local_shipping,
      'content': [
        'Standard Shipping (3-5 days)',
        'Express Shipping (1-2 days)',
        'International Shipping',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when screen initializes
  }

  /// Loads user data from SharedPreferences
  ///
  /// Retrieves username and email information from local storage
  /// and updates the UI accordingly. Falls back to default values
  /// if no saved data is found.
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _username = prefs.getString('username') ?? 'John Doe';
        _email = prefs.getString('email') ?? 'john.doe@example.com';
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Displays a modal bottom sheet with notification settings
  ///
  /// Allows users to toggle different notification types on/off
  /// using a series of switches. Changes are saved when the user
  /// taps the Save Changes button.
  void _showNotificationSettings() {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.borderRadius)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          constraints: BoxConstraints(
            maxWidth: isSmallScreen ? double.infinity : 600,
          ),
          padding: EdgeInsets.all(AppTheme.padding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.borderRadius)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and close button
              Row(
                children: [
                  Text('Notification Settings', style: AppTheme.titleLarge),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: AppTheme.spacing),
              // Generate toggle switches for each notification type
              ..._notificationSettings.entries.map(
                (entry) => Container(
                  margin: EdgeInsets.only(bottom: AppTheme.spacing),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  ),
                  child: SwitchListTile(
                    title: Text(entry.key, style: AppTheme.bodyLarge),
                    value: entry.value,
                    onChanged: (value) {
                      setState(() => _notificationSettings[entry.key] = value);
                    },
                  ),
                ),
              ),
              SizedBox(height: AppTheme.spacing),
              // Save changes button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: AppTheme.elevatedButtonStyle,
                  child: Text('Save Changes'),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }

  /// Displays a modal bottom sheet with privacy settings
  ///
  /// Allows users to choose privacy levels for different aspects of their account
  /// using dropdown menus. Options include Public, Friends Only, Only Me, and Everyone.
  void _showPrivacySettings() {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.borderRadius)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          constraints: BoxConstraints(
            maxWidth: isSmallScreen ? double.infinity : 600,
          ),
          padding: EdgeInsets.all(AppTheme.padding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.borderRadius)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and close button
              Row(
                children: [
                  Text('Privacy Settings', style: AppTheme.titleLarge),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: AppTheme.spacing),
              // Generate list tiles with dropdown menus for each privacy setting
              ..._privacySettings.entries.map(
                (entry) => Container(
                  margin: EdgeInsets.only(bottom: AppTheme.spacing),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  ),
                  child: ListTile(
                    title: Text(entry.key, style: AppTheme.bodyLarge),
                    subtitle: Text(entry.value, style: AppTheme.labelMedium),
                    trailing: PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        'Public',
                        'Friends Only',
                        'Only Me',
                        'Everyone',
                      ].map((option) => PopupMenuItem(
                        value: option,
                        child: Text(option),
                      )).toList(),
                      onSelected: (value) {
                        setState(() => _privacySettings[entry.key] = value);
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppTheme.spacing),
              // Save changes button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: AppTheme.elevatedButtonStyle,
                  child: Text('Save Changes'),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }

  /// Displays a modal sheet with help and support information
  ///
  /// Features expandable panels for each help topic, with clickable
  /// items within each panel. Uses a draggable scrollable sheet for
  /// flexibility in how much of the screen it occupies.
  void _showHelpSupport() {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.borderRadius)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          constraints: BoxConstraints(
            maxWidth: isSmallScreen ? double.infinity : 800,
          ),
          padding: EdgeInsets.all(AppTheme.padding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.borderRadius)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and close button
              Row(
                children: [
                  Text('Help & Support', style: AppTheme.titleLarge),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: AppTheme.spacing),
              // Expandable list of help topics
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: _helpTopics.length,
                  separatorBuilder: (context, index) => SizedBox(height: AppTheme.spacing),
                  itemBuilder: (context, index) {
                    final topic = _helpTopics[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                      ),
                      child: ExpansionTile(
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppTheme.borderRadius / 2),
                          ),
                          child: Icon(
                            topic['icon'] as IconData,
                            color: AppTheme.primaryColor,
                            size: 20,
                          ),
                        ),
                        title: Text(topic['title'], style: AppTheme.titleMedium),
                        children: (topic['content'] as List<String>).map((item) => Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: AppTheme.padding,
                            vertical: AppTheme.spacing / 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppTheme.borderRadius / 2),
                            border: Border.all(
                              color: AppTheme.greyColor.withOpacity(0.2),
                            ),
                          ),
                          child: ListTile(
                            title: Text(item, style: AppTheme.bodyMedium),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Selected: $item'),
                                  backgroundColor: AppTheme.primaryColor,
                                ),
                              );
                            },
                          ),
                        )).toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handles the logout process
  ///
  /// Shows a confirmation dialog before logging out.
  /// When confirmed, clears all SharedPreferences data and
  /// returns the user to the login screen.
  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              try {
                // Clear all stored preferences (user session data)
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                // Navigate back to login screen, removing all previous routes
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error logging out: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
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
        title: Text('Profile'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  width: contentWidth,
                  padding: EdgeInsets.all(AppTheme.padding),
                  child: Column(
                    children: [
                      SizedBox(height: AppTheme.spacing * 2),
                      // User avatar - displays the first letter of username
                      CircleAvatar(
                        radius: isSmallScreen ? 50 : 70,
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        child: Text(
                          _username.isNotEmpty ? _username[0].toUpperCase() : '?',
                          style: AppTheme.titleLarge.copyWith(
                            color: AppTheme.primaryColor,
                            fontSize: isSmallScreen ? 32 : 48,
                          ),
                        ),
                      ),
                      SizedBox(height: AppTheme.spacing * 2),
                      // Account information card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(AppTheme.padding),
                        decoration: AppTheme.cardDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Account Information',
                              style: AppTheme.titleMedium,
                            ),
                            SizedBox(height: AppTheme.spacing),
                            _buildInfoRow(
                              icon: Icons.person,
                              label: 'Username',
                              value: _username,
                            ),
                            SizedBox(height: AppTheme.spacing),
                            _buildInfoRow(
                              icon: Icons.email,
                              label: 'Email',
                              value: _email,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppTheme.spacing * 2),
                      // Settings card with various options
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(AppTheme.padding),
                        decoration: AppTheme.cardDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Settings',
                              style: AppTheme.titleMedium,
                            ),
                            SizedBox(height: AppTheme.spacing),
                            _buildSettingTile(
                              icon: Icons.notifications,
                              title: 'Notifications',
                              onTap: _showNotificationSettings,
                            ),
                            _buildSettingTile(
                              icon: Icons.lock,
                              title: 'Privacy',
                              onTap: _showPrivacySettings,
                            ),
                            _buildSettingTile(
                              icon: Icons.help,
                              title: 'Help & Support',
                              onTap: _showHelpSupport,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppTheme.spacing * 2),
                      // Logout button
                      Container(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: AppTheme.padding,
                            ),
                          ),
                          icon: Icon(Icons.logout),
                          label: Text('Logout'),
                          onPressed: _logout,
                        ),
                      ),
                      SizedBox(height: AppTheme.spacing * 2),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  /// Helper method to build consistent info rows
  ///
  /// Creates a row with an icon, label, and value for displaying
  /// user information in a consistent format.
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        // Icon container with styled background
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.borderRadius / 2),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        SizedBox(width: AppTheme.spacing),
        // Label and value in a column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.labelMedium.copyWith(
                  color: AppTheme.greyColor,
                ),
              ),
              Text(
                value,
                style: AppTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper method to build consistent setting tiles
  ///
  /// Creates a ListTile with an icon, title, and chevron for
  /// navigation to different settings screens.
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.borderRadius / 2),
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.bodyLarge,
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppTheme.greyColor,
      ),
      onTap: onTap,
    );
  }
}
