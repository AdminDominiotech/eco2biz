import 'dart:convert';

import 'package:safe2biz/app/modules/eco2biz/Entidad/puntoMonitoreo.dart';


List<puntoMonitoreo_model> employeeFromJson(String str) =>
    List<puntoMonitoreo_model>.from(json.decode(str).map((x) => puntoMonitoreo_model.fromJson(x)));

String employeeToJson(List<puntoMonitoreo_model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class puntoMonitoreo_model extends puntoMonitoreo {


  puntoMonitoreo_model({

    required int id_punto,
    required String nombre,


  }) : super(

      id_punto: id_punto,
      nombre: nombre


  );


  factory puntoMonitoreo_model.fromJson(Map<String, dynamic> json) =>
      puntoMonitoreo_model(

        id_punto: json['id_punto'] ?? 0,
        nombre: json['nombre'] ?? '',

      );


  Map<String, dynamic> toJson() => {
    'id_punto': id_punto,
    'nombre' : nombre,
  };

  puntoMonitoreo_model copyWith({

    int? id_punto,
    String? nombre,

  }) =>

      puntoMonitoreo_model(
          id_punto: id_punto ?? this.id_punto,
          nombre:nombre ?? this.nombre

      );
}