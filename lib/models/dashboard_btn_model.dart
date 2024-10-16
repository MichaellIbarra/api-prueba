// import 'package:myapp/screens/inner_screen/orders/orders_screen.dart';

import 'package:flutter/material.dart';
import 'package:myapp/screens/admin/product/search_screen.dart';
import 'package:myapp/services/assets_manager.dart';


class DashboardButtonsModel {
  final String text, imagePath;
  final Function onPressed;

  DashboardButtonsModel({
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });

  static List<DashboardButtonsModel> dashboardBtnList(context) => [
        DashboardButtonsModel(
          text: "Productos",
          imagePath: AssetsManager.menu,
          onPressed: () {
            Navigator.pushNamed(context, SearchScreen.routeName);
          },
        ),
        DashboardButtonsModel(
          text: "Usuarios",
          imagePath: AssetsManager.person,
          onPressed: () {
            // Navigator.pushNamed(context, SearchScreen.routeName);
          },
        ),
      ];
}
