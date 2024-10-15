// product_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/services/config.dart';

class ProductService {
  static const String _baseUrl = '$baseUrl/api/v1/admin/products';
  static const String _inactiveProduct = '$baseUrl/api/v1/admin/products/inactive';

  static Future<void> saveProduct({
    int? id,
    required int idCategory,
    required String imageUrl,
    required String name,
    required String description,
    required double price,
    required String status,
    XFile? image,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));
    if (id != null) {
      request.fields['id'] = id.toString();
    } else {
      request.fields['id'] = '0';
    }
    request.fields['idCategory'] = idCategory.toString();
    request.fields['imageUrl'] = imageUrl;
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['price'] = price.toString();
    request.fields['status'] = status;

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to save product');
    }
  }

  static Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<List<ProductModel>> fetchInactiveProducts() async {
    final response = await http.get(Uri.parse(_inactiveProduct));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load inactive products');
    }
  }
}