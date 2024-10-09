import 'package:flutter/material.dart';
import 'package:myapp/widgets/title_text.dart';
import 'package:shimmer/shimmer.dart';

class AppNameText extends StatelessWidget {
  const AppNameText({super.key, this.fontSize = 20});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        period: const Duration(seconds: 12),
        baseColor: const Color.fromARGB(255, 136, 255, 0),
        highlightColor: Colors.orange,
        child: TitlesTextWidget(
          label: "La Chancha",
          fontSize: fontSize,
        ));
  }
}
