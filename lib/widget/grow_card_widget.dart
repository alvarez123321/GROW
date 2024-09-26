import 'package:flutter/material.dart';

class MyCustomCard extends StatefulWidget {
  final Map<String, dynamic> grow;

  const MyCustomCard({
    Key? key,
    required this.grow,
  }) : super(key: key);

  @override
  _MyCustomCardState createState() => _MyCustomCardState();
}

class _MyCustomCardState extends State<MyCustomCard> {
  int progress = 0;
  int edad = 60;

  @override
  void initState() {
    super.initState();

    // Mover el código a initState
    progress = widget.grow['progreso'];
  }

  @override
  Widget build(BuildContext context) {
    Color progressBarColor = Colors.green; // Color por defecto

    double progreso = widget.grow['progreso'] / edad;

    if (progreso >= 43 / edad && progreso <= 1) {
      progressBarColor = Colors.purple; // Morado
    } else if (progreso >= 32 / edad && progreso < 43 / edad) {
      progressBarColor = Colors.red; // Rojo
    } else if (progreso >= 22 / edad && progreso < 32 / edad) {
      progressBarColor =
          const Color.fromARGB(255, 215, 130, 3); // Naranja oscuro
    } else if (progreso >= 7 / edad && progreso < 22 / edad) {
      progressBarColor =
          const Color.fromARGB(255, 242, 255, 64); // Naranja claro
    } else if (progreso >= 0 && progreso < 7 / edad) {
      progressBarColor = Colors.green; // Verde
    }

    return SizedBox(
      height: 190, // Establece una altura específica para el contenedor
      child: Card(
        color: const Color.fromARGB(161, 249, 252, 235),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.star_border),
              title: Text(
                widget.grow['lugar'],
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                'Apple: ${widget.grow['cantidad']}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'S/. ${widget.grow['costoprogreso']}',
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Fecha: ${widget.grow['fecha'].toString().substring(0, 10)}',
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'progreso : ${widget.grow['progreso']?.toString() ?? 'N/A'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progreso,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
