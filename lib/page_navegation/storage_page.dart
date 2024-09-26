import 'package:flutter/material.dart';
import '../Utils/Utils.dart';
import '../db/comercializacion_database.dart';
import '../page_navegation/page_navegation_detail/storage_product_detail.dart';
import '../page_navegation/edit_add/add_storage.dart';
import 'page_navegation_detail/storage_page_history.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({Key? key}) : super(key: key);

  @override
  _StoragePageState createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  // Estado para almacenar el ID del contacto seleccionado
  String idContactoSeleccionado = "";

  // All data
  List<Map<String, dynamic>> myData = [];
  List<Map<String, dynamic>> mydataProductos = [];
  final formKey = GlobalKey<FormState>();

  bool _isLoading = true;

  // This function is used to fetch all data from the database
  void _refreshData() async {
    final dataProductos = await ComercializacionDatabaseHelper.getproductos();

    // final data = await ComercializacionDatabaseHelper.getVentas();

    Utils.printData(dataProductos, " items almacen");

    setState(() {
      //myData = data;
      mydataProductos = dataProductos;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData(); // Loading the data when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  const SizedBox(height: 30),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 114, 122, 166),
                        border: Border.all(
                          color: const Color.fromARGB(
                              0, 0, 0, 0), // Color del borde
                          width: 2, // Grosor del borde
                        ),
                        borderRadius: BorderRadius.circular(
                            10), // Radio de borde (opcional)S
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isLoading)
                            const Center(
                              child: CircularProgressIndicator(),
                            )
                          else if (mydataProductos.isEmpty)
                            const Center(
                              child: Text("No Data Available!!!"),
                            )
                          else
                            DataTable(
                              columns: const [
                                DataColumn(label: Text('PRODUCTO')),
                                DataColumn(label: Text('U RESTANTES')),
                                DataColumn(label: Text('U DE LLEGA')),
                                DataColumn(label: Text('PRECIO T')),
                              ],
                              rows: mydataProductos
                                  .where((data) =>
                                      data['unidades'] !=
                                      0) // Filtrar datos donde 'unidades' no sea cero
                                  .map((data) {
                                return DataRow(
                                  cells: [
                                    DataCell(InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetalleproductPage(
                                              producto: data,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(data['producto'].toString()),
                                    )),
                                    DataCell(InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetalleproductPage(
                                              producto: data,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(data['unidades'].toString()),
                                    )),
                                    DataCell(InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetalleproductPage(
                                              producto: data,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                          data['unidadesbackup'].toString()),
                                    )),
                                    DataCell(InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetalleproductPage(
                                              producto: data,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(data['preciot'].toString()),
                                    )),
                                  ],
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddStorage()),
                );
                _refreshData();
              },
            ),
          ),
          Positioned(
            bottom: 80, // Cambia la posición del segundo botón
            right: 16,
            child: FloatingActionButton(
              child: const Icon(
                  Icons.search), // Cambia el ícono según sea necesario
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const StoragePageHistory()),
                );
                _refreshData();
                // Acción para el segundo botón
                print("Botón de búsqueda presionado");
              },
            ),
          ),
        ],
      ),
    );
  }
}
