import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:safe2biz/app/modules/eco2biz/Entidad/metales_model.dart';
import 'package:safe2biz/app/modules/eco2biz/Entidad/puntoMonitoreo_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {

  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    }
    else {
      return _db;
    }
  }

  initialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, "eco2biz.db");
    Database mydb = await openDatabase(
        path, onCreate: onCreate, version: 4, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) {
    print("onUpgrade =========");
  }

  onCreate(Database db, int version) async {

    /*EMPLEADO JSON ---- SQLite*/
    await db.execute('''
    CREATE TABLE "MuestraParametroCampo"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "id_punto" INTEGER,
    "nombre" TEXT,
    "simbolo" TEXT 
    )
    ''');

    await db.execute('''
    CREATE TABLE "PuntoMonitoreo"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "id_punto" INTEGER,
    "evidencia_uno" BLOB,
    "evidencia_dos" BLOB
    )
    ''');

    await db.execute('''
    CREATE TABLE "MuestraMetales"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "id_metal" INTEGER,
    "nombre" TEXT
    )
    ''');

    //Tabla union PuntoMonitoreo ---- MuestraMetales
    await db.execute('''
    CREATE TABLE "PuntoMetales"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "id_punto" INTEGER,
    "id_metal" INTEGER,
    "valor" INTEGER,
    "plan_punto_monitoreo_id" INTEGER,
    "gp_autoridad_id" INTEGER,
    "flag_cambio" INTEGER,
    "excepcion" TEXT,
    "descripcion" INTEGER,
    "ma_observacion_toma_muestra_id" INTEGER,
    "estado" TEXT,
    
    FOREIGN KEY (id_punto) REFERENCES PuntoMonitoreo (id_punto)
    ON DELETE NO ACTION ON UPDATE NO ACTION, 
    FOREIGN KEY (id_metal) REFERENCES MuestraMetales (id_metal)
    ON DELETE NO ACTION ON UPDATE NO ACTION
    )
    ''');

    //Tabla n
    /*


   await db.execute('''
    CREATE TABLE "MuestraMonitoreo"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "id_punto" INTEGER,
    "evidencia_uno" BLOB,
    "evidencia_dos" BLOB,

    FOREIGN KEY (id_punto) REFERENCES PuntoMonitoreo (id_punto)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (id_metal) REFERENCES MuestraMetales (id_metal)
    ON DELETE NO ACTION ON UPDATE NO ACTION
    )
    ''');


    await db.execute('''
    CREATE TABLE "PuntoCampo"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "id_punto" INTEGER,
    "id_metal" INTEGER,
    "valor" TEXT,  
    "estado" INTEGER,
    
    
    FOREIGN KEY (id_punto) REFERENCES PuntoMonitoreo (id_punto)
    ON DELETE NO ACTION ON UPDATE NO ACTION, 
    FOREIGN KEY (id_metal) REFERENCES MuestraMetales (id_metal)
    ON DELETE NO ACTION ON UPDATE NO ACTION
   
    )
    ''');

    */

    /*

    await db.execute('''
       CREATE TABLE "productoMina"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    
    "epp_producto_id" INTEGER NOT NULL,
    "epp_equipo_id" INTEGER NOT NULL,
    "fb_empleado_id" INTEGER,
    "equipo_nombre" TEXT,
    "equipo_descripcion" TEXT,
    "tipo_equipo_nombre" TEXT,
    "codigo" TEXT,
    "nombre_proveedor" TEXT,
    "marca" TEXT,
    "modelo" TEXT,
    "foto_prod" TEXT,
    "observacion" TEXT,
    "tipo_equipo_codigo" TEXT,
    "equipo_codigo" TEXT,
    "costo" REAL,
    "tiempo_recambio" INTEGER,
    "tipo_equipo_id" INTEGER
    
    )
    ''');

    await db.execute('''
    CREATE TABLE "producto_empleado_mina"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "id_empleado" INTEGER NOT NULL,
    "id_producto" INTEGER NOT NULL,
    


    
    "cantidad" INTEGER NOT NULL,
    "estado_subido" TEXT NOT NULL,
    "fecha_entrega" TEXT,
    "fecha_vigencia" TEXT,
    "hora_entrega" TEXT,
    "foto_evidencia" TEXT,
    "tipo_equipo_nombre" TEXT,
    "anho" TEXT,
    "motivo" TEXT,
    
    
    FOREIGN KEY (id_empleado) REFERENCES empleadoMina (id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
    
    FOREIGN KEY (id_producto) REFERENCES productoMina (id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
    

    
    
    )
    ''');

*/


    print("onCreate==========");
  }


//

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  readDataString(String sql) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }


  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }


  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  mydeleteDatabase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'eco2biz.db');
    await deleteDatabase(path);
  }

  createMuestraMetales(Metales_model newProduct) async {
    await deleteAllMuestraMetales();
    final db = await _db;
    final res = await db?.insert('MuestraMetales', newProduct.toJson());
    return res;
  }

  Future<int?> deleteAllMuestraMetales() async {
    final db = await _db;
    final res = await db?.rawDelete('DELETE FROM MuestraMetales');
    return res;
  }

  createpuntoMonitoreo(puntoMonitoreo_model newPunto) async {
    await deleteAllPuntoMonitoreo();
    final db = await _db;
    final res = await db?.insert('PuntoMonitoreo', newPunto.toJson());
    return res;
  }

  Future<int?> deleteAllPuntoMonitoreo() async {
    final db = await _db;
    final res = await db?.rawDelete('DELETE FROM PuntoMonitoreo');
    return res;
  }

/*
  createEmployee(EmpleadoModel newEmployee) async {
    await deleteAllEmployees();
    final db = await _db;
    final res = await db!.insert('empleadoMina', newEmployee.toJson());
    return res;
  }

  //Actualizacion
  updateEmployee(EmpleadoModel newEmployee) async {
    final db = await _db;
    final res = await db!.update('empleadoMina', newEmployee.toJson());
    return res;
  }


  createIncidentesMesTipo(inc_mensuales_tipo_model newProduct) async {
    await deleteAllIncidentesTipomes();
    final db = await _db;
    final res = await db?.insert('IncidentesMensualesTipo', newProduct.toJson());
    return res;
  }


  Future<int?> deleteAllEmployees() async {
    final db = await _db;
    final res = await db?.rawDelete('DELETE FROM empleadoMina');
    return res;
  }

  */



}
