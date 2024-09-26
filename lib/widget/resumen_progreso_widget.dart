import 'package:flutter/material.dart';
import '../../db/comercializacion_database.dart';

class MyCustomDataTable extends StatefulWidget {
  final String noteId_;

  const MyCustomDataTable({super.key, required this.noteId_});

  @override
  _MyCustomDataTableState createState() => _MyCustomDataTableState();
}

class _MyCustomDataTableState extends State<MyCustomDataTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<String>>(
        future: ComercializacionDatabaseHelper.getTiposSacos(widget.noteId_),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los datos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No hay tipos de sacos disponibles'));
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Saco')),
                  DataColumn(label: Text('uds.')),
                  DataColumn(label: Text('Peso')),
                  DataColumn(label: Text('Costo')),
                ],
                rows: snapshot.data!.map((sacoTipo) {
                  return DataRow(cells: [
                    DataCell(Text(sacoTipo)),
                    DataCell(_buildFutureBuilder(
                        ComercializacionDatabaseHelper.getSacoCount(
                            sacoTipo, widget.noteId_))),
                    DataCell(_buildFutureBuilder(
                      ComercializacionDatabaseHelper.getSacoWeightTotal(
                          sacoTipo, widget.noteId_),
                      additionalText: " kg",
                    )),
                    DataCell(_buildFutureBuilder(
                      ComercializacionDatabaseHelper.getSacoPriceTotal(
                          sacoTipo, widget.noteId_),
                      prefixText: "S/ ",
                    )),
                  ]);
                }).toList()
                  ..add(
                    DataRow(cells: [
                      const DataCell(Text(
                        'TOTAL',
                        style:
                            TextStyle(color: Color.fromARGB(255, 99, 12, 12)),
                      )),
                      DataCell(
                        _buildFutureBuilder(
                          ComercializacionDatabaseHelper.getTotalSacos(
                              widget.noteId_),
                          color: const Color.fromARGB(
                              255, 99, 12, 12), // Color rojo
                        ),
                      ),
                      DataCell(
                        _buildFutureBuilder(
                          ComercializacionDatabaseHelper.getTotalPesos(
                              widget.noteId_),
                          color: const Color.fromARGB(
                              255, 99, 12, 12), // Color rojo
                          additionalText: " kg", // Texto adicional
                        ),
                      ),
                      DataCell(
                        _buildFutureBuilder(
                          ComercializacionDatabaseHelper.getTotalPrecios(
                              widget.noteId_),
                          color: const Color.fromARGB(
                              255, 99, 12, 12), // Color rojo
                          prefixText: "S/ ", // Texto antes del valor
                        ),
                      ),
                    ]),
                  ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildFutureBuilder(Future<dynamic> future,
      {Color? color, String? additionalText, String? prefixText}) {
    return FutureBuilder<dynamic>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(
            'Error al cargar los datos',
            style: TextStyle(color: color), // Aplicar el color aquí
          );
        } else if (!snapshot.hasData) {
          return Text(
            'Cargando...',
            style: TextStyle(color: color), // Aplicar el color aquí
          );
        } else {
          // Aquí deberías manejar la conversión a int si es posible
          int? dataAsInt = snapshot.data as int?;
          if (dataAsInt != null) {
            String valueText =
                '$dataAsInt'; // Inicializar el texto con el valor
            if (additionalText != null) {
              valueText +=
                  ' $additionalText'; // Agregar texto adicional si está presente
            }
            if (prefixText != null) {
              valueText =
                  '$prefixText$valueText'; // Agregar prefijo si está presente
            }
            return Text(
              valueText,
              style: TextStyle(color: color), // Aplicar el color aquí
            );
          } else {
            return Text(
              'Error: No se pudo convertir a int',
              style: TextStyle(color: color), // Aplicar el color aquí
            );
          }
        }
      },
    );
  }
}
