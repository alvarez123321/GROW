import 'package:flutter/material.dart';
import '../../widget/grow_card_widget.dart';
import '../edit_add/add_grow.dart';
import '../../db/comercializacion_database.dart';
import 'grow_card_detail.dart';

import '../../Utils/Utils.dart';

class GrowPageHistory extends StatefulWidget {
  const GrowPageHistory({super.key});

  @override
  _GrowPageHistoryState createState() => _GrowPageHistoryState();
}

class _GrowPageHistoryState extends State<GrowPageHistory> {
  // All data
  List<Map<String, dynamic>> myData = [];
  List<Map<String, dynamic>> myDatagrow = [];

  final formKey = GlobalKey<FormState>();

  bool _isLoading = true;
  void _refreshData() async {
    final data =
        await ComercializacionDatabaseHelper.getcardgrowWithFilterHistory();
    final data2 = await ComercializacionDatabaseHelper.getcrianza();
    final data3 = await ComercializacionDatabaseHelper.obtenerTodosLosItems();

    Utils.printData(data, " items grow history");

    setState(() {
      myData = data;
      myDatagrow = data2;
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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(
            0, 255, 255, 255), // Cambia el color de fondo de la AppBar aquí

        title: const Text(
          'Historial ',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ), // Ajusta el espacio horizontal y vertical

        child: ListView.separated(
          separatorBuilder: (context, index) =>
              const SizedBox(height: 10), // Espacio entre elementos
          itemCount: myData.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () async {
              try {
                final growsData =
                    await ComercializacionDatabaseHelper.getcrianzaByAuthor(
                  myData[index]["id"].toString(),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalleGrowPage(
                      data_card: myData[index],
                      grows_data: growsData,
                    ),
                  ),
                ).then((_) => _refreshData());
              } catch (error) {
                print('Error al obtener datos de crianza: $error');
              }
            },
            child: MyCustomCard(grow: myData[index]),
          ),
        ),
      ),
    );
  }
}
