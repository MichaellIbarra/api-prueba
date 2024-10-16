import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:myapp/providers/theme_provider.dart';
import 'package:myapp/services/assets_manager.dart';
import 'package:myapp/widgets/app_name_text.dart';
import 'package:myapp/widgets/subtitle_text.dart';
import 'package:myapp/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              AssetsManager.shoppingCart,
            ),
          ),
          title: const AppNameText(),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Visibility(
                visible: false,
                child: Padding(
                  padding: EdgeInsets.all(18.0),
                  child: TitlesTextWidget(
                      label: "Please login to have unlimited access"),
                ),
              ),
              Visibility(
                visible: true,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).cardColor,
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary),
                          image: const DecorationImage(
                              image: NetworkImage(
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png"),
                              fit: BoxFit.fill),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitlesTextWidget(label: "Matichelo"),
                          SizedBox(
                            height: 5,
                          ),
                          SubtitleText(label: "michaell@vallegrande.edu.pe")
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const TitlesTextWidget(label: "General"),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomListTitle(
                        imagePath: AssetsManager.orderSvg,
                        text: "All order",
                        function: () {}),
                    CustomListTitle(
                        imagePath: AssetsManager.wishlistSvg,
                        text: "Wishlist",
                        function: () {}),
                    CustomListTitle(
                        imagePath: AssetsManager.recent,
                        text: "Viewed recently",
                        function: () {}),
                    CustomListTitle(
                        imagePath: AssetsManager.address,
                        text: "Address",
                        function: () {}),
                    const Divider(
                      thickness: 1,
                    ),
                    const TitlesTextWidget(label: "Settings"),
                    const SizedBox(
                      height: 5,
                    ),
                    SwitchListTile(
                      secondary: Image.asset(
                        AssetsManager.theme,
                        height: 30,
                      ),
                      title: Text(themeProvider.getIsDarkTheme
                          ? "Dark Mode"
                          : "Light Mode"),
                      value: themeProvider.getIsDarkTheme,
                      onChanged: (value) {
                        themeProvider.setDarkTheme(value);
                      },
                    ),
                  ],
                ),
              ),
              Center(
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0))),
                      onPressed: () {},
                      icon: const Icon(Icons.login),
                      label: const Text("Login")))
            ],
          ),
        ));
  }
}

class CustomListTitle extends StatelessWidget {
  const CustomListTitle(
      {super.key,
      required this.imagePath,
      required this.text,
      required this.function});

  final String imagePath, text;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      title: SubtitleText(label: text),
      leading: Image.asset(
        imagePath,
        height: 30,
      ),
      trailing: const Icon(IconlyLight.arrowRight2),
    );
  }
}
