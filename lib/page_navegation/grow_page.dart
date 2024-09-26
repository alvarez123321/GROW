import 'package:flutter/material.dart';
import "../widget/grow_card_widget.dart";
import '../page_navegation/edit_add/add_grow.dart';
import '../../db/comercializacion_database.dart';
import 'page_navegation_detail/grow_card_detail.dart';

import '../../Utils/Utils.dart';
import 'page_navegation_detail/growth_page_history.dart';

class GrowPage extends StatefulWidget {
  const GrowPage({super.key});

  @override
  _GrowPageState createState() => _GrowPageState();
}

class _GrowPageState extends State<GrowPage> {
  // All data
  List<Map<String, dynamic>> myData = [];
  List<Map<String, dynamic>> myDatagrow = [];

  final formKey = GlobalKey<FormState>();

  bool _isLoading = true;
  void _refreshData() async {
    final data = await ComercializacionDatabaseHelper.getcardgrowWithFilter();
    // final data = await ComercializacionDatabaseHelper.getcardgrow();
    final data2 = await ComercializacionDatabaseHelper.getcrianza();
    final data3 = await ComercializacionDatabaseHelper.obtenerTodosLosItems();

    Utils.printData(data, " items grow");

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
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddGrow()),
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
                      builder: (context) => const GrowPageHistory()),
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
