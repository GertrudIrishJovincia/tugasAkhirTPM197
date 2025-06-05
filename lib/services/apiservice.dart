import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class Apiservice {
  static const String url =
      'https://67fa2a35094de2fe6ea3553e.mockapi.io/api/v1/products';

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Product.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchProductsByCategory(
    String category,
  ) async {
    final response = await http.get(Uri.parse('$url?category=$category'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(
        'Data products for category $category: $jsonResponse',
      ); // Log data yang diterima
      return jsonResponse
          .map(
            (data) => {
              "id": data['id'],
              "productName": data['product_name'],
              "productPrice": data['product_price'],
              "productImage": data['product_image'],
              "category": data['category'],
            },
          )
          .toList();
    } else {
      throw Exception('Failed to load products for category: $category');
    }
  }

  static Future<Product> fetchProductById(String id) async {
    final response = await http.get(Uri.parse('$url/$id'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return Product.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load product with ID: $id');
    }
  }
}
