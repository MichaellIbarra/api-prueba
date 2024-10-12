// import 'package:myapp/screens/inner_screen/orders/orders_screen.dart';

import 'package:flutter/material.dart';
import 'package:myapp/screens/edit_upload_product_form.dart';
import 'package:myapp/screens/search_screen.dart';

import '../services/assets_manager.dart';

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
          text: "Add a new product",
          imagePath: AssetsManager.menu,
          onPressed: () {
            Navigator.pushNamed(context, EditOrUploadProductScreen.routeName);
          },
        ),
        DashboardButtonsModel(
          text: "ver Productos",
          imagePath: AssetsManager.shoppingCart,
          onPressed: () {
            Navigator.pushNamed(context, SearchScreen.routeName);
          },
        ),
        DashboardButtonsModel(
          text: "Usuarios",
          imagePath: AssetsManager.shoppingCart,
          onPressed: () {
            // Navigator.pushNamed(context, SearchScreen.routeName);
          },
        ),
      ];
}
