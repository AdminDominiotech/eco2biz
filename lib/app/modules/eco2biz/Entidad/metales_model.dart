import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:safe2biz/app/modules/dmt/Entidad/EmpleadoIncGen.dart';
import 'package:safe2biz/app/modules/eco2biz/Entidad/metales.dart';
import 'package:safe2biz/app/modules/eco2biz/Entidad/parametro.dart';


List<Metales_model> employeeFromJson(String str) =>
    List<Metales_model>.from(json.decode(str).map((x) => Metales_model.fromJson(x)));

String employeeToJson(List<Metales_model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Metales_model extends Metales {


  Metales_model({

    required int id_metal,
    required String nombre,


  }) : super(

    id_metal : id_metal,
    nombre: nombre,



  );


  factory Metales_model.fromJson(Map<String, dynamic> json) =>
      Metales_model(

        id_metal: json['ma_parametro_elemento_id'] ?? 0,
        nombre: json['nombre'] ?? '',



      );



  Map<String, dynamic> toJson() => {
    'ma_parametro_elemento_id': id_metal,
    'nombre' : nombre
  };


  Metales_model copyWith({

    int? id_punto,
    String? nombre,

  }) =>

      Metales_model(

          id_metal: id_punto ?? this.id_metal,
        nombre: nombre ?? this.nombre

      );





}