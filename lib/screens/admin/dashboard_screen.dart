// dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/models/dashboard_btn_model.dart';
import 'package:myapp/providers/theme_provider.dart';
import 'package:myapp/services/assets_manager.dart';
import 'package:myapp/widgets/dashboard_btns.dart';
import 'package:myapp/widgets/title_text.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard'; // Define la ruta aquí

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(label: "Dashboard Admin"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.shoppingCart),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(
          DashboardButtonsModel.dashboardBtnList(context).length,
          (index) => DashboardButtonsWidget(
            text: DashboardButtonsModel.dashboardBtnList(context)[index].text,
            imagePath: DashboardButtonsModel.dashboardBtnList(context)[index].imagePath,
            onPressed: DashboardButtonsModel.dashboardBtnList(context)[index].onPressed,
          ),
        ),
      ),
    );
  }
}