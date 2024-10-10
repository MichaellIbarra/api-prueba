import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  final int id, idCategory;
  final String imageUrl, name, description,status;
  final double price;


  ProductModel({
    required this.id,
    required this.idCategory,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.price,
    required this.status,
  }); 
}
