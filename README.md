# Flutter E-Commerce App

A modern e-commerce mobile application built with Flutter, featuring Material 3 design system, responsive layouts, and seamless integration with the Fake Store API. The app demonstrates best practices in mobile design and development while providing a rich shopping experience.

## Key Features

### Authentication & Security
- Secure login and signup system
- Token-based authentication
- Persistent session management
- Demo credentials available for testing
- Form validation and error handling

### Shopping Experience
- Product catalog with responsive grid layout
- Real-time shopping cart management
  - Dynamic quantity updates
  - Live total calculation
  - Responsive cart layout
- Product details with optimized views
- User profile management

### Responsive Design
Each screen adapts to different device sizes:
- **Mobile** (< 600px)
  - Vertical stacked layouts
  - Full-width cards
  - Optimized touch targets
- **Tablet** (600px - 1200px)
  - Adaptive grid layouts
  - Balanced white space
  - Optimized navigation
- **Desktop** (> 1200px)
  - Horizontal layouts
  - Side-by-side product details
  - Enhanced cart experience

## Design System

### Typography
- Font Family: Poppins
- Hierarchy:
  - Title Large: 24px (Bold)
  - Title Medium: 20px (SemiBold)
  - Body Large: 16px (Medium)
  - Body Medium: 14px (Regular)
  - Label: 10-12px (Medium)

### Components
- **Cards**
  - Elevation: 2dp
  - Border Radius: 12px
  - Subtle shadows
- **Buttons**
  - Primary: Solid background
  - Text: No elevation
  - Consistent padding
- **Inputs**
  - White background
  - Outlined style
  - Icon prefixes
  - Validation states

### Color System
- Primary: `#2962FF` (Blue)
- Secondary: `#0D47A1` (Dark Blue)
- Accent: `#82B1FF` (Light Blue)
- Text: `#1F1F1F` (Near Black)
- Grey: `#757575`
- Background: `#F5F5F5`

## Tech Stack

### Frontend
- **Framework**: Flutter & Dart
- **State Management**: Built-in setState
- **Navigation**: Flutter Navigator 2.0
- **Storage**: SharedPreferences

### Backend Integration
- **API**: FakeStore API
- **Authentication**: JWT tokens
- **Network**: http package
- **Data Format**: JSON

## Project Structure
```
lib/
├── config/
│   └── theme.dart         # Global theme configuration
├── screens/
│   ├── login_screen.dart  # Authentication UI
│   ├── cart_screen.dart   # Shopping cart
│   ├── home_screen.dart   # Product listing
│   └── signup_screen.dart # User registration
├── widgets/
│   ├── app_logo.dart      # Custom app logo
│   └── app_icon_generator.dart # Icon generation
└── ...
```

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/kartik17k/e_commerce.git
cd e_commerce
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Demo Access
Use these credentials to test the app:
- Username: `johnd`
- Password: `m38rmF$`

## Development Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Material 3 Design Guidelines](https://m3.material.io/)
- [FakeStore API Documentation](https://fakestoreapi.com/docs)

## License

This project is licensed under the MIT License - see the LICENSE file for details.
