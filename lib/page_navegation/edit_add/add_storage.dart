import 'package:flutter/material.dart';
import '../../db/comercializacion_database.dart';

class AddStorage extends StatefulWidget {
  const AddStorage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddStorage> createState() => _AddStorageState();
}

class _AddStorageState extends State<AddStorage> {
  final _formKey = GlobalKey<FormState>();
  double total = 0.00;
  final TextEditingController _productoController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _precioUnitarioController =
      TextEditingController();
  final TextEditingController _unidadesController = TextEditingController();
  final TextEditingController _precioTotalController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _unidadesController.addListener(_actualizarTotal);
    _precioUnitarioController.addListener(_actualizarTotal);
  }

  @override
  void dispose() {
    _unidadesController.dispose();
    _precioUnitarioController.dispose();
    super.dispose();
  }

  void _actualizarTotal() {
    setState(() {
      final cantidad = double.tryParse(_unidadesController.text) ?? 0;
      final cantidad2 = double.tryParse(_precioUnitarioController.text) ?? 0;
      total = cantidad2 * cantidad; // Actualiza total con el valor de cantidad
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Add strage"),
          actions: [buildButton()],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              Container(
                alignment:
                    Alignment.center, // Centra el contenido del Container

                child: Text(
                  '$total',
                  style: const TextStyle(fontSize: 60),
                ),
              ),
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
                      // Container(
                      //   child: FutureBuilder<List<Map<String, dynamic>>>(
                      //     future: ComercializacionDatabaseHelper.getContactos(),
                      //     builder: (context, snapshot) {
                      //       if (snapshot.connectionState ==
                      //           ConnectionState.waiting) {
                      //         // Mientras espera a que se complete el Future
                      //         return SizedBox(); // o Container(), para mantener el espacio reservado
                      //       } else {
                      //         if (snapshot.hasError) {
                      //           // Si hay un error al obtener los datos
                      //           return Text('Error al cargar datos');
                      //         } else {
                      //           // Cuando el Future se completa exitosamente
                      //           List<Map<String, dynamic>> myDatacontacto =
                      //               snapshot.data ?? [];
                      //           return DropdownButtonFormField(
                      //             decoration: InputDecoration(
                      //               labelText: 'Cliente',
                      //             ),
                      //             value: _clienteController.text.isNotEmpty
                      //                 ? _clienteController.text
                      //                 : null,
                      //             items: myDatacontacto.map((contacto) {
                      //               return DropdownMenuItem(
                      //                 value: contacto['nombre'],
                      //                 child: Text(contacto['nombre']),
                      //               );
                      //             }).toList(),
                      //             onChanged: (newValue) {
                      //               setState(() {
                      //                 _clienteController.text =
                      //                     newValue.toString();
                      //               });
                      //             },
                      //           );
                      //         }
                      //       }
                      //     },
                      //   ),
                      // ),
                      TextFormField(
                        controller: _productoController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa el producto';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Producto',
                        ),
                      ),

                      TextFormField(
                        controller: _unidadesController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa las unidades';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Unidades',
                        ),
                      ),

                      TextFormField(
                        controller: _precioUnitarioController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa el precio U.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Precio unitario',
                        ),
                      ),

                      TextFormField(
                        controller: _pesoController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa peso';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Peso',
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
          foregroundColor: const Color.fromARGB(255, 125, 40, 28),
          // backgroundColor:
          // isFormValid ? null : const Color.fromARGB(255, 125, 39, 39),
        ),
        onPressed: _guardarproducto,
        child: const Text('Save'),
      ),
    );
  }

  Future<void> _guardarproducto() async {
    // int cantidad = int.parse(_precioUnitarioController.text);
    // double total = double.parse(_totalController.text);
    // String contacto = _clienteController.text;
    print("___________________ADDD STORAGE");
    print(_productoController.text);
    print(_precioUnitarioController.text);
    print(total);
    print(_unidadesController.text);
    print(_pesoController.text);
    print("___________________ADDD STORAGE");

    String producto = _productoController.text;
    String vendedor = "pepe";
    int preciou = int.parse(_precioUnitarioController.text);
    int preciot = total.toInt();
    int cantidad = int.parse(_unidadesController.text);
    int peso = int.parse(_pesoController.text);

    ComercializacionDatabaseHelper.createalmacen(
            producto, vendedor, preciou, preciot, cantidad, peso)
        .then((id) {
      // Venta guardada exitosamente
      // Aquí podrías mostrar un mensaje, redirigir a otra página, etc.
      Navigator.pop(context);
    }).catchError((error) {
      // Manejo de errores}
    });
  }
}
