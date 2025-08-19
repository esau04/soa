import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';

class ProductoService {
  final String baseUrl = "http://127.0.0.1:8000/api/products";

  Future<List<Producto>> getProductos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> productosJson = jsonResponse['data'];
      return productosJson.map((p) => Producto.fromJson(p)).toList();
    } else {
      throw Exception("Error al cargar productos");
    }
  }

  Future<Producto> createProducto(Producto producto) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(producto.toJson()),
    );
    if (response.statusCode == 201) {
      return Producto.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception("Error al crear producto");
    }
  }

  Future<Producto> updateProducto(Producto producto) async {
    final response = await http.put(
      Uri.parse("$baseUrl/${producto.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(producto.toJson()),
    );
    if (response.statusCode == 200) {
      return Producto.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception("Error al actualizar producto");
    }
  }

  Future<void> deleteProducto(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode != 204) {
      throw Exception("Error al eliminar producto");
    }
  }
}
