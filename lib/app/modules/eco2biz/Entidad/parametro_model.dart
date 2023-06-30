import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:safe2biz/app/modules/dmt/Entidad/EmpleadoIncGen.dart';
import 'package:safe2biz/app/modules/eco2biz/Entidad/parametro.dart';


List<Parametro_model> employeeFromJson(String str) =>
    List<Parametro_model>.from(json.decode(str).map((x) => Parametro_model.fromJson(x)));

String employeeToJson(List<Parametro_model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Parametro_model extends Parametro {


  Parametro_model({

    required int ma_parametro_elemento_id,
    required String nombre_parametro,


  }) : super(

    ma_parametro_elemento_id:ma_parametro_elemento_id,
    nombre_parametro : nombre_parametro,



  );


  factory Parametro_model.fromJson(Map<String, dynamic> json) =>
      Parametro_model(

        ma_parametro_elemento_id : json['ma_parametro_elemento_id'] ?? 0,
        nombre_parametro: json['nombre_parametro'] ?? '',



      );



  Map<String, dynamic> toJson() => {
    'ma_parametro_elemento_id' : ma_parametro_elemento_id,
    'nombre_parametro': nombre_parametro,






  };

  Parametro_model copyWith({

    int? ma_parametro_elemento_id,
    String? nombre_parametro,





  }) =>

      Parametro_model(
        ma_parametro_elemento_id : ma_parametro_elemento_id ?? this.ma_parametro_elemento_id,
        nombre_parametro: nombre_parametro ?? this.nombre_parametro,



      );





}