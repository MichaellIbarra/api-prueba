import 'package:flutter/material.dart';
import 'package:myapp/providers/theme_provider.dart';
import 'package:myapp/root_screen.dart';
import 'package:myapp/screens/admin/dashboard_screen.dart';
import 'package:myapp/services/assets_manager.dart';
import 'package:myapp/widgets/title_text.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AssetsManager.shoppingCart, height: 200),
            const SizedBox(height: 30.0),
            const TitlesTextWidget(label: "Bienvenidos al Restaurante"),
            const SizedBox(height: 30.0),
            ElevatedButton(
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RootScreen()),
    );
  },
  child: const Text("Login"),
),
            const SizedBox(height: 30.0),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, DashboardScreen.routeName);
                },
                child: const Text("Admin")),
          ],
        ),
      ),
    );
  }
}
