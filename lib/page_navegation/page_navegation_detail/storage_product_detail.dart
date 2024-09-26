import 'package:flutter/material.dart';
import 'package:grow_granja/Utils/Utils.dart';
import 'package:grow_granja/widget/storage_product_widget.dart';
import '../../db/comercializacion_database.dart';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class DetalleproductPage extends StatefulWidget {
  final dynamic producto;

  const DetalleproductPage({
    Key? key,
    required this.producto,
  }) : super(key: key);

  @override
  _DetalleproductPageState createState() => _DetalleproductPageState();
}

class _DetalleproductPageState extends State<DetalleproductPage> {
  List<Map<String, dynamic>> productos = [];
  List<Map<String, dynamic>> productoshistorial = [];
  final bool _isLoading = false; // Definición de la variable _isLoadings

  @override
  void initState() {
    super.initState();
    _fetchProductos();
  }

  Future<void> _fetchProductos() async {
    final data4 = await ComercializacionDatabaseHelper.get_registro_almacen(
        widget.producto['producto']);

    setState(() {
      productoshistorial = data4;
      Utils.printData(
          productoshistorial, " el contador HISSTORIAL items almacen");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.producto['producto']}',
          style: const TextStyle(
            color: Color.fromARGB(209, 238, 224, 215),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  const SizedBox(height: 40),
                  Container(
                    child:
                        MyCustomDataTable_grow(myDatagrow: productoshistorial),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}
