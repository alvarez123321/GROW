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
                DataColumn(label: Text('FECHA')),
                DataColumn(label: Text('EDAD')),
                DataColumn(label: Text('PESO')),
                DataColumn(label: Text('SACO')),
                DataColumn(label: Text('SACO UNIDADES')),
                DataColumn(label: Text('DESCRIPCION')),
                DataColumn(label: Text('U POLLOS')),
                DataColumn(label: Text('DECESOS')),
                DataColumn(label: Text('ACTIONS')),
              ],
              rows: myDatagrow.map((myDatagrow) {
                print(myDatagrow);
                return DataRow(
                  cells: [
                    DataCell(Text(myDatagrow['createdAt'])),
                    DataCell(
                      Text(
                        myDatagrow['edad'].toString(),
                        style: TextStyle(
                          color: myDatagrow['edad'] > 41
                              ? Colors.pink
                              : myDatagrow['edad'] > 21
                                  ? const Color.fromARGB(255, 40, 107, 42)
                                  : Colors.black,
                        ),
                      ),
                    ),
                    DataCell(Text(myDatagrow['peso'].toString())),
                    DataCell(Text(myDatagrow['saco'])),
                    DataCell(Text(myDatagrow['sacounidades'].toString())),
                    DataCell(SizedBox(
                        width: 100, child: Text(myDatagrow['descripcion']))),
                    DataCell(Text(myDatagrow['cantidadpollos'].toString())),
                    DataCell(
                      Text(myDatagrow['decesos'].toString()),
                    ),
                    DataCell(
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'eliminar') {
                            deleteItem(myDatagrow['id'], context);
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'eliminar',
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Eliminar'),
                            ),
                          ),
                        ],
                        icon: const Icon(Icons.more_vert),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void deleteItem(int id, context) async {
    final data3 = await ComercializacionDatabaseHelper.getItem(id);

    int almacenId = data3[0]['almacen_id'] as int;
    int sacoUnidades = data3[0]['sacounidades'] as int;

    ComercializacionDatabaseHelper.incrementarUnidades(almacenId, sacoUnidades);
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
              onPressed: () async {
                await ComercializacionDatabaseHelper.deleteItem(id);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
