
import 'package:equatable/equatable.dart';

abstract class Metales extends Equatable {
  Metales ({
    required this.id_metal,                  //81014
    required this.nombre
  });

  /// ayc_registro_id
  int id_metal;
  String nombre;

  /// 0: create,1: online
  //String estado;
  @override
  List<Object> get props => [
    id_metal,
    nombre
  ];
}


