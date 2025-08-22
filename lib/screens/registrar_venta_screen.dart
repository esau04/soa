import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../models/venta.dart';
import '../services/producto_service.dart';
import '../services/venta_service.dart';


class RegistrarVentaScreen extends StatefulWidget {
  @override
  _RegistrarVentaScreenState createState() => _RegistrarVentaScreenState();
}

class _RegistrarVentaScreenState extends State<RegistrarVentaScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductoService _productoService = ProductoService();
  final VentaService _ventaService = VentaService();

  List<Producto> _productos = [];
  Producto? _productoSeleccionado;
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _vendedorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  void _cargarProductos() async {
    final productos = await _productoService.getProductos();
    setState(() {
      _productos = productos;
    });
  }

  void _guardarVenta() async {
    if (_formKey.currentState!.validate() && _productoSeleccionado != null) {
      final cantidad = int.parse(_cantidadController.text);
      if (cantidad > _productoSeleccionado!.stock) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No hay suficiente stock')),
        );
        return;
      }

      final fecha = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final venta = Venta(
        id: 0,
        productoId: _productoSeleccionado!.id,
        productoNombre: _productoSeleccionado!.nombre,
        cantidad: cantidad,
        precioUnitario: _productoSeleccionado!.precioVenta,
        total: cantidad * _productoSeleccionado!.precioVenta,
        fecha: fecha,
        vendedor: _vendedorController.text,
      );

      await _ventaService.createVenta(venta);

      // Actualizar stock
      _productoSeleccionado!.stock -= cantidad;
      await _productoService.updateProducto(_productoSeleccionado!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Venta registrada')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _vendedorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Venta')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: _productos.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<Producto>(
                decoration: InputDecoration(labelText: 'Producto'),
                items: _productos
                    .map((p) => DropdownMenuItem(
                  value: p,
                  child: Text('${p.nombre} - Stock: ${p.stock}'),
                ))
                    .toList(),
                onChanged: (p) => setState(() => _productoSeleccionado = p),
                validator: (value) => value == null ? 'Seleccione un producto' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _cantidadController,
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || int.tryParse(value) == null || int.parse(value) <= 0
                    ? 'Ingrese una cantidad válida'
                    : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _vendedorController,
                decoration: InputDecoration(labelText: 'Vendedor'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingrese el nombre del vendedor'
                    : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _guardarVenta,
                child: Text('Registrar Venta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
