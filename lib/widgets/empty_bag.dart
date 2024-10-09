import 'package:flutter/material.dart';
import 'package:myapp/widgets/subtitle_text.dart';
import 'package:myapp/widgets/title_text.dart';

class EmptyBag extends StatelessWidget {
  const EmptyBag({super.key, required this.imagePath, required this.title, required this.subtitle, required this.buttonText});
  final String imagePath, title, subtitle, buttonText;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Image.asset(
            imagePath,
            width: double.infinity,
            height: size.height * 0.35,
          ),
          const SizedBox(
            height: 20,
          ),
          const TitlesTextWidget(
            label: "Whoops!",
            fontSize: 40,
            color: Colors.red,
          ),
          const SizedBox(
            height: 20,
          ),
         SubtitleText(
            label: title,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(
            height: 20,
          ),
         Padding(
            padding: const EdgeInsets.all(14.0),
            child: SubtitleText(
              label:
                  subtitle,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1, vertical: 15)),
              onPressed: () {},
              child: Text(buttonText))
        ],
      ),
    );
  }
}
