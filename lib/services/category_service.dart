// category_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/categories_model.dart';

class CategoryService {
  static const String _baseUrl = 'https://congenial-succotash-7g576r4g4r53x9vp-8085.app.github.dev/api/v1/admin/categories';

  static Future<List<CategoriesModel>> fetchCategories() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => CategoriesModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}