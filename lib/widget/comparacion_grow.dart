import 'package:flutter/material.dart';
import '../../widget/ChickenData.dart'; // Importa la clase ChickenData

class ChickenDataTable extends StatelessWidget {
  final int fechaEdad;
  final int ultimoPeso;
  final double totalPrecios;
  final double totalConsumo;

  const ChickenDataTable({
    super.key,
    required this.fechaEdad,
    required this.ultimoPeso,
    required this.totalPrecios,
    required this.totalConsumo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'PESO',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'CONVERSION',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'CONSUMO',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: <DataRow>[
          DataRow(
            cells: <DataCell>[
              DataCell(
                Center(
                  child: Text(chickenData.weightForAge[fechaEdad].toString()),
                ),
              ),
              DataCell(
                Center(
                  child: Text(chickenData.foodConversion[fechaEdad].toString()),
                ),
              ),
              DataCell(
                Center(
                  child: Text(chickenData.consumption[fechaEdad].toString()),
                ),
              ),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(
                Center(
                  child: Text(ultimoPeso.toString()),
                ),
              ),
              DataCell(
                Center(
                  child: Text(totalPrecios.toString()),
                ),
              ),
              DataCell(
                Center(
                  child: Text(totalConsumo.toString()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
