import 'package:flutter/material.dart';
import '../models/venta.dart';

class HistorialVentasScreen extends StatelessWidget {
  final List<Venta> ventas;

  const HistorialVentasScreen({super.key, required this.ventas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Historial de Ventas")),
      body: ListView.builder(
        itemCount: ventas.length,
        itemBuilder: (context, index) {
          final venta = ventas[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venta.producto.nombre,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text("Cantidad: ${venta.cantidad}"),
                  Text("Total: \$${venta.total.toStringAsFixed(2)}"),
                  Text("Vendedor: ${venta.vendedor}"),
                  Text("Descripción: ${venta.descripcion.isEmpty ? 'N/A' : venta.descripcion}"),
                  Text("Tipo de Venta: ${venta.tipoVenta}"),
                  Text("Descuento: ${venta.descuento.toStringAsFixed(2)}%"),
                  Text("Fecha: ${venta.fecha.day}/${venta.fecha.month}/${venta.fecha.year}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
