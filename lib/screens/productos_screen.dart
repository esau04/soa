import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';
import 'producto_form_screen.dart';

class ProductosScreen extends StatefulWidget {
  @override
  _ProductosScreenState createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  final ProductoService _service = ProductoService();
  late Future<List<Producto>> _productos;
  List<Producto> _allProductos = [];
  List<Producto> _filteredProductos = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refrescarProductos();
    _searchController.addListener(_filtrarProductos);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refrescarProductos() async {
    _productos = _service.getProductos();
    final productos = await _productos;
    setState(() {
      _allProductos = productos;
      _filteredProductos = productos;
    });
  }

  void _filtrarProductos() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProductos = _allProductos.where((p) {
        return p.nombre.toLowerCase().contains(query) ||
            p.sku.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _abrirFormulario({Producto? producto}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductoFormScreen(
          producto: producto,
          onSave: _refrescarProductos,
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    _refrescarProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmacia - Productos'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o SKU...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _filteredProductos.isEmpty
            ? ListView(
          children: [Center(child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('No hay productos disponibles'),
          ))],
        )
            : ListView.builder(
          itemCount: _filteredProductos.length,
          itemBuilder: (context, index) {
            final producto = _filteredProductos[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text(producto.nombre),
                subtitle: Text(
                    'SKU: ${producto.sku}\n\$${producto.precioVenta.toStringAsFixed(2)} - Stock: ${producto.stock}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _abrirFormulario(producto: producto),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        bool confirm = await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Eliminar Producto'),
                            content: Text(
                                '¿Estás seguro que deseas eliminar "${producto.nombre}"?'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text('Cancelar')),
                              TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Eliminar')),
                            ],
                          ),
                        );
                        if (confirm) {
                          await _service.deleteProducto(producto.id);
                          _refrescarProductos();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: Icon(Icons.add),
      ),
    );
  }
}
