import 'package:flutter/material.dart';
import 'screens/productos_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Farmacia App",
      theme: ThemeData(primarySwatch: Colors.teal),
      home: ProductosScreen(),
    );
  }
}