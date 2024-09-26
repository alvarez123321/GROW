import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:intl/intl.dart'; // Importa la librería para formatear fechas
import 'dart:async';

//import 'package:mailer/mailer.dart';

class ComercializacionDatabaseHelper {
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'flutterjunctiongrow.db',
      version: 10, // ¡Incrementado por la nueva tabla y la relación!
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE crianzacard(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      fecha TEXT NOT NULL DEFAULT (STRFTIME('%d-%m-%Y %H:%M:%S', 'now', 'localtime')),
      cantidad INTEGER,
      progreso INTEGER,
      lugar TEXT,
      costoprogreso INTEGER,
      costoproducto INTEGER,
      total INTEGER,
      estado INTEGER DEFAULT 1 -- Valor por defecto de 1

)""");

    await database.execute("""
  CREATE TABLE alamcen (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    fecha TEXT NOT NULL DEFAULT (STRFTIME('%d-%m-%Y', 'now', 'localtime')),
    vendedor TEXT,
    producto TEXT,
    unidades INTEGER,
    preciou INTEGER,
    preciot INTEGER,
    pesou INTEGER,
    pesot INTEGER,
    unidadesbackup INTEGER
  )
""");

    await database.execute("""
  CREATE TABLE registro_almacen (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    fecha TEXT NOT NULL DEFAULT (STRFTIME('%d-%m-%Y', 'now', 'localtime')),  -- Fecha de creación o entrada
    fecha_consumo TEXT,  -- Fecha de consumo
    galpon TEXT,  -- Nombre o identificación del almacén
    unidades INTEGER,  -- Número de unidades
    autor TEXT,  -- Autor o responsable del registro
    producto TEXT,  -- TIPO DE PRODUCTO REGISTRADO
    observaciones TEXT  -- Observaciones adicionales
  )
""");

    await database.execute("""
  CREATE TABLE crianza(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    almacen_id INTEGER,
    sacounidades INTEGER,
    saco TEXT,
    sacoprecio INTEGER,
    sacopeso INTEGER,
    totalalimento INTEGER,
    autor TEXT,
    descripcion TEXT,
    edad INTEGER,
    peso INTEGER,
    cantidadpollos INTEGER DEFAULT 0,
    decesos INTEGER,
    createdAt TEXT NOT NULL DEFAULT (STRFTIME('%d-%m-%Y', 'now', 'localtime')),
    FOREIGN KEY (almacen_id) REFERENCES alamcen(id)
  )
""");
  }

  // Métodos para trabajar con la tabla "alamcen"
  // Métodos para trabajar con la tabla "alamcen"
  // Métodos para trabajar con la tabla "alamcen"
  // Métodos para trabajar con la tabla "alamcen"
  // Métodos para trabajar con la tabla "alamcen"

  static Future<int> createalmacen(String producto, String vendedor,
      int preciou, int preciot, int unidades, int pesou) async {
    final db = await ComercializacionDatabaseHelper.db();
    int pesot_ = pesou * unidades;
    final data = {
      'producto': producto,
      'vendedor': vendedor,
      'preciou': preciou,
      'preciot': preciot,
      'unidades': unidades,
      'unidadesbackup': unidades,
      'pesou': pesou,
      'pesot': pesot_,
    };
    final id = await db.insert('alamcen', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

// Read all productos
  static Future<List<Map<String, dynamic>>> getproductos2() async {
    final db = await ComercializacionDatabaseHelper.db();
    final resultado = await db.query('alamcen',
        orderBy: "id"); // Espera a que se complete el Future

    List<Map<String, dynamic>> productos = [];
    for (Map<String, dynamic> producto in resultado) {
      // Usa la lista obtenida
      if (producto['unidades'] != 0) {
        productos.add(producto);
      }
    }

    return productos;
  }

  // Read all producos
  static Future<List<Map<String, dynamic>>> getproductos() async {
    final db = await ComercializacionDatabaseHelper.db();
    return db.query('alamcen', orderBy: "id");
  }

  static Future<void> incrementarUnidades(int id, int cantidad) async {
    try {
      final db = await ComercializacionDatabaseHelper.db();
      final data = await db.query('alamcen', where: "id = ?", whereArgs: [id]);
      if (data.isEmpty) {
        throw Exception('No se encontró el producto');
      }

      final producto = data[0];
      int unidades = producto['unidades'] as int;

      // Incrementar unidades
      final nuevasUnidades = unidades + cantidad;

      // Actualizar la base de datos con las nuevas unidades
      final dataActualizada = {
        'unidades': nuevasUnidades,
      };
      await db
          .update('alamcen', dataActualizada, where: "id = ?", whereArgs: [id]);
    } catch (e) {
      print('Ocurrió un error: $e');
    }
  }

  static Future<void> disminuirunidades(int id, int cantidad) async {
    try {
      final db = await ComercializacionDatabaseHelper.db();
      final data = await db.query('alamcen', where: "id = ?", whereArgs: [id]);
      if (data.isEmpty) {
        throw Exception('No se encontró el producto');
      }

      final producto = data[0];
      int unidades = producto['unidades'] as int;

      if (cantidad > unidades) {
        throw Exception('No hay suficientes unidades');
      }

      final nuevasUnidades = unidades - cantidad;
      final dataActualizada = {
        'unidades': nuevasUnidades,
      };
      await db
          .update('alamcen', dataActualizada, where: "id = ?", whereArgs: [id]);
    } catch (e) {
      print('Ocurrió un error: $e');
    }
  }

  // Métodos para trabajar con la tabla conjuntas
  // Métodos para trabajar con la tabla conjuntas
  // Métodos para trabajar con la tabla conjuntas
  // Métodos para trabajar con la tabla conjuntas
  // Métodos para trabajar con la tabla conjuntas

  static Future<List<Map<String, dynamic>>> getVentasDeContacto(
      int contactoId) async {
    final db = await ComercializacionDatabaseHelper.db();
    return db.query('ventas', where: 'contactoId = ?', whereArgs: [contactoId]);
  }

  // Métodos para trabajar con la tabla "GROWcard"
  // Métodos para trabajar con la tabla "GROWcard"
  // Métodos para trabajar con la tabla "GROWcard"
  // Métodos para trabajar con la tabla "GROWcard"
  // Métodos para trabajar con la tabla "GROWcard"

  static Future<void> updateCrianzaCard(
      int id, int progreso, int costoprogreso, int cantidad) async {
    final db = await ComercializacionDatabaseHelper.db();

    await db.update(
      'crianzacard',
      {
        'progreso': progreso,
        'costoprogreso': costoprogreso,
        'cantidad': cantidad,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Función para actualizar el campo costoprogreso
  static Future<void> updateCostoProgreso(
      int id, int nuevoCostoProgreso) async {
    final db = await ComercializacionDatabaseHelper.db();

    await db.update(
      'crianzacard',
      {'costoprogreso': nuevoCostoProgreso},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> createcrianzacard(
      String lugar, int cantidad, int costoproducto) async {
    final db = await ComercializacionDatabaseHelper.db();

    final data = {
      'lugar': lugar,
      'cantidad': cantidad,
      'total': cantidad,
      'costoproducto': costoproducto,
      'costoprogreso': 0,
      'progreso': 0,
    };
    final id = await db.insert('crianzacard', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<void> deleteCrianzaCardByFecha(String fecha) async {
    final db = await ComercializacionDatabaseHelper.db();
    try {
      // Ejecutar la operación DELETE
      await db.rawDelete('DELETE FROM crianzacard WHERE fecha = ?', [fecha]);

      print('Registros eliminados correctamente.');
    } catch (e) {
      print('Error al eliminar registros: $e');
    }
  }

  // Delete a GORWcard
  static Future<void> deletegrowcard(int id) async {
    final db = await ComercializacionDatabaseHelper.db();
    try {
      await db.delete("crianzacard", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting a contacto: $err");
    }
  }

  static Future<void> updateEstadoToZero(int id) async {
    final db = await ComercializacionDatabaseHelper.db();
    try {
      // Actualiza el valor de `estado` a 0 para el registro con el `id` dado
      await db.update(
        "crianzacard",
        {"estado": 0}, // El campo `estado` se actualiza a 0
        where: "id = ?", // Condición para seleccionar el registro
        whereArgs: [id], // Argumentos para la condición
      );
    } catch (err) {
      debugPrint("Something went wrong when updating estado: $err");
    }
  }

  // Read all cardgrow
  static Future<List<Map<String, dynamic>>> getcardgrow() async {
    final db = await ComercializacionDatabaseHelper.db();
    return db.query('crianzacard', orderBy: "id");
  }

  // Read  cardgrow  mayor de cero

  static Future<List<Map<String, dynamic>>> getcardgrowWithFilter() async {
    final db = await ComercializacionDatabaseHelper.db();
    final List<Map<String, dynamic>> results = await db.query(
      'crianzacard',
      where: 'estado == 1',
      orderBy: "id",
    );
    return results;
  }

  static Future<List<Map<String, dynamic>>>
      getcardgrowWithFilterHistory() async {
    final db = await ComercializacionDatabaseHelper.db();
    final List<Map<String, dynamic>> results = await db.query(
      'crianzacard',
      where: 'estado == 0',
      orderBy: "id",
    );
    return results;
  }

  // Métodos para trabajar con la tabla "ventascard"
  // Métodos para trabajar con la tabla "ventascard"
  // Métodos para trabajar con la tabla "ventascard"
  // Métodos para trabajar con la tabla "ventascard"
  // Métodos para trabajar con la tabla "ventascard"

  // Métodos para trabajar con la tabla "contactos"
  // Métodos para trabajar con la tabla "contactos"
  // Métodos para trabajar con la tabla "contactos"
  // Métodos para trabajar con la tabla "contactos"
  // Métodos para trabajar con la tabla "contactos"

  static Future<List<Map<String, dynamic>>> compararFechas(
      int idProducto) async {
    final database = await ComercializacionDatabaseHelper.db();

    // Obtener la fecha de entrada del almacén
    final entradaAlmacen = await database
        .query('alamcen', where: 'id = ?', whereArgs: [idProducto]);
    final fechaEntradaString = entradaAlmacen.first['fecha'] as String;
    final fechaEntrada = DateFormat('dd-MM-yyyy').parse(fechaEntradaString);

    // Obtener la fecha de consumo en crianza
    final crianzaRegistros = await database
        .query('crianza', where: 'almacen_id = ?', whereArgs: [idProducto]);

    // Lista para almacenar las comparaciones
    List<Map<String, dynamic>> comparaciones = [];

    // Recorrer los registros de crianza
    for (final registro in crianzaRegistros) {
      final fechaConsumoString = registro['createdAt'] as String;
      final fechaConsumo = DateFormat('dd-MM-yyyy').parse(fechaConsumoString);

      final lugarCrianzaCard =
          await obtenerLugarCrianzaCard(registro['autor'] as String);

      // Calcular la diferencia en días
      final diferencia = fechaConsumo.difference(fechaEntrada).inDays;

      final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

// Dentro del bucle for
      final fechaEntradaFormateada = dateFormat.format(fechaEntrada);
      final fechaConsumoFormateada = dateFormat.format(fechaConsumo);

      comparaciones.add({
        'fechaEntrada': fechaEntradaFormateada,
        'fechaConsumo': fechaConsumoFormateada,
        'diferencia': diferencia,
        'lugar': lugarCrianzaCard,
      });
    }

    return comparaciones;
  }

  static Future<String?> obtenerLugarCrianzaCard(String crianzaCardId) async {
    final database = await ComercializacionDatabaseHelper.db();
    final crianzaCard = await database
        .query('crianzacard', where: 'id = ?', whereArgs: [crianzaCardId]);

    if (crianzaCard.isEmpty) {
      return null; // O manejar el caso de alguna otra manera según tu lógica de aplicación
    }

    return crianzaCard.first['lugar'] as String?;
  }

  static Future<List<Map<String, dynamic>>> obtenerDatosCrianza(
      int almacenId) async {
    final db = await ComercializacionDatabaseHelper.db();

    // Realizar una consulta JOIN para obtener los datos requeridos de la tabla crianza
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT c.createdAt, c.saco
    FROM crianza c
    JOIN alamcen a ON c.almacen_id = a.id
    WHERE c.almacen_id = ?
  ''', [almacenId]);

    return result;
  }

  // Métodos para trabajar con la tabla "registro_almacen"
  // Métodos para trabajar con la tabla "registro_almacen"
  // Métodos para trabajar con la tabla "registro_almacen"
  // Métodos para trabajar con la tabla "registro_almacen"
  // Métodos para trabajar con la tabla "registro_almacen"
  // Métodos para trabajar con la tabla "registro_almacen"

  static Future<int> createregistro_almacen(
    String fechaConsumo,
    String galpon,
    String autor,
    String observaciones,
    String producto,
    int unidades,
  ) async {
    final db = await ComercializacionDatabaseHelper.db();
    final data = {
      'fecha_consumo': fechaConsumo,
      'galpon': galpon,
      'autor': autor,
      'observaciones': observaciones,
      'producto': producto,
      'unidades': unidades,
    };
    final id = await db.insert('registro_almacen', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> get_registro_almacen(
      String producto) async {
    final db = await ComercializacionDatabaseHelper.db();

    // Realiza la consulta a la base de datos con la condición WHERE
    return await db.query(
      'registro_almacen', // Nombre de la tabla
      where:
          'producto = ?', // Condición WHERE para comparar la columna 'producto'
      whereArgs: [producto], // Argumento para la condición WHERE
      orderBy: 'id', // Ordenar por 'id'
    );
  }

  // Métodos para trabajar con la tabla "ventas"
  // Métodos para trabajar con la tabla "ventas"
  // Métodos para trabajar con la tabla "ventas"
  // Métodos para trabajar con la tabla "ventas"
  // Métodos para trabajar con la tabla "ventas"

  // Métodos para trabajar con la tabla general

//   static Future<void> backupDatabase() async {
//     final db = await ComercializacionDatabaseHelper.db();

//     final bytes = await db.exportDatabase();

//     final email = Email(
//       subject: 'Copia de seguridad de la base de datos Flutter Junction',
//       body:
//           'Esta es una copia de seguridad de la base de datos Flutter Junction.',
//       recipients: ['<email_address>'],
//       attachments: [Attachment(bytes, filename: 'flutterjunction.db')],
//     );

//     await sendEmail(email);
//   }
// }

// metodos de crianza

  static Future<int> createItem(
    String? saco,
    int? sacounidades,
    int? sacoprecio,
    int? sacopeso,
    int? almacenId, // Nueva columna para establecer la relación
    String? autor,
    String? descripcion,
    int? edad,
    int? peso,
    int? cantidadpollos,
    int? decesos,
  ) async {
    final db = await ComercializacionDatabaseHelper.db();

    final data = {
      'saco': saco,
      'sacounidades': sacounidades,
      'sacoprecio': sacoprecio,
      'sacopeso': sacopeso,
      'almacen_id': almacenId, // Nuevo parámetro para establecer la relación
      'autor': autor,
      'descripcion': descripcion,
      'edad': edad,
      'peso': peso,
      'cantidadpollos': cantidadpollos,
      'decesos': decesos,
    };

    final id = await db.insert('crianza', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  // Función para obtener todos los elementos de la tabla crianza
  static Future<List<Map<String, dynamic>>> obtenerTodosLosItems() async {
    final db = await ComercializacionDatabaseHelper.db();
    return await db.query('crianza', orderBy: 'createdAt DESC');
  }

  static Future<int> getTotaldecesos(String id) async {
    final db = await ComercializacionDatabaseHelper.db();
    final decesos = await db.query('crianza',
        columns: ['decesos'], where: 'autor = ?', whereArgs: [id]);

    int totalDecesos = 0;
    for (Map<String, dynamic> deceso in decesos) {
      final int numeroDecesos = deceso['decesos'] as int;

      totalDecesos += numeroDecesos;
    }

    return totalDecesos;
  }

  static Future<int> getUltimoPeso(String autorId) async {
    final db = await ComercializacionDatabaseHelper.db();

    final result = await db.query(
      'crianza',
      where: 'autor = ?',
      whereArgs: [autorId],
      orderBy: 'id DESC', // Ordena los resultados por ID en orden descendente
      limit:
          1, // Limita la cantidad de resultados a 1 para obtener solo el último
    );

    if (result.isNotEmpty) {
      final ultimoItem = result.first;
      return ultimoItem['peso']
          as int; // Suponiendo que la columna de peso es 'sacopeso'
    } else {
      return 0; // O cualquier otro valor entero que represente la ausencia de datos
    }
  }

  static Future<List<String>> getTiposSacos(String id) async {
    final db = await ComercializacionDatabaseHelper.db();
    final results = await db.query('crianza',
        columns: ['saco'], distinct: true, where: 'autor = ?', whereArgs: [id]);
    final tiposSacos = results.map((row) => row['saco'] as String).toList();

    return tiposSacos;
  }

  static Future<int> getTotalSacoTipos() async {
    final db = await ComercializacionDatabaseHelper.db();
    final distinctSacoTipos =
        await db.query('crianza', distinct: true, columns: ['saco']);
    return distinctSacoTipos.length;
  }

  static Future<int> getTotalPrecios(String id) async {
    final db = await ComercializacionDatabaseHelper.db();
    final sacos =
        await db.query('crianza', where: 'autor = ?', whereArgs: [id]);
    int totalPrecios = 0;
    for (Map<String, dynamic> saco in sacos) {
      totalPrecios += saco['sacoprecio'] as int;
    }
    return totalPrecios;
  }

  static Future<int> getTotalPesos(String id) async {
    final db = await ComercializacionDatabaseHelper.db();
    final sacos =
        await db.query('crianza', where: 'autor = ?', whereArgs: [id]);
    int totalPesos = 0;
    for (Map<String, dynamic> saco in sacos) {
      totalPesos += saco['sacopeso'] as int;
    }
    return totalPesos;
  }

  static Future<int> getTotalSacos(String id) async {
    // Obtiene una instancia de la base de datos a través del helper
    final db = await ComercializacionDatabaseHelper.db();

    // Realiza una consulta a la tabla 'crianza', filtrando por el campo 'autor'
    final List<Map<String, dynamic>> sacos = await db.query(
      'crianza',
      columns: ['sacounidades'], // Solo selecciona la columna 'sacounidades'
      where: 'autor = ?',
      whereArgs: [id],
    );

    // Suma las unidades de todos los registros encontrados
    int totalSacos = 0;
    for (var saco in sacos) {
      // Convierte el valor de 'sacounidades' a int antes de sumar
      totalSacos += (saco['sacounidades'] as int?) ?? 0;
    }

    // Devuelve el total de unidades
    return totalSacos;
  }

  static Future<int> getSacoWeightTotal(String sacoTipo, String id) async {
    final db = await ComercializacionDatabaseHelper.db();
    final sacos = await db.query('crianza',
        where: 'saco = ? AND autor = ?', whereArgs: [sacoTipo, id]);
    int totalWeight = 0;
    for (Map<String, dynamic> saco in sacos) {
      totalWeight += saco['sacopeso'] as int;
    }
    return totalWeight;
  }

  static Future<int> getSacoPriceTotal(String sacoTipo, String id) async {
    final db = await ComercializacionDatabaseHelper.db();
    final sacos = await db.query('crianza',
        where: 'saco = ? AND autor = ?', whereArgs: [sacoTipo, id]);
    int totalPrice = 0;
    for (Map<String, dynamic> saco in sacos) {
      totalPrice += saco['sacoprecio'] as int;
    }
    return totalPrice;
  }

  static Future<int> getSacoCount(String sacoTipo, String id) async {
    final db = await ComercializacionDatabaseHelper.db();

    // Utilizamos la función SUM de SQLite para obtener la suma de sacounidades
    final result = await db.rawQuery(
      'SELECT SUM(sacounidades) as total FROM crianza WHERE saco = ? AND autor = ?',
      [sacoTipo, id],
    );

    // El resultado es un mapa con una única entrada 'total'
    // que contiene la suma de sacounidades
    final total = result[0]['total'] as int ?? 0;

    return total;
  }

  static Future<List<Map<String, dynamic>>> getcrianzaByAuthor(
      String author) async {
    final db = await ComercializacionDatabaseHelper.db();
    return db.query('crianza',
        where: 'autor = ?', whereArgs: [author], orderBy: 'id');
  }

  // Read all crianza
  static Future<List<Map<String, dynamic>>> getcrianza() async {
    final db = await ComercializacionDatabaseHelper.db();
    return db.query('crianza', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await ComercializacionDatabaseHelper.db();
    return db.query('crianza', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id,
      String? saco,
      int? sacoprecio,
      int? sacopeso,
      String? autor,
      String? descripcion,
      int? edad,
      int? peso) async {
    final db = await ComercializacionDatabaseHelper.db();
    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    final data = {
      'saco': saco,
      'sacoprecio': sacoprecio,
      'sacopeso': sacopeso,
      'autor': autor,
      'descripcion': descripcion,
      'edad': edad,
      'peso': peso,
      'createdAt': formattedDate,
    };

    final result =
        await db.update('crianza', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await ComercializacionDatabaseHelper.db();
    try {
      await db.delete("crianza", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> eliminarCrianzaPorAutor(String autor) async {
    final db = await ComercializacionDatabaseHelper.db();
    await db.delete('crianza', where: 'autor = ?', whereArgs: [autor]);
  }
}
