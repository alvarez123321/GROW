import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:grow_granja/widget/progreso_grow_widget.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import '../../Utils/Utils.dart';
import '../../db/comercializacion_database.dart';
import '../edit_add/add_item_grow.dart';
import "/../widget/resumen_progreso_widget.dart";
import "/../widget/comparacion_grow.dart";

class DetalleGrowPage extends StatefulWidget {
  final dynamic data_card;
  final List<Map<String, dynamic>> grows_data;

  const DetalleGrowPage({
    Key? key,
    required this.data_card,
    required this.grows_data,
  }) : super(key: key);

  @override
  _DetalleGrowPageState createState() => _DetalleGrowPageState();
}

class _DetalleGrowPageState extends State<DetalleGrowPage> {
  List<Map<String, dynamic>> myDatagrow = [];
  List<Map<String, dynamic>> productos = [];

  bool _isLoading = true; // Definición de la variable _isLoading

  String noteId_ = "";
  int noteId = 0;

  double getTotalPrecios = 0;
  int getUltimoPeso = 0;
  int fecha_edad = 0;
  double getTotalconsumo = 0;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(
            0, 255, 255, 255), // Cambia el color de fondo de la AppBar aquí

        actions: [
          buildButton(
            context,
            'Finalizar',
            const Color.fromARGB(255, 0, 0, 0),
            const Color.fromRGBO(101, 101, 101, 1),
            () =>
                finalizar(context), // Nueva función específica para este botón
          ),
          buildButton(
            context,
            'Delete',
            const Color.fromARGB(255, 0, 0, 0),
            const Color.fromRGBO(181, 157, 0, 1),
            () => eliminar(context), // Nueva función específica para este botón
          ),
        ],

        title: Text(
          widget.data_card['lugar'].toString(),
          style: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            executeFunctionBeforePop(context);
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        Utils.mostrarModal(
                          context,
                        );
                      },
                      child: const Text('Mostrar Modal'),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    child: MyCustomDataTable_grow(myDatagrow: myDatagrow),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    child: MyCustomDataTable(noteId_: noteId_),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    child: ChickenDataTable(
                      fechaEdad: fecha_edad,
                      ultimoPeso: getUltimoPeso,
                      totalPrecios: getTotalPrecios,
                      totalConsumo: getTotalconsumo,
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
      floatingActionButton: widget.data_card['estado'] == 1
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddItemGrow(
                      productosp: productos,
                      id: widget.data_card['id'],
                      lugar: widget.data_card['lugar'],
                      fechadatacard: widget.data_card['fecha'],
                      cantidaddatacard: widget.data_card['total'],
                    ),
                  ),
                );
                _refreshData();
              },
            )
          : null, // Si la condición no se cumple, no se muestra ningún botón flotante.
    );
  }

  void executeFunctionBeforePop(BuildContext context) {
    _refreshData();

    int totalSum = 0;
    int totalSumsacoprecio = 0;
    int totaltoal = 0;

    String fechaDatacard = widget.data_card['fecha'];
    int daysDifference = Utils.calcularDiferenciaDeFechas(fechaDatacard);

    int totalrestante = widget.data_card['total'] - totalSum;
    for (Map<String, dynamic> myDatagrow in myDatagrow) {
      int totalValue = myDatagrow['sacoprecio'] as int;
      totalSumsacoprecio += totalValue;
    }

    for (Map<String, dynamic> myDatagrow in myDatagrow) {
      int totalValue = myDatagrow['decesos'] as int;
      totalSum += totalValue;
    }

    totaltoal = widget.data_card['costoproducto'] + totalSumsacoprecio;

    ComercializacionDatabaseHelper.updateCrianzaCard(noteId,
        (daysDifference + 1), totaltoal, widget.data_card['total'] - totalSum);

    Navigator.pop(context);
  }

  Widget buildButton(
    context,
    title,
    colorLetra,
    colorFondo,
    VoidCallback action, // Nuevo parámetro
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: colorLetra, backgroundColor: colorFondo),
        onPressed: action, // Usa el parámetro action
        child: Text(title),
      ),
    );
  }

  void finalizar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirmar finalizar proceso"),
          content:
              const Text("¿Estás seguro de que deseas eliminar esta venta?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text("aceptar"),
              onPressed: () {
                ComercializacionDatabaseHelper.updateEstadoToZero(noteId)
                    .then((id) {
                  Navigator.of(dialogContext).pop();
                  Navigator.pop(context);
                }).catchError((error) {
                  print("Error al eliminar la venta: $error");
                });
              },
            ),
          ],
        );
      },
    );
  }

  void eliminar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirmar Eliminación"),
          content:
              const Text("¿Estás seguro de que deseas eliminar esta venta?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text("Eliminar"),
              onPressed: () {
                String fechadelete = widget.data_card['fecha'];
                ComercializacionDatabaseHelper.eliminarCrianzaPorAutor(noteId_);

                ComercializacionDatabaseHelper.deleteCrianzaCardByFecha(
                        fechadelete)
                    .then((id) {
                  Navigator.of(dialogContext).pop();
                  Navigator.pop(context);
                }).catchError((error) {
                  print("Error al eliminar la venta: $error");
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _refreshData() async {
    noteId_ = widget.data_card['id'].toString();
    noteId = widget.data_card['id'];
    final data3 = await ComercializacionDatabaseHelper.getproductos2();

    final data2 =
        await ComercializacionDatabaseHelper.getcrianzaByAuthor(noteId_);
    Utils.printData(data2, " items de consumo grow");

    getUltimoPeso = await ComercializacionDatabaseHelper.getUltimoPeso(noteId_);
    getTotalPrecios =
        (((await ComercializacionDatabaseHelper.getTotalPesos(noteId_) * 1000) /
                widget.data_card['cantidad']) /
            getUltimoPeso);
    getTotalconsumo =
        (((await ComercializacionDatabaseHelper.getTotalPesos(noteId_) * 1000) /
            widget.data_card['cantidad']));
    String totalPreciosString = getTotalPrecios.toStringAsFixed(2);
    String getTotalconsumoString = getTotalconsumo.toStringAsFixed(2);
    getTotalPrecios = double.parse(totalPreciosString);
    getTotalconsumo = double.parse(getTotalconsumoString);
    fecha_edad = widget.data_card['progreso'];

    setState(() {
      productos = data3;
      myDatagrow = data2;
      _isLoading = false; // Cambio del estado de _isLoading a false
    });
  }
}
