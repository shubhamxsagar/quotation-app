import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../styles/colors.dart';

class Discover extends StatelessWidget {
  final String title;
  final String text;
  final String routeName;

  const Discover({
    Key? key,
    required this.title,
    required this.text,
    required this.routeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        if (routeName != null && routeName.isNotEmpty)
          context.pushNamed(routeName);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 2),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.blackColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(Icons.description,
                      color: AppColors.whiteColor),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.displayMedium
                        ?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                    //  const TextStyle(
                    //     ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: textTheme.displayMedium
                  ?.copyWith(fontSize: 12, color: Colors.grey),
              // const TextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
