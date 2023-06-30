
import 'package:equatable/equatable.dart';

abstract class Parametro extends Equatable {
  Parametro ({
    required this.ma_parametro_elemento_id,
    required this.nombre_parametro,


  });


  /// ayc_registro_id
  int ma_parametro_elemento_id;
  String nombre_parametro;

  /// 0: create,1: online
  //String estado;
  @override
  List<Object> get props => [
    ma_parametro_elemento_id,
  ];
}


