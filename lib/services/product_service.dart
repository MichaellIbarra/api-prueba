import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/product_model.dart';

class ProductService {
  static const String _baseUrl = 'http://localhost:8085/api/v1/admin/products';

  Future<void> saveProduct(ProductModel product, {required bool isEditing}) async {
    final url = Uri.parse(_baseUrl);
    final request = http.MultipartRequest('POST', url)
      ..fields['id'] = product.productId ?? ''
      ..fields['idCategory'] = product.idCategory.toString()
      ..fields['imageUrl'] = product.productImage ?? ''
      ..fields['name'] = product.productTitle
      ..fields['description'] = product.productDescription
      ..fields['price'] = product.productPrice
      ..fields['status'] = product.status ?? 'A';

    if (product.imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', product.imageFile!.path));
    }

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to save product');
    }
  }
}