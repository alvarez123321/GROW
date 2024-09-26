import 'package:flutter/material.dart';
import '../../db/comercializacion_database.dart';

class AddGrow extends StatefulWidget {
  const AddGrow({
    Key? key,
  }) : super(key: key);

  @override
  State<AddGrow> createState() => _AddGrowState();
}

class _AddGrowState extends State<AddGrow> {
  final _formKey = GlobalKey<FormState>();
  double total = 0.00;
  final TextEditingController _lugarController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _costoproductoController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(0, 33, 149, 243),
                  border: Border.all(
                    color: const Color.fromARGB(0, 0, 0, 0), // Color del borde
                    width: 2, // Grosor del borde
                  ),
                  borderRadius:
                      BorderRadius.circular(10), // Radio de borde (opcional)
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _cantidadController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa la Unidades';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Cantidad',
                        ),
                      ),
                      TextFormField(
                        controller: _lugarController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa el lugar';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Lugar',
                        ),
                      ),
                      TextFormField(
                        controller: _costoproductoController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa el Precio caja';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Precio caja',
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildButton() {
    // final isFormValid = title.isNotEmpty && description.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color.fromARGB(255, 33, 33, 33),
          // backgroundColor:
          // isFormValid ? null : const Color.fromARGB(255, 125, 39, 39),
        ),
        onPressed: _guardarVenta,
        child: const Text('GUARDAR'),
      ),
    );
  }

  Future<void> _guardarVenta() async {
    // Lógica para guardar la venta utilizando los datos de los controladores
    //DateTime fecha = DateTime.now(); // Ejemplo de cómo obtener la fecha actual

    String lugar = _lugarController.text;
    int cantidad = int.parse(_cantidadController.text);
    int costoproducto = int.parse(_costoproductoController.text);
    ComercializacionDatabaseHelper.createcrianzacard(
            lugar, cantidad, costoproducto)
        .then((id) {
      // Venta guardada exitosamente
      // Aquí podrías mostrar un mensaje, redirigir a otra página, etc.
      Navigator.pop(context);
    }).catchError((error) {
      // Manejo de errores}
    });
  }
}
