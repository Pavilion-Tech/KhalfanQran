import 'package:flutter/material.dart';

/// شعار التطبيق
class Logo extends StatelessWidget {
  final double size;
  final bool showText;

  const Logo({
    Key? key,
    this.size = 120,
    this.showText = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.menu_book,
              color: Theme.of(context).primaryColor,
              size: size * 0.6,
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 16),
          Text(
            'مركز خلفان',
            style: TextStyle(
              fontSize: size * 0.24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Text(
            'لتحفيظ القرآن الكريم',
            style: TextStyle(
              fontSize: size * 0.16,
              color: Colors.black87,
            ),
          ),
        ],
      ],
    );
  }
}