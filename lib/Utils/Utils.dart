import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../widget/ChickenData.dart'; // Importa la clase ChickenData

class Utils {
  static int calcularDiferenciaDeFechas(String fechaDatacard) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    DateTime fechaDateTimeNow = DateFormat('dd-MM-yyyy').parse(formattedDate);
    DateTime fechaDateTime = DateFormat('dd-MM-yyyy').parse(fechaDatacard);
    Duration difference = fechaDateTimeNow.difference(fechaDateTime);
    return difference.inDays;
  }

  static void printData(List<Map<String, dynamic>> data, String nombre) {
    print('\n');
    print('\n');

    print(
        "_________________________________________________________________________");
    print(
        "|                                                                        |");

    print("pagina : $nombre");
    for (var row in data) {
      print(row); // Imprime la fila actual
      print('\n');
    }
    print(
        "|_______________________________________________________________________|");
    print('\n');
    print('\n');
  }

  static void printDatalist(dynamic data, String nombre) {
    print('\n');
    print('\n');
    print(
        "_________________________________________________________________________");
    print(
        "|                                                                        |");
    print("Pagina : $nombre");
    print(data); // Imprime el dato específico
    print(
        "|_______________________________________________________________________|");
    print('\n');
    print('\n');
  }

  static void mostrarModal(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Datos de Pollo'),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: double.maxFinite,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Índice')),
                  // DataColumn(label: Text('Conversion de Alimento')),
                  DataColumn(label: Text('Peso por Edad')),
                  // DataColumn(label: Text('Consumo')),
                ],
                rows: chickenData.foodConversion.asMap().entries.map((entry) {
                  int index =
                      entry.key + 1; // Añadir 1 al índice para empezar en 1
                  double foodConversion = entry.value;
                  int weightForAge = chickenData.weightForAge[index -
                      1]; // Ajustar el índice para obtener el valor correspondiente
                  int consumption = chickenData.consumption[index -
                      1]; // Ajustar el índice para obtener el valor correspondiente
                  return DataRow(cells: [
                    DataCell(Text(index.toString())),
                    // DataCell(Text(foodConversion.toString())),
                    DataCell(Text(weightForAge.toString())),
                    // DataCell(Text(consumption.toString())),
                  ]);
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
