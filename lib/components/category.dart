import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../styles/colors.dart';

class Category extends StatelessWidget {
  final String title;
  final IconData iconName;
  final String routeName;

  const Category({
    Key? key,
    required this.title,
    required this.iconName,
    required this.routeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        if (routeName != null && routeName.isNotEmpty)
          context.pushNamed(routeName);
      },
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 2),
              ],
            ),
            child: Icon(iconName, size: 30),
          ),
          const SizedBox(height: 10),
          Text(
            title.toUpperCase(),
            style: textTheme.displayMedium
                ?.copyWith(fontSize: 12, fontWeight: FontWeight.w500),

            //  const TextStyle(),
          ),
        ],
      ),
    );
  }
}
