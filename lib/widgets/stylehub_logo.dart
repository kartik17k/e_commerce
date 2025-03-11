import 'package:flutter/material.dart';
import '../config/theme.dart';

class StyleHubLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool useGradient;
  final bool isAnimated;

  const StyleHubLogo({
    Key? key,
    this.size = 120,
    this.showText = true,
    this.useGradient = true,
    this.isAnimated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logoWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: useGradient ? LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            AppTheme.secondaryColor,
          ],
        ) : null,
        color: useGradient ? null : AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white.withOpacity(0.3),
            size: size * 0.8,
          ),
          Icon(
            Icons.style_outlined,
            color: Colors.white,
            size: size * 0.5,
          ),
        ],
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isAnimated)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: Duration(milliseconds: 1000),
            curve: Curves.elasticOut,
            builder: (context, value, child) => Transform.scale(
              scale: value,
              child: child,
            ),
            child: logoWidget,
          )
        else
          logoWidget,
        if (showText) ...[
          SizedBox(height: size * 0.2),
          Text(
            'StyleHub',
            style: TextStyle(
              color: AppTheme.textColor,
              fontSize: size * 0.3,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              letterSpacing: 1.2,
            ),
          ),
          Text(
            'Fashion at your fingertips',
            style: TextStyle(
              color: AppTheme.greyColor,
              fontSize: size * 0.15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}
