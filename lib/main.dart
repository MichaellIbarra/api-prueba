// main.dart
import 'package:flutter/material.dart';
import 'package:myapp/consts/theme_data.dart';
import 'package:myapp/providers/theme_provider.dart';
import 'package:myapp/screens/admin/dashboard_screen.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/screens/admin/product/edit_upload_product_form.dart';
import 'package:myapp/screens/admin/product/search_screen.dart';
import 'package:myapp/screens/admin/user/registerPage_screen.dart';
import 'package:myapp/screens/admin/user/usersList_screen.dart';
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
            home: const HomeScreen(),
            routes: {
              SearchScreen.routeName: (context) => const SearchScreen(),
              EditOrUploadProductScreen.routeName: (context) => const EditOrUploadProductScreen(),
              DashboardScreen.routeName: (context) => const DashboardScreen(), // Define la ruta aquí
              UserslistScreen.routeName: (context) => const UserslistScreen(),
            'registrar_usuario': (_) => const RegisterPage(),
            },
          );
        }
      ),
    );
  }
}