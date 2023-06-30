import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:safe2biz/app/global/controllers/auth_controller.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/auth/features/login/data/models/user_model.dart';
import 'package:safe2biz/app/modules/auth/features/login/domain/entities/user.dart';
import 'package:safe2biz/app/modules/eco2biz/toma_muestras_monitoreo/MuestrasMonitoreoDetalle.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';

class MuestrasMonitoreo extends StatefulWidget {
  const MuestrasMonitoreo({Key? key}) : super(key: key);

  @override
  State<MuestrasMonitoreo> createState() => _MuestrasMonitoreoState();
}

final auth = GetIt.I<AuthController>();



class _MuestrasMonitoreoState extends State<MuestrasMonitoreo> {


  @override
  void initState(){
    super.initState();
  }

  void asyncMethod(String idPunto) async{
    List<Map> asistenciaCurso = await sqlDb.readData(
        "SELECT * FROM PuntoMetales WHERE PuntoMetales.id_punto = '${idPunto}' ");
  }

  @override
  Widget build(BuildContext context) {

    String urlExt = '';
    String urlApp = '';
    String arroba = '';
    String empresa = '';
    String idUser = '';
    String idFbEmp = '';
    if (auth.user.value != null) {
      urlExt = auth.user.value!.urlExt;
      urlApp = auth.user.value!.urlApp;
      arroba = auth.user.value!.arroba;
      empresa = auth.user.value!.enterprise;
      idUser = auth.user.value!.uuid;
      idFbEmp = auth.user.value!.fbEmpleadoId;
    }

    return Scaffold(
      appBar: AppBarBack("Muestras de Monitoreo"),
    body:  Column(
        children: [
          Expanded(
            child: FutureBuilder(

              future: RequestPuntosMonitoreo(),
    builder: (BuildContext ctx, AsyncSnapshot<List> snapshot) =>
    snapshot.hasData ? ListView.builder(
    itemCount: snapshot.data!.length,
    itemBuilder: (BuildContext context, index) {

      Color porTomar= Color(0xffF4BA19);
      Color tomado = Color(0xff9DCB47);
      Color? colorEstado;

      String flagCambio= '${snapshot.data![index]['referencia']}'; //flag_cambio
      String? estado; //Tomado, Por evaluar

      if(flagCambio == null || flagCambio.isEmpty || flagCambio == 'null'){
        estado = 'Por Evaluar';
        colorEstado = porTomar;
      }else if (flagCambio != null || flagCambio.isNotEmpty || flagCambio != 'null'){
        estado = 'Tomado';
        colorEstado = tomado;
      }

            return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [

                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MuestraMonitoreoDetalle(

                                    punto_monitoreo: "${snapshot.data![index]['punto_monitoreo']}",
                                    clasificacion_elemento: "${snapshot.data![index]['clasificacion_elemento']}",
                                    plan_monitoreo: "${snapshot.data![index]['plan_monitoreo']}",
                                    grupo_monitoreo: "${snapshot.data![index]['grupo_monitoreo']}",
                                    elemento: "${snapshot.data![index]['elemento']}",
                                    punto_id: "${snapshot.data![index]['punto_id']}",
                                    plan_monitoreo_id: "${snapshot.data![index]['plan_monitoreo_id']}",
                                    grupo_monitoreo_id: "${snapshot.data![index]['grupo_monitoreo_id']}",
                                    plan_punto_monitoreo_id: "${snapshot.data![index]['plan_punto_monitoreo_id']}",
                                    gp_autoridad_id : "${snapshot.data![index]['gp_autoridad_id']}",
                                    estado: estado,
                                    color: colorEstado
                                ),
                              ),
                           );
                        },
                      child: Container(
                        child: Row(
                            children: [
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0),
                                    ),
                                  ),
                                  elevation: 5,
                                  child:
                                  Padding(
                                    padding: EdgeInsets.only(right: 10.0, top: 0.0, bottom: 0.0),
                                    child: IntrinsicHeight(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width*1,
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 12,
                                                height: double.infinity,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: colorEstado,  //color Estado
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(10),
                                                        bottomLeft: Radius.circular(10)
                                                    ),
                                                  ),
                                                )
                                              ),
                                            SizedBox(width: 10,),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top:8.0, bottom: 8.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text("${snapshot.data![index]['punto_monitoreo']}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0XFF4B82B9)),),  //Punto Monitoreo

                                                        Container(
                                                            width: 105,
                                                            height: 25,
                                                            child: ElevatedButton(onPressed: (){
                                                              print("fbEmp  ---  ${idFbEmp}"
                                                                  "  uuid   ---  ${idUser}");
                                                            },
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor: colorEstado,
                                                                ),
                                                                child: FittedBox(child: Text("$estado", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14) )  ))),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text("${snapshot.data![index]['clasificacion_elemento']}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0XFF006DB5)),),   // Clasificación del Elemento --Grupos de monitoreo
                                                        //  Image.asset("${ambitoImg}", width: 20,),
                                                      ],
                                                    ),
                                                    SizedBox(height: 4,),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: Text("Ubicado en la margen izquierda del Rio Uchucchacua a 200 mts del puente El Pedregal", maxLines: 2, style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.6),))
                                                      ],
                                                    ),
                                                    Divider(height: 10,),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [

                                                         Align(
                                                           alignment: Alignment.centerLeft,
                                                           child: Text("${snapshot.data![index]['plan_monitoreo']}",
                                                                maxLines: 2, style: TextStyle(fontSize: 11,  height: 1.5), textAlign: TextAlign.start,   //Codigo Planes de Monitoreo
                                                              ),
                                                         ),

                                                        SizedBox(height: 2,),
                                                        Divider(height: 7,),
                                                        SizedBox(height: 2,),

                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [

                                                            Row(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text("GRUPO:   ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10, ),),
                                                                  ],
                                                                ),
                                                                Container(
                                                                    child:
                                                                    Text("${snapshot.data![index]['grupo_monitoreo']}", style: TextStyle(fontSize: 9,  fontWeight: FontWeight.bold),)   //Grupo de Monitoreo
                                                                )
                                                              ],
                                                            ),

                                                             Container(
                                                               height: 25,
                                                               child: Visibility(
                                                                 visible: false,
                                                                 child: Row(
                                                                   children: [
                                                                     IconButton(icon: FaIcon(FontAwesomeIcons.upload,size: 15, color: Color(0xff09357E),) ,


                                                                         onPressed: () async{

                                                                       AwesomeDialog(
                                                                         context: context,
                                                                             animType: AnimType.leftSlide,
                                                                             headerAnimationLoop: false,
                                                                             dialogType:
                                                                             DialogType.success,
                                                                             showCloseIcon: true,
                                                                             title: 'Registrado',
                                                                             desc:
                                                                             'El registro se ha subido con éxito !',
                                                                             btnOkOnPress: () {

                                                                               setState((){
                                                                                 estado = 'Tomado';
                                                                                 colorEstado = Colors.green;
                                                                               });

                                                                             },
                                                                             btnOkIcon: Icons.check_circle,
                                                                             onDismissCallback: (type) {
                                                                               debugPrint(
                                                                                   'Dialog Dissmiss from callback $type');
                                                                             },
                                                                           ).show();


                                                                           var data =[];
                                                                           Future <http.Response> postParametroPlanificado() async {
                                                                             var url = 'https://app.eco2biz.com/eco2biz/ws/null/pr_ws_inserta_planificacion';
                                                                             var map = new Map<String, dynamic>();
                                                                                 map['plan_monitoreo_id'] =   "${snapshot.data![index]['plan_monitoreo_id']}";
                                                                                 map['plan_punto_monitoreo_id'] =   "${snapshot.data![index]['plan_punto_monitoreo_id']}";
                                                                                 map['gp_autoridad_id'] = "${snapshot.data![index]['gp_autoridad_id']}";
                                                                                 //parametro elemento
                                                                                 map['parametro_elemento_id'] = "0";
                                                                                 map['frecuencia_tipo_id'] = '3';
                                                                                 map['clasificacion_id'] = '8';
                                                                                 map['punto_monitoreo_id'] = "${snapshot.data![index]['punto_monitoreo']}";
                                                                                 map['descripcion'] = '0';
                                                                                 map['usuario_id'] = '${idUser}';

                                                                                 //FIXME: ma_parametro_ejecutado --- valores de cada parametro que puede ser medido

                                                                             //datoEntregaProd.first["fecha_entrega"].substring(0,10)
                                                                             final response2 = await http.post(Uri.parse(url),

                                                                                 headers: {
                                                                                   "userLogin": "joshua.rojas@eco2biz_demo",
                                                                                   "userPassword": "928504589",
                                                                                   "systemRoot": "eco2biz"},
                                                                                 body: map
                                                                             );




                                                                             print("Mapa ---> $map");


                                                                             if (response2.statusCode == 201) {print('Data inserted successfully');} else {print('Insertion failed--- NULL');}


                                                                             data = json.decode(response2.body)['data'];

                                                                             print("Valores ENTREGA------> ${data[0]['epp_entrega_id']}");

                                                                           //  entrega_id = data[0]['epp_entrega_id'];

                                                                             //                entrega_id = jsonDecode(response2.body[0]);
                                                                             //              print("Valor entrega_id ==> $entrega_id");

                                                                             print(response2.body);
                                                                             return response2;
                                                                           }
                                                                           await postParametroPlanificado();




                                                                     }),
                                                                       ],
                                                                 ),
                                                               ),
                                                             )
                                                          ],
                                                        ),

                                                       ],
                                                     )
                                                    //Suma de registros
                                                    //Lista de nro de total de factura y monto
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]
                        ),
                      ),
                    ),
                  ],
                ),
              );

             }
    ) : const Center(
              // render the loading indicator
              child: CircularProgressIndicator(),
              )
            ),
          ),
        ],
      ),
    );
  }
}





Future <List< dynamic>> RequestPuntosMonitoreo() async {

  var url = 'https://app.eco2biz.com/eco2biz/ws/null/pr_ws_lista_puntos_monitoreo?punto_monitoreo=1';
  var mapIncGen = Map<String, dynamic>();
  mapIncGen['punto_monitoreo'] = '1';

  var response = await http.post(Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "userLogin": "joshua.rojas@eco2biz_demo",
        "userPassword": "928504589",
        "systemRoot": "eco2biz"},
      body: jsonEncode(mapIncGen)
  );

  print("${response.statusCode}");
  var data = jsonDecode(response.body)['data'];
  List  results = [];
  //   results = data.map((e) => EmpleadoIncGen_model.fromJson(e)).toList();
  print("data ----> ${data}]");
  return data;

}

