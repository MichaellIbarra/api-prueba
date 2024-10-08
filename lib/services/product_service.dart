// product_service.dart
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProductService {
  static const String _baseUrl = 'https://friendly-spork-6j5vqr7jp5wfx6r5-8085.app.github.dev/api/v1/admin/products';

  static Future<void> saveProduct({
    required int idCategory,
    required String imageUrl,
    required String name,
    required String description,
    required double price,
    required String status,
    XFile? image,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));
    request.fields['id'] = '0'; // Assuming id is generated by the backend
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
}