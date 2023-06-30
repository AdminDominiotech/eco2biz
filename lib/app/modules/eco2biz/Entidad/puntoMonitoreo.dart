
import 'package:equatable/equatable.dart';

abstract class puntoMonitoreo extends Equatable {
  puntoMonitoreo ({
    required this.id_punto,                  //81014
    required this.nombre
  });


  /// ayc_registro_id
  int id_punto;
  String nombre;


  /// 0: create,1: online
  //String estado;
  @override
  List<Object> get props => [
    id_punto,
    nombre
  ];
}





