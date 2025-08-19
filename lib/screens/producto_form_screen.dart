import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';

class ProductoFormScreen extends StatefulWidget {
  final Producto? producto;
  final Function() onSave;

  ProductoFormScreen({this.producto, required this.onSave});

  @override
  _ProductoFormScreenState createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends State<ProductoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductoService _productoService = ProductoService();

  late TextEditingController _nombreController;
  late TextEditingController _skuController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioCompraController;
  late TextEditingController _precioVentaController;
  late TextEditingController _stockController;
  late bool _antibiotico;
  late bool _requiereReceta;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.producto?.nombre ?? '');
    _skuController = TextEditingController(text: widget.producto?.sku ?? '');
    _descripcionController = TextEditingController(text: widget.producto?.descripcion ?? '');
    _precioCompraController = TextEditingController(text: widget.producto?.precioCompra.toString() ?? '');
    _precioVentaController = TextEditingController(text: widget.producto?.precioVenta.toString() ?? '');
    _stockController = TextEditingController(text: widget.producto?.stock.toString() ?? '');
    _antibiotico = widget.producto?.antibiotico ?? false;
    _requiereReceta = widget.producto?.requiereReceta ?? false;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _skuController.dispose();
    _descripcionController.dispose();
    _precioCompraController.dispose();
    _precioVentaController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.producto == null ? 'Nuevo Producto' : 'Editar Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) => value!.isEmpty ? 'Ingrese el nombre' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _skuController,
                decoration: InputDecoration(labelText: 'SKU'),
                validator: (value) => value!.isEmpty ? 'Ingrese el SKU' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _precioCompraController,
                decoration: InputDecoration(labelText: 'Precio de Compra'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value!.isEmpty || double.tryParse(value) == null
                    ? 'Ingrese un número válido'
                    : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _precioVentaController,
                decoration: InputDecoration(labelText: 'Precio de Venta'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value!.isEmpty || double.tryParse(value) == null
                    ? 'Ingrese un número válido'
                    : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty || int.tryParse(value) == null
                    ? 'Ingrese un número válido'
                    : null,
              ),
              SwitchListTile(
                title: Text('Es Antibiótico'),
                value: _antibiotico,
                onChanged: (val) => setState(() => _antibiotico = val),
              ),
              SwitchListTile(
                title: Text('Requiere Receta'),
                value: _requiereReceta,
                onChanged: (val) => setState(() => _requiereReceta = val),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                child: Text('Guardar'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      Producto producto = Producto(
                        id: widget.producto?.id ?? 0,
                        nombre: _nombreController.text,
                        sku: _skuController.text,
                        descripcion: _descripcionController.text,
                        antibiotico: _antibiotico,
                        requiereReceta: _requiereReceta,
                        precioCompra: double.parse(_precioCompraController.text),
                        precioVenta: double.parse(_precioVentaController.text),
                        stock: int.parse(_stockController.text),
                      );

                      if (widget.producto == null) {
                        await _productoService.createProducto(producto);
                      } else {
                        await _productoService.updateProducto(producto);
                      }

                      widget.onSave();
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
