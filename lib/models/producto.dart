class Producto {
  final int id;
  final String nombre;
  final String sku;
  final String? descripcion;
  final bool antibiotico;
  final bool requiereReceta;
  final double precioCompra;
  final double precioVenta;
  final int stock;
  final String? barcode;
  final String? brand;
  final String? category;
  final String? presentation;
  final String? expirationDate;

  Producto({
    required this.id,
    required this.nombre,
    required this.sku,
    this.descripcion,
    required this.antibiotico,
    required this.requiereReceta,
    required this.precioCompra,
    required this.precioVenta,
    required this.stock,
    this.barcode,
    this.brand,
    this.category,
    this.presentation,
    this.expirationDate,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['name'],
      sku: json['sku'],
      descripcion: json['description'],
      antibiotico: json['is_antibiotic'] ?? false,
      requiereReceta: json['requires_prescription'] ?? false,
      precioCompra: double.parse(json['cost_price'].toString()),
      precioVenta: double.parse(json['sale_price'].toString()),
      stock: json['stock'],
      barcode: json['barcode'],
      brand: json['brand'],
      category: json['category'],
      presentation: json['presentation'],
      expirationDate: json['expiration_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': nombre,
      'sku': sku,
      'description': descripcion,
      'is_antibiotic': antibiotico,
      'requires_prescription': requiereReceta,
      'cost_price': precioCompra,
      'sale_price': precioVenta,
      'stock': stock,
      'barcode': barcode,
      'brand': brand,
      'category': category,
      'presentation': presentation,
      'expiration_date': expirationDate,
    };
  }
}
