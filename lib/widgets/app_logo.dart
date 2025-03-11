import 'package:flutter/material.dart';
import '../config/theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool useGradient;

  const AppLogo({
    Key? key,
    this.size = 40,
    this.showText = true,
    this.useGradient = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
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
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
            size: size * 0.6,
          ),
        ),
        if (showText) ...[
          SizedBox(width: size * 0.2),
          Text(
            'StyleHub',
            style: TextStyle(
              color: AppTheme.textColor,
              fontSize: size * 0.6,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ],
    );
  }
}
