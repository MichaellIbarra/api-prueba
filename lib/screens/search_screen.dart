import 'package:flutter/material.dart';
import 'package:myapp/widgets/title_text.dart';

class SearchScreen extends StatelessWidget {
    static const routeName = '/SearchScreen';

  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: TitlesTextWidget(label: "Search Screen"),
      ),
    );
  }
}