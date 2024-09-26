import 'package:flutter/material.dart';

import '../../db/comercializacion_database.dart';

class MyCustomDataTable_grow extends StatelessWidget {
  final List<Map<String, dynamic>> myDatagrow;

  const MyCustomDataTable_grow({Key? key, required this.myDatagrow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        color: const Color.fromARGB(255, 151, 156, 129),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Fecha de Registro')),
                //  DataColumn(label: Text('Fecha de Consumo')),
                DataColumn(label: Text('Galpón')),
                DataColumn(label: Text('producto')),
                DataColumn(label: Text('Unidades')),
                //  DataColumn(label: Text('Observaciones')),
              ],
              rows: myDatagrow.map((myDatagrow) {
                print(myDatagrow);
                return DataRow(
                  cells: [
                    DataCell(Text(myDatagrow['id'].toString())),
                    DataCell(Text(myDatagrow['fecha'] ?? '')),
                    // DataCell(Text(map['fecha_consumo'] ?? '')),
                    DataCell(Text(myDatagrow['galpon'] ?? '')),
                    DataCell(Text(myDatagrow['producto'] ?? '')),
                    DataCell(Text(myDatagrow['unidades'].toString())),
                    //  DataCell(Text(myDatagrow['observaciones'] ?? '')),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
