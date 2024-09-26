import 'package:flutter/material.dart';
import '../../db/comercializacion_database.dart';
import 'package:intl/intl.dart';

import '../../Utils/Utils.dart';

class AddItemGrow extends StatefulWidget {
  final String fechadatacard; // Agrega el campo para almacenar el total inicial
  final int id; // Agrega el campo para almacenar el total inicial
  final String lugar; // Agrega el campo para almacenar el total inicial
  final int cantidaddatacard; // Agrega el campo para almacenar el total inicial
  final List<Map<String, dynamic>> productosp; // List
  const AddItemGrow({
    Key? key,
    required this.productosp,
    required this.fechadatacard, // Actualiza el constructor para recibir el total inicial
    required this.id, // Actualiza el constructor para recibir el total inicial
    required this.lugar, // Actualiza el constructor para recibir el total inicial
    required this.cantidaddatacard, // Actualiza el constructor para recibir el total inicial
  }) : super(key: key);

  @override
  State<AddItemGrow> createState() => _AddItemGrowState();
}

class _AddItemGrowState extends State<AddItemGrow> {
  final _formKey = GlobalKey<FormState>();
  int total = 0;
  String id_ = "";
  String galpon = "";
  String lugar = "";

  @override
  void initState() {
    super.initState();

    id_ = widget.id.toString();
    galpon = widget.id.toString();
    lugar = widget.lugar.toString();
  }

  final TextEditingController _descripcionController =
      TextEditingController(text: "na");
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _decesoController =
      TextEditingController(text: "0");
  final TextEditingController _sacoController = TextEditingController();
  final TextEditingController _unidadesController = TextEditingController();
  int _productoIdSeleccionado = 0;
  int _sacopeso = 0;
  int _sacoprecio = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(
              0, 255, 255, 255), // Cambia el color de fondo de la AppBar aquí

          title: const Text(
            "Add item grow",
            style: TextStyle(
              color: Color.fromARGB(
                  255, 0, 0, 0), // Cambia el color del texto aquí
            ),
          ),
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
                      Container(
                        child: Column(
                          children: [
                            DropdownButtonFormField(
                              decoration: const InputDecoration(
                                labelText: 'Producto',
                              ),
                              value: _sacoController.text.isNotEmpty
                                  ? _sacoController.text
                                  : null,
                              items: widget.productosp
                                  .map((productos) {
                                    return DropdownMenuItem(
                                        value: productos['producto'],
                                        child: Text(
                                            "${productos['producto']} - ${productos['fecha']}"));
                                  })
                                  .toSet()
                                  .toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _sacoController.text = newValue.toString();
                                  _unidadesController.text = '';
                                  total = 0;
                                  // Limpiar las unidades cuando se cambia el cliente
                                  _productoIdSeleccionado = widget.productosp
                                      .firstWhere((producto) =>
                                          producto['producto'] ==
                                          newValue.toString())['id'];

                                  _sacopeso = widget.productosp.firstWhere(
                                      (producto) =>
                                          producto['producto'] ==
                                          newValue.toString())['pesou'];

                                  _sacoprecio = widget.productosp.firstWhere(
                                      (producto) =>
                                          producto['producto'] ==
                                          newValue.toString())['preciou'];
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_unidadesController.text.isNotEmpty) {
                                        int unidades =
                                            int.parse(_unidadesController.text);
                                        if (unidades > 1) {
                                          _unidadesController.text =
                                              (unidades - 1).toString();
                                        }
                                      }
                                    });
                                    total =
                                        int.parse(_unidadesController.text) *
                                            _sacoprecio;
                                  },
                                  child: const Icon(Icons.remove),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: _unidadesController,
                                    decoration: const InputDecoration(
                                      labelText: 'Unidades',
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_unidadesController.text.isNotEmpty) {
                                        int unidades =
                                            int.parse(_unidadesController.text);
                                        int maxUnidades = widget.productosp
                                            .firstWhere((productos) =>
                                                productos['producto'] ==
                                                _sacoController
                                                    .text)['unidades'];
                                        if (unidades < maxUnidades) {
                                          _unidadesController.text =
                                              (unidades + 1).toString();
                                        }
                                      } else {
                                        _unidadesController.text = '1';
                                      }
                                    });
                                    total =
                                        int.parse(_unidadesController.text) *
                                            _sacoprecio;
                                  },
                                  child: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ],
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
                      TextFormField(
                        controller: _decesoController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa decesos';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Decesos',
                        ),
                      ),
                      TextFormField(
                        controller: _descripcionController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa descripcion';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Descripcion',
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
          foregroundColor: const Color.fromARGB(255, 31, 125, 28),
          // backgroundColor:
          // isFormValid ? null : const Color.fromARGB(255, 125, 39, 39),
        ),
        onPressed: _guardarproducto,
        child: const Text('Save'),
      ),
    );
  }

  Future<void> _guardarproducto() async {
    // disminuir productos de almacen
    int unidades = int.parse(_unidadesController.text);
    ComercializacionDatabaseHelper.disminuirunidades(
        _productoIdSeleccionado, unidades);

    String fechaDatacard = widget.fechadatacard;
    int daysDifference = Utils.calcularDiferenciaDeFechas(fechaDatacard);

    String producto = _sacoController.text;
    int totalpeso = int.parse(_pesoController.text);
    int deceso = int.parse(_decesoController.text);

    int totalDecesos =
        await ComercializacionDatabaseHelper.getTotaldecesos(id_);

    int resultado = (widget.cantidaddatacard - totalDecesos) - deceso;
    // int resultado = (widget.cantidaddatacard - totalDecesos) - deceso;

    DateTime now = DateTime.now(); // Obtén la fecha y hora actuales

    String formattedDate = DateFormat('dd-MM-yyyy').format(now);

    ComercializacionDatabaseHelper.createregistro_almacen(
        formattedDate, lugar, id_, " ", producto, unidades);

    ComercializacionDatabaseHelper.createItem(
            producto,
            unidades,
            _sacoprecio * unidades,
            _sacopeso * unidades,
            _productoIdSeleccionado,
            id_,
            _descripcionController.text,
            (daysDifference + 1),
            totalpeso,
            resultado,
            deceso)
        .then((id) {
      Navigator.pop(context);
    }).catchError((error) {});
  }
}
