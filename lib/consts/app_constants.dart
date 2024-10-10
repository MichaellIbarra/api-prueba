import 'package:flutter/material.dart';
import 'package:myapp/models/categories_model.dart';

class AppConstants {
  static const String imageUrl =
      'https://i.ibb.co/8r1Ny2n/20-Nike-Air-Force-1-07.png';

  static List<CategoriesModel> categoriesList = [
    CategoriesModel(id: 1, name: 'Phones', status: 'A'),
    CategoriesModel(id: 2, name: 'Laptops', status: 'A'),
    CategoriesModel(id: 3, name: 'Electronics', status: 'A'),
    CategoriesModel(id: 4, name: 'Watches', status: 'A'),
    CategoriesModel(id: 5, name: 'Clothes', status: 'A'),
    CategoriesModel(id: 6, name: 'Shoes', status: 'A'),
    CategoriesModel(id: 7, name: 'Books', status: 'A'),
    CategoriesModel(id: 8, name: 'Cosmetics', status: 'A'),
    CategoriesModel(id: 9, name: 'Accessories', status: 'A'),
  ];

  static List<DropdownMenuItem<int>>? get categoriesDropDownList {
    List<DropdownMenuItem<int>>? menuItem =
        List<DropdownMenuItem<int>>.generate(
      categoriesList.length,
      (index) => DropdownMenuItem(
        value: categoriesList[index].id,
        child: Text(categoriesList[index].name),
      ),
    );
    return menuItem;
  }
}