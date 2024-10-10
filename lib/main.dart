import 'package:flutter/material.dart';
import 'package:myapp/consts/theme_data.dart';
import 'package:myapp/providers/theme_provider.dart';
import 'package:myapp/root_screen.dart';
import 'package:myapp/screens/edit_upload_product_form.dart';
import 'package:myapp/screens/search_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return ThemeProvider();
        })
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'La Chancha',
            theme: Styles.themeData(isDarkTheme: themeProvider.getIsDarkTheme, context: context),
            home: const RootScreen(),
              routes: {
              SearchScreen.routeName: (context) => const SearchScreen(), // Define la ruta aquí
                EditOrUploadProductScreen.routeName: (context) =>
                const EditOrUploadProductScreen(),
            },
          );
        }
      ),
    );
  }
}
