import 'producto.dart';

class Venta {
  final Producto producto;
  final int cantidad;
  final String vendedor;
  final String descripcion;
  final String tipoVenta;
  final double descuento;
  final DateTime fecha;

  Venta({
    required this.producto,
    required this.cantidad,
    required this.vendedor,
    required this.descripcion,
    required this.tipoVenta,
    required this.descuento,
    required this.fecha,
  });

  double get subtotal => producto.precioVenta * cantidad;

  double get total => subtotal * (1 - descuento / 100);
}
