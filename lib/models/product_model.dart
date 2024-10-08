import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  final String? productId;
  final String productTitle;
  final String productPrice;
  final String productCategory;
  final String productDescription;
  final String? productImage;
  final String productQuantity;
  final String? status;
  final File? imageFile;

  ProductModel({
    this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productCategory,
    required this.productDescription,
    this.productImage,
    required this.productQuantity,
    this.status,
    this.imageFile,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': productId,
      'name': productTitle,
      'price': productPrice,
      'idCategory': productCategory,
      'description': productDescription,
      'imageUrl': productImage,
      'quantity': productQuantity,
      'status': status ?? 'A',
    };
  }
}