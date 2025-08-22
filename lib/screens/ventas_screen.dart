import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../models/venta.dart';
import 'HistorialVentasScreen.dart';

class VentasScreen extends StatefulWidget {
  const VentasScreen({super.key});

  @override
  State<VentasScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  final _formKey = GlobalKey<FormState>();

  Producto? _productoSeleccionado;
  int _cantidad = 1;
  String _vendedor = "";
  String _descripcion = "";
  String _tipoVenta = "OTC / Patente";
  double _descuento = 0.0;
  DateTime _fecha = DateTime.now();

  // Historial de ventas en memoria
  final List<Venta> _historialVentas = [];

  // Catálogo de productos (ejemplo)
  final List<Producto> _productos = [
    Producto(id: 1, nombre: "Paracetamol 500mg", descripcion: "Analgésico y antipirético", antibiotico: false, requiereReceta: false, precioCompra: 5.50, precioVenta: 9.00, stock: 200, expirationDate: "2027-03-31", sku: "SKU0001", barcode: "7500000000001", brand: "Genérico", category: "Analgésico", presentation: "Tabletas x10"),
    Producto(id: 2, nombre: "Ibuprofeno 400mg", descripcion: "Antiinflamatorio y analgésico", antibiotico: false, requiereReceta: false, precioCompra: 7.20, precioVenta: 12.50, stock: 180, expirationDate: "2027-06-30", sku: "SKU0002", barcode: "7500000000002", brand: "Genérico", category: "Antiinflamatorio", presentation: "Cápsulas x10"),
    Producto(id: 3, nombre: "Naproxeno 250mg", descripcion: "Antiinflamatorio no esteroideo", antibiotico: false, requiereReceta: false, precioCompra: 8.00, precioVenta: 13.50, stock: 150, expirationDate: "2027-05-31", sku: "SKU0003", barcode: "7500000000003", brand: "Genérico", category: "Antiinflamatorio", presentation: "Tabletas x12"),
    Producto(id: 4, nombre: "Diclofenaco 50mg", descripcion: "Antiinflamatorio y analgésico", antibiotico: false, requiereReceta: false, precioCompra: 6.80, precioVenta: 11.90, stock: 170, expirationDate: "2027-08-31", sku: "SKU0004", barcode: "7500000000004", brand: "Genérico", category: "Antiinflamatorio", presentation: "Tabletas x10"),
    Producto(id: 5, nombre: "Aspirina 100mg", descripcion: "Antiagregante plaquetario", antibiotico: false, requiereReceta: true, precioCompra: 9.50, precioVenta: 15.90, stock: 120, expirationDate: "2027-09-30", sku: "SKU0005", barcode: "7500000000005", brand: "Bayer", category: "Cardiovascular", presentation: "Tabletas x30"),
    Producto(id: 6, nombre: "Omeprazol 20mg", descripcion: "Inhibidor de la bomba de protones", antibiotico: false, requiereReceta: false, precioCompra: 8.20, precioVenta: 13.90, stock: 160, expirationDate: "2027-10-31", sku: "SKU0006", barcode: "7500000000006", brand: "Genérico", category: "Gastro", presentation: "Cápsulas x14"),
    Producto(id: 7, nombre: "Pantoprazol 40mg", descripcion: "Inhibidor de la bomba de protones", antibiotico: false, requiereReceta: true, precioCompra: 10.50, precioVenta: 17.90, stock: 90, expirationDate: "2027-04-30", sku: "SKU0007", barcode: "7500000000007", brand: "Genérico", category: "Gastro", presentation: "Tabletas x14"),
    Producto(id: 8, nombre: "Metformina 850mg", descripcion: "Hipoglucemiante oral", antibiotico: false, requiereReceta: true, precioCompra: 15.00, precioVenta: 24.90, stock: 110, expirationDate: "2027-12-31", sku: "SKU0008", barcode: "7500000000008", brand: "Genérico", category: "Endocrino", presentation: "Tabletas x30"),
    Producto(id: 9, nombre: "Losartán 50mg", descripcion: "Antihipertensivo (ARA-II)", antibiotico: false, requiereReceta: true, precioCompra: 18.00, precioVenta: 29.90, stock: 100, expirationDate: "2027-11-30", sku: "SKU0009", barcode: "7500000000009", brand: "Genérico", category: "Cardiovascular", presentation: "Tabletas x30"),
    Producto(id: 10, nombre: "Atorvastatina 20mg", descripcion: "Hipolipemiante (estatinas)", antibiotico: false, requiereReceta: true, precioCompra: 22.00, precioVenta: 36.90, stock: 85, expirationDate: "2028-01-31", sku: "SKU0010", barcode: "7500000000010", brand: "Genérico", category: "Cardiovascular", presentation: "Tabletas x30"),
    Producto(id: 11, nombre: "Loratadina 10mg", descripcion: "Antihistamínico", antibiotico: false, requiereReceta: false, precioCompra: 6.00, precioVenta: 10.50, stock: 190, expirationDate: "2027-07-31", sku: "SKU0011", barcode: "7500000000011", brand: "Genérico", category: "Antialérgico", presentation: "Tabletas x10"),
    Producto(id: 12, nombre: "Cetirizina 10mg", descripcion: "Antihistamínico", antibiotico: false, requiereReceta: false, precioCompra: 6.50, precioVenta: 11.00, stock: 175, expirationDate: "2027-07-31", sku: "SKU0012", barcode: "7500000000012", brand: "Genérico", category: "Antialérgico", presentation: "Tabletas x10"),
    Producto(id: 13, nombre: "Salbutamol Inhalador 100mcg", descripcion: "Broncodilatador", antibiotico: false, requiereReceta: true, precioCompra: 45.00, precioVenta: 69.00, stock: 60, expirationDate: "2026-12-31", sku: "SKU0013", barcode: "7500000000013", brand: "Genérico", category: "Respiratorio", presentation: "Inhalador 200 dosis"),
    Producto(id: 14, nombre: "Budesónida/Formoterol Inhalador", descripcion: "Corticoide + LABA", antibiotico: false, requiereReceta: true, precioCompra: 120.00, precioVenta: 169.00, stock: 40, expirationDate: "2026-12-31", sku: "SKU0014", barcode: "7500000000014", brand: "Genérico", category: "Respiratorio", presentation: "Inhalador"),
    Producto(id: 15, nombre: "Amoxicilina 500mg", descripcion: "Antibiótico penicilina", antibiotico: true, requiereReceta: true, precioCompra: 18.00, precioVenta: 29.50, stock: 140, expirationDate: "2027-03-31", sku: "SKU0015", barcode: "7500000000015", brand: "Genérico", category: "Antibiótico", presentation: "Cápsulas x12"),
    Producto(id: 16, nombre: "Azitromicina 500mg", descripcion: "Antibiótico macrólido", antibiotico: true, requiereReceta: true, precioCompra: 25.00, precioVenta: 39.90, stock: 120, expirationDate: "2027-02-28", sku: "SKU0016", barcode: "7500000000016", brand: "Genérico", category: "Antibiótico", presentation: "Tabletas x3"),
    Producto(id: 17, nombre: "Cefalexina 500mg", descripcion: "Antibiótico cefalosporina", antibiotico: true, requiereReceta: true, precioCompra: 22.00, precioVenta: 36.00, stock: 110, expirationDate: "2027-05-31", sku: "SKU0017", barcode: "7500000000017", brand: "Genérico", category: "Antibiótico", presentation: "Cápsulas x12"),
    Producto(id: 18, nombre: "Ciprofloxacino 500mg", descripcion: "Antibiótico quinolona", antibiotico: true, requiereReceta: true, precioCompra: 24.00, precioVenta: 38.50, stock: 95, expirationDate: "2027-06-30", sku: "SKU0018", barcode: "7500000000018", brand: "Genérico", category: "Antibiótico", presentation: "Tabletas x10"),
    Producto(id: 19, nombre: "Amoxicilina/Clavulanato 875/125mg", descripcion: "Antibiótico combinado", antibiotico: true, requiereReceta: true, precioCompra: 32.00, precioVenta: 49.90, stock: 80, expirationDate: "2027-07-31", sku: "SKU0019", barcode: "7500000000019", brand: "Genérico", category: "Antibiótico", presentation: "Tabletas x14"),
    Producto(id: 20, nombre: "Doxiciclina 100mg", descripcion: "Antibiótico tetraciclina", antibiotico: true, requiereReceta: true, precioCompra: 16.00, precioVenta: 26.90, stock: 130, expirationDate: "2027-08-31", sku: "SKU0020", barcode: "7500000000020", brand: "Genérico", category: "Antibiótico", presentation: "Cápsulas x10"),
    Producto(id: 21, nombre: "Clindamicina 300mg", descripcion: "Antibiótico lincosamida", antibiotico: true, requiereReceta: true, precioCompra: 27.00, precioVenta: 42.00, stock: 70, expirationDate: "2027-09-30", sku: "SKU0021", barcode: "7500000000021", brand: "Genérico", category: "Antibiótico", presentation: "Cápsulas x16"),
    Producto(id: 22, nombre: "Levofloxacino 500mg", descripcion: "Antibiótico quinolona", antibiotico: true, requiereReceta: true, precioCompra: 28.00, precioVenta: 45.00, stock: 65, expirationDate: "2027-10-31", sku: "SKU0022", barcode: "7500000000022", brand: "Genérico", category: "Antibiótico", presentation: "Tabletas x7"),
    Producto(id: 23, nombre: "Hidrocortisona crema 1% 30g", descripcion: "Corticoide tópico", antibiotico: false, requiereReceta: false, precioCompra: 12.00, precioVenta: 19.90, stock: 90, expirationDate: "2027-01-31", sku: "SKU0023", barcode: "7500000000023", brand: "Genérico", category: "Dermatológico", presentation: "Crema 30g"),
    Producto(id: 24, nombre: "Diclofenaco gel 1% 60g", descripcion: "Antiinflamatorio tópico", antibiotico: false, requiereReceta: false, precioCompra: 14.00, precioVenta: 22.90, stock: 85, expirationDate: "2027-03-31", sku: "SKU0024", barcode: "7500000000024", brand: "Genérico", category: "Dermatológico", presentation: "Gel 60g"),
    Producto(id: 25, nombre: "Ketorolaco 10mg", descripcion: "Analgésico potente", antibiotico: false, requiereReceta: true, precioCompra: 10.00, precioVenta: 16.90, stock: 100, expirationDate: "2027-02-28", sku: "SKU0025", barcode: "7500000000025", brand: "Genérico", category: "Analgésico", presentation: "Tabletas x10"),
    Producto(id: 26, nombre: "TMP/SMX 160/800mg", descripcion: "Trimetoprim/Sulfametoxazol antibiótico", antibiotico: true, requiereReceta: true, precioCompra: 20.00, precioVenta: 32.00, stock: 90, expirationDate: "2027-04-30", sku: "SKU0026", barcode: "7500000000026", brand: "Genérico", category: "Antibiótico", presentation: "Tabletas x14"),
    Producto(id: 27, nombre: "Diazepam 5mg", descripcion: "Ansiolítico (controlado)", antibiotico: false, requiereReceta: true, precioCompra: 18.00, precioVenta: 30.00, stock: 50, expirationDate: "2027-06-30", sku: "SKU0027", barcode: "7500000000027", brand: "Genérico", category: "Neurológico", presentation: "Tabletas x20"),
    Producto(id: 28, nombre: "Omeprazol suspensión 20mg/5ml", descripcion: "Inhibidor de bomba, suspensión", antibiotico: false, requiereReceta: false, precioCompra: 16.00, precioVenta: 26.00, stock: 60, expirationDate: "2027-09-30", sku: "SKU0028", barcode: "7500000000028", brand: "Genérico", category: "Gastro", presentation: "Frasco 100ml"),
    Producto(id: 29, nombre: "Suero oral 1L", descripcion: "Rehidratación oral", antibiotico: false, requiereReceta: false, precioCompra: 12.00, precioVenta: 20.00, stock: 150, expirationDate: "2027-12-31", sku: "SKU0029", barcode: "7500000000029", brand: "Genérico", category: "Suplemento", presentation: "Bolsa 1L"),
    Producto(id: 30, nombre: "Vitamina C 500mg", descripcion: "Suplemento vitamínico", antibiotico: false, requiereReceta: false, precioCompra: 8.00, precioVenta: 13.50, stock: 140, expirationDate: "2028-03-31", sku: "SKU0030", barcode: "7500000000030", brand: "Genérico", category: "Suplemento", presentation: "Tabletas x20"),
    Producto(id: 31, nombre: "Vitamina D3 1000UI", descripcion: "Suplemento vitamínico", antibiotico: false, requiereReceta: false, precioCompra: 10.00, precioVenta: 18.00, stock: 130, expirationDate: "2028-04-30", sku: "SKU0031", barcode: "7500000000031", brand: "Genérico", category: "Suplemento", presentation: "Tabletas x30"),
    Producto(id: 32, nombre: "Calcio + Vitamina D", descripcion: "Suplemento óseo", antibiotico: false, requiereReceta: false, precioCompra: 15.00, precioVenta: 25.00, stock: 120, expirationDate: "2028-05-31", sku: "SKU0032", barcode: "7500000000032", brand: "Genérico", category: "Suplemento", presentation: "Tabletas x30"),
    Producto(id: 33, nombre: "Magnesio 250mg", descripcion: "Suplemento mineral", antibiotico: false, requiereReceta: false, precioCompra: 12.00, precioVenta: 22.00, stock: 115, expirationDate: "2028-06-30", sku: "SKU0033", barcode: "7500000000033", brand: "Genérico", category: "Suplemento", presentation: "Tabletas x20"),
    Producto(id: 34, nombre: "Zinc 50mg", descripcion: "Suplemento mineral", antibiotico: false, requiereReceta: false, precioCompra: 10.00, precioVenta: 19.50, stock: 110, expirationDate: "2028-07-31", sku: "SKU0034", barcode: "7500000000034", brand: "Genérico", category: "Suplemento", presentation: "Tabletas x20"),
    Producto(id: 35, nombre: "Multivitamínico Adulto", descripcion: "Complejo vitamínico", antibiotico: false, requiereReceta: false, precioCompra: 20.00, precioVenta: 35.00, stock: 100, expirationDate: "2028-08-31", sku: "SKU0035", barcode: "7500000000035", brand: "Genérico", category: "Suplemento", presentation: "Tabletas x30"),
    Producto(id: 36, nombre: "Melatonina 3mg", descripcion: "Regula sueño", antibiotico: false, requiereReceta: false, precioCompra: 8.00, precioVenta: 15.00, stock: 95, expirationDate: "2028-09-30", sku: "SKU0036", barcode: "7500000000036", brand: "Genérico", category: "Suplemento", presentation: "Tabletas x30"),
    Producto(id: 37, nombre: "Ginkgo Biloba 120mg", descripcion: "Mejora circulación cerebral", antibiotico: false, requiereReceta: false, precioCompra: 18.00, precioVenta: 32.00, stock: 80, expirationDate: "2028-10-31", sku: "SKU0037", barcode: "7500000000037", brand: "Genérico", category: "Suplemento", presentation: "Tabletas x30"),
    Producto(id: 38, nombre: "Omega 3 1000mg", descripcion: "Suplemento cardiovascular", antibiotico: false, requiereReceta: false, precioCompra: 25.00, precioVenta: 42.00, stock: 70, expirationDate: "2028-11-30", sku: "SKU0038", barcode: "7500000000038", brand: "Genérico", category: "Suplemento", presentation: "Cápsulas x30"),
    Producto(id: 39, nombre: "Coenzima Q10 100mg", descripcion: "Antioxidante", antibiotico: false, requiereReceta: false, precioCompra: 22.00, precioVenta: 39.00, stock: 65, expirationDate: "2028-12-31", sku: "SKU0039", barcode: "7500000000039", brand: "Genérico", category: "Suplemento", presentation: "Cápsulas x30"),
    Producto(id: 40, nombre: "Glucosamina + Condroitina", descripcion: "Salud articular", antibiotico: false, requiereReceta: false, precioCompra: 28.00, precioVenta: 49.00, stock: 60, expirationDate: "2029-01-31", sku: "SKU0040", barcode: "7500000000040", brand: "Genérico", category: "Suplemento", presentation: "Tabletas x60"),
    Producto(id: 41, nombre: "Proteína en polvo 1kg", descripcion: "Suplemento nutricional", antibiotico: false, requiereReceta: false, precioCompra: 120.00, precioVenta: 190.00, stock: 30, expirationDate: "2029-03-31", sku: "SKU0041", barcode: "7500000000041", brand: "Genérico", category: "Nutricional", presentation: "Polvo 1kg"),
    Producto(id: 42, nombre: "Creatina monohidrato 300g", descripcion: "Suplemento deportivo", antibiotico: false, requiereReceta: false, precioCompra: 60.00, precioVenta: 99.00, stock: 40, expirationDate: "2029-04-30", sku: "SKU0042", barcode: "7500000000042", brand: "Genérico", category: "Nutricional", presentation: "Polvo 300g"),
    Producto(id: 43, nombre: "BCAA 200g", descripcion: "Aminoácidos ramificados", antibiotico: false, requiereReceta: false, precioCompra: 50.00, precioVenta: 85.00, stock: 50, expirationDate: "2029-05-31", sku: "SKU0043", barcode: "7500000000043", brand: "Genérico", category: "Nutricional", presentation: "Polvo 200g"),
    Producto(id: 44, nombre: "L-Glutamina 300g", descripcion: "Aminoácido esencial", antibiotico: false, requiereReceta: false, precioCompra: 40.00, precioVenta: 70.00, stock: 55, expirationDate: "2029-06-30", sku: "SKU0044", barcode: "7500000000044", brand: "Genérico", category: "Nutricional", presentation: "Polvo 300g"),
    Producto(id: 45, nombre: "Café verde 60 cápsulas", descripcion: "Suplemento termogénico", antibiotico: false, requiereReceta: false, precioCompra: 30.00, precioVenta: 55.00, stock: 70, expirationDate: "2029-07-31", sku: "SKU0045", barcode: "7500000000045", brand: "Genérico", category: "Suplemento", presentation: "Cápsulas x60"),
    Producto(id: 46, nombre: "Extracto de té verde 60 cápsulas", descripcion: "Antioxidante y termogénico", antibiotico: false, requiereReceta: false, precioCompra: 28.00, precioVenta: 50.00, stock: 75, expirationDate: "2029-08-31", sku: "SKU0046", barcode: "7500000000046", brand: "Genérico", category: "Suplemento", presentation: "Cápsulas x60"),
    Producto(id: 47, nombre: "Ginseng 60 cápsulas", descripcion: "Energizante natural", antibiotico: false, requiereReceta: false, precioCompra: 35.00, precioVenta: 60.00, stock: 65, expirationDate: "2029-09-30", sku: "SKU0047", barcode: "7500000000047", brand: "Genérico", category: "Suplemento", presentation: "Cápsulas x60"),
    Producto(id: 48, nombre: "Vitamina B12 1000mcg", descripcion: "Suplemento energético", antibiotico: false, requiereReceta: false, precioCompra: 15.00, precioVenta: 28.00, stock: 90, expirationDate: "2029-10-31", sku: "SKU0048", barcode: "7500000000048", brand: "Genérico", category: "Suplemento", presentation: "Tabletas x30"),
    Producto(id: 49, nombre: "Ácido fólico 400mcg", descripcion: "Suplemento prenatal", antibiotico: false, requiereReceta: false, precioCompra: 10.00, precioVenta: 18.00, stock: 120, expirationDate: "2029-11-30", sku: "SKU0049", barcode: "7500000000049", brand: "Genérico", category: "Suplemento", presentation: "Tabletas x30"),
    Producto(id: 50, nombre: "Hierro 65mg", descripcion: "Suplemento mineral", antibiotico: false, requiereReceta: false, precioCompra: 12.00, precioVenta: 22.00, stock: 100, expirationDate: "2029-12-31", sku: "SKU0050", barcode: "7500000000050", brand: "Genérico", category: "Suplemento", presentation: "Tabletas x30"),
  ];

  void _registrarVenta() {
    if (_formKey.currentState!.validate()) {
      if (_productoSeleccionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Debes seleccionar un producto")),
        );
        return;
      }

      if (_cantidad > _productoSeleccionado!.stock) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Stock insuficiente. Disponible: ${_productoSeleccionado!.stock}"),
          ),
        );
        return;
      }

      double subtotal = _productoSeleccionado!.precioVenta * _cantidad;
      double descuentoAplicado = subtotal * (_descuento / 100);
      double total = subtotal - descuentoAplicado;

      // Actualizar stock y guardar venta
      int index =
      _productos.indexWhere((p) => p.id == _productoSeleccionado!.id);

      if (index != -1) {
        setState(() {
          // Crear nuevo producto con stock actualizado
          _productos[index] = Producto(
            id: _productoSeleccionado!.id,
            nombre: _productoSeleccionado!.nombre,
            sku: _productoSeleccionado!.sku,
            descripcion: _productoSeleccionado!.descripcion,
            antibiotico: _productoSeleccionado!.antibiotico,
            requiereReceta: _productoSeleccionado!.requiereReceta,
            precioCompra: _productoSeleccionado!.precioCompra,
            precioVenta: _productoSeleccionado!.precioVenta,
            stock: _productoSeleccionado!.stock - _cantidad,
            barcode: _productoSeleccionado!.barcode,
            brand: _productoSeleccionado!.brand,
            category: _productoSeleccionado!.category,
            presentation: _productoSeleccionado!.presentation,
            expirationDate: _productoSeleccionado!.expirationDate,
          );

          _productoSeleccionado = _productos[index];

          // Guardar venta en historial
          _historialVentas.add(Venta(
            producto: _productoSeleccionado!,
            cantidad: _cantidad,
            vendedor: _vendedor,
            descripcion: _descripcion,
            tipoVenta: _tipoVenta,
            descuento: _descuento,
            fecha: _fecha,
          ));
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Venta registrada: ${_productoSeleccionado!.nombre} x$_cantidad\nTotal: \$${total.toStringAsFixed(2)}"),
          ),
        );
      }
    }
  }

  void _verHistorial() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HistorialVentasScreen(ventas: _historialVentas),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Venta Farmacia"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _verHistorial,
            tooltip: "Ver Historial",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<Producto>(
                value: _productoSeleccionado,
                decoration: const InputDecoration(labelText: "Producto"),
                items: _productos.map((p) {
                  return DropdownMenuItem(
                    value: p,
                    child: Text("${p.nombre} (Stock: ${p.stock})"),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _productoSeleccionado = value),
                validator: (value) =>
                value == null ? "Seleccione un producto" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Cantidad"),
                keyboardType: TextInputType.number,
                initialValue: "1",
                validator: (value) {
                  if (value == null || value.isEmpty) return "Ingrese cantidad";
                  if (int.tryParse(value) == null) return "Debe ser un número";
                  if (int.parse(value) <= 0) return "Cantidad inválida";
                  return null;
                },
                onChanged: (value) => _cantidad = int.tryParse(value) ?? 1,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Vendedor"),
                validator: (value) =>
                value == null || value.isEmpty ? "Ingrese vendedor" : null,
                onChanged: (value) => _vendedor = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Descripción"),
                onChanged: (value) => _descripcion = value,
              ),
              DropdownButtonFormField<String>(
                value: _tipoVenta,
                decoration: const InputDecoration(labelText: "Tipo de Venta"),
                items: ["OTC / Patente", "Con Receta"]
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (value) => setState(() => _tipoVenta = value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Descuento (%)"),
                keyboardType: TextInputType.number,
                initialValue: "0",
                onChanged: (value) => _descuento = double.tryParse(value) ?? 0.0,
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Fecha de Venta",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                controller: TextEditingController(
                    text: "${_fecha.day}/${_fecha.month}/${_fecha.year}"),
                onTap: () async {
                  DateTime? fechaSeleccionada = await showDatePicker(
                    context: context,
                    initialDate: _fecha,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (fechaSeleccionada != null) {
                    setState(() {
                      _fecha = fechaSeleccionada;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarVenta,
                child: const Text("Registrar Venta"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
