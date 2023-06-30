import 'dart:convert';

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:safe2biz/app/modules/eco2biz/Database/SqlDb.dart';
import 'package:safe2biz/app/modules/eco2biz/toma_muestras_monitoreo/MuestrasMonitoreo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

import '../../../global/core/shared_widgets/layout/app_bar_back.dart';

//fixme: tabla ma_observacion_toma_muestra
const List<String> list = <String>['Ninguna', 'Conflicto', 'Desaparecido / No se encuentra', 'Obstruido', 'Alto Riesgo'];

List<dynamic>? listOfItems = [];


SqlDb sqlDb = SqlDb();

class MuestraMonitoreoDetalle extends StatefulWidget {

  const MuestraMonitoreoDetalle({Key? key, this.punto_monitoreo, this.clasificacion_elemento, this.plan_monitoreo, this.grupo_monitoreo, this.elemento, this.punto_id, this.plan_monitoreo_id, this.grupo_monitoreo_id, this.estado, this.color, this.plan_punto_monitoreo_id, this.gp_autoridad_id}) : super(key: key);

  final String? punto_monitoreo,clasificacion_elemento,plan_monitoreo,grupo_monitoreo, elemento;
  final String?   punto_id, plan_monitoreo_id, grupo_monitoreo_id,plan_punto_monitoreo_id, gp_autoridad_id, estado;
  final Color? color;

  @override
  State<MuestraMonitoreoDetalle> createState() => _MuestraMonitoreoDetalleState();
}

List<TextEditingController> textControllers = [];

List<bool?> itemCheckedState = [];
bool hasCheckedAsisstant = false;

List<Map> asistenciaCurso = [];

TextEditingController campoText = TextEditingController();
TextEditingController caudalText = TextEditingController();
TextEditingController conductividadText = TextEditingController();
TextEditingController salinidadText = TextEditingController();



String? base64Path;
String base64Image = '';
String? base64File;
String? path;
String base64Img = '';

int? idParamCampo;

File? foto_evidencia_path;
File? foto_evidencia_compress;


//parametros
//Views Visibility
bool isParametros = true;
bool isObservaciones = false;
bool isEvidencia = false;

bool isCheckedArsenico = false;
bool isCheckedPlomo = false;
bool isCheckedMercurio = false;

Color btnParametrosBackColor =  Color(0XFF006DB5);
Color btnObservacionesBackColor = Colors.white;
Color btnEvidenciaBackColor = Colors.white;

Color btnParametrosTextColor = Colors.white;
Color btnObservacionesTextColor =  Color(0XFF006DB5);
Color btnEvidenciaTextColor = Color(0XFF006DB5);


//Dia HOY
DateTime now = DateTime.now();
String formattedDate = DateFormat('yyyy-MM-dd–kk:mm').format(now);

class _MuestraMonitoreoDetalleState extends State<MuestraMonitoreoDetalle> {
  String? selection = null;
  XFile? image;
  final ImagePicker picker = ImagePicker();


  SqlDb sqlDb = SqlDb();

  bool hasDataFlag = false;
  bool fotoEvidencia = false;
  bool fotoRegistro = true;

  Future getImage(ImageSource media) async {
    var img =
    await picker.pickImage(source: media, maxHeight: 180, maxWidth: 180);
    setState(() {
      image = img;
    });


    Uint8List bytes = File(image!.path).readAsBytesSync();
    base64Image = convert.base64Encode(bytes); //data:image/png;base64,
    base64Path = base64Image;
    print("img base64---> : $base64Path");

    print("img display ---> 2020-13-4214:23:00.jpg;${base64Path}");
    // print("img display ---> ${fechaEntrega}${horaEntrega}.jpg;${base64Path}");
    //base64Img = "${fechaEntrega}${horaEntrega}.jpg;${base64Path}";
    base64Img = "2020-03-1614:23:00.jpg;${base64Path}";

    Future<File?> stringBase64ToFile() async {
      try {
        final decodedBytes = base64Decode(base64Image!);

        final directory = await getTemporaryDirectory();
        final basePath = directory.path;
        await Directory('$basePath/evidence').create(recursive: true);

        path =
        '$basePath/evidence/idPuntoParamento-${DateFormat('yyyyMMddHms.SSS')
            .format(DateTime.now())}.jpg';

        //   path = '$basePath/evidence/${widget.dni}-${DateFormat('yyyyMMddHms.SSS').format(DateTime.now())}.jpg';

        print("Path---> ${path}");

        File file = await File(path!).writeAsBytes(decodedBytes);
        // await File(path).delete();

        fotoRegistro = false;
        fotoEvidencia = true;

        return file;
      } catch (e) {
        debugPrint('ERROR EN CONVERSION DE String A FILE:  $e');
        return null;
      }
    }
    await stringBase64ToFile();
    print(' URL ARCHIVO---> ${path}');
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    print(" TempDir----> ${tempPath}");

    //==================

    //if registro exist == update
    //if not exists == insert

    //==================
    int muestraMonitoreo = await sqlDb.insertData("UPDATE 'PuntoMonitoreo' "
        " SET  'evidencia_uno' = '$formattedDate.jpg;${base64Path}' "
        "  ");
    print(muestraMonitoreo); /*Agregar foto_evidencia*/

    List<Map> responseReadPunto = await sqlDb.readData(""+
        "SELECT * FROM PuntoMonitoreo");
    print("lista puntosMonitoreo --- $responseReadPunto");


    List<Map> responseReadPuntoMetales = await sqlDb.readData(""
        "SELECT * FROM PuntoMetales");
    print("lista PuntoMetales --- $responseReadPuntoMetales");



    // subirOtraFoto = true;
    // imgEvidenciaVisible = false;
    if (path != null) {
      setState(() {});
      // imgEvidenciaVisible = false;
      // subirOtraFoto = true;
    }
  }



  String? base64Path2;
  String base64Image2 = '';
  String? base64File2;
  String? path2;
  String base64Img2 = '';

  bool fotoEvidencia2 = false;
  bool fotoRegistro2 = true;

  String? selection2 = null;
  XFile? image2;
  final ImagePicker picker2 = ImagePicker();

  //Evidencia 2
  Future getImage2(ImageSource media) async {
    var img2 =
    await picker2.pickImage(source: media, maxHeight: 180, maxWidth: 180);
    setState(() {
      image2 = img2;
    });

    Uint8List bytes2 = File(image2!.path).readAsBytesSync();
    base64Image2 = convert.base64Encode(bytes2); //data:image/png;base64,

    print("img base64---> : $base64Path2");

    print("img display ---> 2020-13-4214:23:002.jpg;${base64Path2}");
    // print("img display ---> ${fechaEntrega}${horaEntrega}.jpg;${base64Path}");
    //base64Img = "${fechaEntrega}${horaEntrega}.jpg;${base64Path}";
    base64Img = "2020-03-1614:23:002.jpg;${base64Path2}";

    Future<File?> stringBase64ToFile() async {
      try {
        final decodedBytes = base64Decode(base64Image2!);

        final directory2 = await getTemporaryDirectory();
        final basePath2 = directory2.path;
        await Directory('$basePath2/evidence').create(recursive: true);

        path2 =
        '$basePath2/evidence/idPuntoParamento2-${DateFormat('yyyyMMddHms.SSS')
            .format(DateTime.now())}.jpg';

        //   path = '$basePath/evidence/${widget.dni}-${DateFormat('yyyyMMddHms.SSS').format(DateTime.now())}.jpg';

        print("Path---> ${path2}");

        File file2 = await File(path2!).writeAsBytes(decodedBytes);
        // await File(path).delete();

        fotoRegistro2 = false;
        fotoEvidencia2 = true;

        return file2;
      } catch (e) {
        debugPrint('ERROR EN CONVERSION DE String A FILE:  $e');
        return null;
      }
    }
    await stringBase64ToFile();
    print(' URL ARCHIVO---> ${path2}');
    Directory tempDir2 = await getTemporaryDirectory();
    String tempPath2 = tempDir2.path;
    print(" TempDir----> ${tempPath2}");

    int muestraMonitoreo2 = await sqlDb.insertData("UPDATE 'PuntoMonitoreo' "
        " SET  'evidencia_dos' = '2020-13-4214:23:00.jpg;${base64Path2}' "
        "  ");
    print(muestraMonitoreo2); /*Agregar foto_evidencia*/

    // subirOtraFoto = true;
    // imgEvidenciaVisible = false;
    if (path2 != null) {
      setState(() {});
      // imgEvidenciaVisible = false;
      // subirOtraFoto = true;
    }
  }

  String dropdownValue = list.first;



  @override
  void dispose() {

    super.dispose();
  }

  //Elementos de campo

  List<String> parametros_campo = [];
  List<String> parametros_unidad_simb = [];
  List<dynamic> parametros_metales = [];


  //Parametros - metales

  /*
  List<String>? parametros_c_agua;
  List<String>? parametros_c_aire;
  List<String>? parametros_c_sedimento;
  List<String>? parametros_c_hidrobiologico;
  List<String>? parametros_c_suelo;
  List<String>? parametros_c_meteorologico;
   */

  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
    asyncInit();

    if (widget.elemento == 'Agua') {
      parametros_campo.add("Caudal");
      parametros_campo.add("Conductividad Eléctrica");
      parametros_campo.add("Salinidad");


      parametros_unidad_simb.add("L/s");
      parametros_unidad_simb.add("µS/cm");
      parametros_unidad_simb.add("NTU");
      //  parametros_unidad_simb.add("ug/L");
      //parametros_unidad_simb.add("g/l");
    } else if (widget.elemento == 'Aire') {
      parametros_campo.add("Dirección del Viento");
      parametros_unidad_simb.add("m/s");
    }
    createTextControllers();
    loadSavedValues();


    loadFavorite();


    itemCheckedState = [];




  }

  void initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  void createTextControllers() {
    for (int i = 0; i < parametros_campo.length; i++) {
      textControllers.add(TextEditingController());
    }
  }

  Future<void> loadFavorite() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final keys = prefs.getKeys();
    final prefsMap = Map<String, dynamic>();
    for(String key in keys) {
      prefsMap[key] = prefs.get(key);
    }
    print("Saved data --- $prefsMap");

    setState(() {
      itemCheckedState = (prefs.getStringList("Punto-${widget.punto_id}") ?? <bool>[]).map((value) => value == 'true').toList();
    });

    if(itemCheckedState.contains(true)){
      setState((){
        hasDataFlag = true;
      });

    }else{
      setState((){
        hasDataFlag = false;
      });
    }

  }



  void loadSavedValues() async{            // Carga campos de texto
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < parametros_campo.length; i++) {
      final savedValue = prefs.getString('${widget.punto_monitoreo}${widget.punto_id}${widget.plan_punto_monitoreo_id}$i');
      if (savedValue != null) {
        textControllers[i].text = savedValue;
      }
    }
  }

  void saveTextFieldValue(String value, int index) async {   // Guarda campos de texto
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('${widget.punto_monitoreo}${widget.punto_id}${widget.plan_punto_monitoreo_id}$index', value);
  }

  void deleteSavedValues() async {
    for (int i = 0; i < parametros_campo.length; i++) {
      await sharedPreferences.remove('${widget.punto_monitoreo}${widget.punto_id}${widget.plan_punto_monitoreo_id}$i');
    }


    // Limpiar los controladores de texto
    textControllers.forEach((controller) => controller.clear());
  }


  void asyncInit() async {
    // await RequestMetales();
    // await RequestPuntosMonitoreo();

   asistenciaCurso = await sqlDb.readData(
        "SELECT * FROM PuntoMetales WHERE PuntoMetales.id_punto = '${widget.punto_id}' ");

    print('read asistencia_check ---> ${asistenciaCurso}');


    if(asistenciaCurso.isEmpty){
      hasCheckedAsisstant = false;
    }else{
      hasCheckedAsisstant = true;
    }


    await RequestParametrosxPunto();
    List<Map> responseRead = await sqlDb.readData(""
        "SELECT * FROM MuestraMetales");
    print("lista metales --- $responseRead");

    //await RequestPuntosMonitoreo();
    List<Map> responseReadPunto = await sqlDb.readData(""
        "SELECT * FROM PuntoMonitoreo");
    print("lista puntosMonitoreo --- $responseReadPunto");

  }


  @override
  Widget build(BuildContext context) {




    void myAlert() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              title: Text('Subir imagen por:', style: TextStyle(color: Color(0XFF505154)),),
              content: InkWell(
                onTap: () => getImage(ImageSource.gallery),
                child: Container(
                  height: MediaQuery.of(context).size.height / 7,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff006DB5)),

                        onPressed: () {
                          Navigator.pop(context);
                          getImage(ImageSource.gallery);
                          setState(() {
                            print(image);
                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.image),
                            SizedBox(width: 10,),
                            Text(' Galería'),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff006DB5)),
                        //if user click this button. user can upload image from camera
                        onPressed: () {
                          getImage(ImageSource.camera);
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Icon(Icons.camera),
                            SizedBox(width: 10,),
                            Text(' Camara'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    }

    void myAlert2() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              title: Text('Subir imagen por:', style: TextStyle(color: Color(0XFF505154)),),
              content: InkWell(
                onTap: () => getImage(ImageSource.gallery),
                child: Container(
                  height: MediaQuery.of(context).size.height / 7,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff006DB5)),

                        onPressed: () {
                          Navigator.pop(context);
                          getImage2(ImageSource.gallery);
                          setState(() {
                            print(image);
                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.image),
                            SizedBox(width: 10,),
                            Text(' Galería'),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff006DB5)),
                        //if user click this button. user can upload image from camera
                        onPressed: () {
                          getImage2(ImageSource.camera);
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Icon(Icons.camera),
                            SizedBox(width: 10,),
                            Text(' Cámara'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    }

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Color(0xFF006DB5);
      }
      return Color(0xFF006DB5);
    }

    return Scaffold(
      appBar: AppBarBack("Muestra de Monitoreo"),
       floatingActionButton : Visibility(visible: hasDataFlag, child: FloatingActionButton(onPressed: (){
         deleteSavedValues();
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
                                                                             btnOkOnPress: () async{

                                                                               await SubirRegistro('${widget.punto_monitoreo}');

                                                                             },
                                                                             btnOkIcon: Icons.check_circle,
                                                                             onDismissCallback: (type) {
                                                                               debugPrint(
                                                                                   'Dialog Dissmiss from callback $type');
                                                                             },
                                                                           ).show();

       }, child: Icon(Icons.upload), backgroundColor: Color(0XFF4B82B9),)),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(

            children: [
              Container(
                width: MediaQuery.of(context).size.width*1,
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


                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top:5.0, bottom: 8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("${widget.punto_monitoreo}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0XFF4B82B9)),),  //Punto Monitoreo

                                                Container(
                                                    width: 105,
                                                    height: 25,
                                                    child: ElevatedButton(onPressed: (){

                                                      //fixme: Considerar -- "ma_parametro_ejecutado -- 2da tabla"

                                                      print("ma_plan_monitoreo_id ---- ${widget.plan_monitoreo_id}, "
                                                            "ma_plan_punto_monitoreo_id --  "
                                                            "gp_autoridad_id ---- "
                                                            "ma_parametro_elemento_id --- "
                                                            "semana_muestreo --- "
                                                            "caudal_parametro --- "
                                                            "fecha_registro ---- date.now "
                                                            "fecha_actualizacion --- date.now "
                                                            "ma_parametro_ejecutado -- 2da tabla"
                                                            "flag_cambio -- true"
                                                            "descripcion --- true" );

                                                    },
                                                        style: ElevatedButton.styleFrom(

                                                          backgroundColor: widget.color,

                                                        ),
                                                        child: FittedBox(child: Text("${widget.estado}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14) )  ))),

                                              ],
                                            ),
                                            Divider(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("${widget.clasificacion_elemento}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0XFF006DB5)),),   // Clasificación del Elemento --Grupos de monitoreo
                                                //  Image.asset("${ambitoImg}", width: 20,),
                                              ],
                                            ),

                                            SizedBox(height: 3,),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Text("Ubicado en la margen izquierda del Rio Uchucchacua a 200 mts del puente El Pedregal", maxLines: 2, style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.6),))
                                              ],
                                            ),
                                            Divider(height: 10,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [

                                                Text("${widget.plan_monitoreo})",
                                                  maxLines: 2, style: TextStyle(fontSize: 11,  height: 1.6, color: Color(0XFF505154)),   //Codigo Planes de Monitoreo
                                                ),
                                                SizedBox(height: 1,),
                                                Divider(height: 5,),
                                                SizedBox(height: 5,),

                                                Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text("Grupo:   ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13, color: Color(0XFF505154) ),),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text("${widget.grupo_monitoreo}", style: TextStyle(fontSize: 10,  fontWeight: FontWeight.bold, color: Color(0XFF505154)),)
                                                      ],
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

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.3 ,
                      child: ElevatedButton(onPressed: (){

                        setState(() {

                          //Background colors
                          btnParametrosBackColor = Color(0XFF006DB5);
                          btnObservacionesBackColor = Colors.white;
                          btnEvidenciaBackColor = Colors.white;

                          //Text colors
                          btnParametrosTextColor = Colors.white;
                          btnObservacionesTextColor = Color(0XFF006DB5);
                          btnEvidenciaTextColor = Color(0XFF006DB5);

                          isParametros = true;
                          isObservaciones = false;
                          isEvidencia = false;
                        });

                      },style: ElevatedButton.styleFrom(
                        backgroundColor: btnParametrosBackColor
                      ),
                          child: Row(
                            children: [
                              Text("Parámetros", style: TextStyle(color: btnParametrosTextColor),),
                            ],
                          )),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.36 ,
                      child: ElevatedButton(onPressed: (){
                        setState(() {
                          btnParametrosBackColor = Colors.white;
                          btnObservacionesBackColor = Color(0XFF006DB5);
                          btnEvidenciaBackColor = Colors.white;

                          btnParametrosTextColor = Color(0XFF006DB5);
                          btnObservacionesTextColor = Colors.white;
                          btnEvidenciaTextColor = Color(0XFF006DB5);

                          isParametros = false;
                          isObservaciones = true;
                          isEvidencia = false;
                        });

                      }, child: Text("Observaciones", style: TextStyle(           color:  btnObservacionesTextColor ),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btnObservacionesBackColor
                      ),),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.24 ,
                      child: ElevatedButton(onPressed: (){
                        setState(() {

                          btnParametrosBackColor = Colors.white;
                          btnObservacionesBackColor = Colors.white;
                          btnEvidenciaBackColor = Color(0XFF006DB5);

                          btnParametrosTextColor = Color(0XFF006DB5);
                          btnObservacionesTextColor =  Color(0XFF006DB5);
                          btnEvidenciaTextColor = Colors.white;

                          isParametros = false;
                          isObservaciones = false;
                          isEvidencia = true;
                        });
                      }, child: Text("Fotos", style: TextStyle(           color: btnEvidenciaTextColor ),),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: btnEvidenciaBackColor
                      ),),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4,),


              /*
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(height: 5, thickness: 1.0),
                  )),

                  Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0) ,
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.35,
                        height: 35,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4B82B9),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //      Icon(Icons.save, size: 16,),
                              //        SizedBox(width: 10,),
                              Text("Guardar", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                            ],
                          ),
                          onPressed: () async{

                            //Parametros de campo
                            if(widget.elemento == 'Agua'){

                              int responseEntregaDetalle = await sqlDb.insertData("INSERT INTO 'PuntoMetales' "
                                  " ('id_punto',           'id_metal',            'valor',              'plan_punto_monitoreo_id'   ,           'gp_autoridad_id',              'flag_cambio',      'estado') VALUES "
                                  " ('${widget.punto_id}',   '654',      '${caudalText.text}',        '${widget.plan_punto_monitoreo_id}' ,     ${widget.gp_autoridad_id},        '1'        ,         '1'),"   //caudal
                                  " ('${widget.punto_id}',   '51',      '${conductividadText.text}',   '${widget.plan_punto_monitoreo_id}' ,   ${widget.gp_autoridad_id},         '1'         ,        '1'), "  //conduct
                                  " ('${widget.punto_id}',   '3055',    '${salinidadText.text}',    '${widget.plan_punto_monitoreo_id}' ,       ${widget.gp_autoridad_id},        '1'         ,        '1') ");  //salinidad

                              print("Se inserto registro parametros de campo ${widget.punto_id}'' --- $responseEntregaDetalle");
                            }


                            List<Map> responseReadTablaPuntosMetales = await sqlDb.readData(""
                                "SELECT * FROM PuntoMetales");
                            print("tabla puntosMonitoreo --- $responseReadTablaPuntosMetales");


                            await responseReadTablaPuntosMetales;
                            List<Map> responseReadTablaPuntosMonitor = await sqlDb.readData(""
                                "SELECT * FROM PuntoMonitoreo");
                            print("tabla PuntoMonitoreo --- $responseReadTablaPuntosMonitor");

                            await responseReadTablaPuntosMonitor;

                          },
                        ),
                      )
                  ),



                ],
              ),
              */

              SizedBox(height: 4,),
              //Parametros Screen


              Visibility(
                visible: isParametros,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(        color: Colors.white,   borderRadius: BorderRadius.circular(10.0) ),
                        child:



                        ExpandableNotifier(
                          child: Column(
                            children: [
                              Expandable(
                                collapsed: ExpandableButton(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:  Color(0xFF9DCB47),
                                      borderRadius:  BorderRadius.circular(10.0)),

                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.add, color:  Colors.white, ),
                                              SizedBox(width: 10,),
                                              Text("Parámetros de campo", style: TextStyle(fontSize: 16, color: Colors.white,  fontWeight: FontWeight.w500),)
                                            ],
                                          ),

                                          Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Icon(Icons.arrow_drop_down_outlined, color: Color(0XFF4B82B9),)
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                expanded:
                                Column(
                                  children: [
                                    ExpandableButton(
                                      child:  Container(

                                        decoration: BoxDecoration(
                                            color:  Color(0xFF9DCB47),
                                             borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(5.0),
                                                 topLeft: Radius.circular(5.0)),),

                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.add, color:  Colors.white, ),
                                                  SizedBox(width: 10,), //( ${parametros_campo.length} )
                                                  Text("Parámetros de campo   ", style: TextStyle(fontSize: 16, color: Colors.white,  fontWeight: FontWeight.w500),)
                                                ],
                                              ),


                                              Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Icon(Icons.arrow_drop_down_outlined, color: Color(0XFF4B82B9),)
                                              ),

                                              /*
                                              Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Icon(Icons.arrow_drop_down_outlined, color: Color(0XFF4B82B9),)
                                              ),
                                               */


                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 2,),

                                    ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: parametros_campo.length,
                                      prototypeItem: ListTile(
                                        title: Text(parametros_campo.first),
                                      ),
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title:        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context).size.width*0.35,
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.chevron_right, color: Color(0XFFADC22F)),
                                                      SizedBox(width: 5,),
                                                      Container(child: Expanded(child: Text("${parametros_campo[index]}", style: TextStyle(color: Color(0XFF505154), fontSize: 14),))),
                                                    ],
                                                  )),
                                              Row(
                                                children: [
                                                  Center(
                                                    child: Container(
                                                      width: 50,
                                                      height: 30,
                                                      child:    Container(
                                                          width: MediaQuery.of(context).size.width*0.10,
                                                          child: Align(
                                                              alignment: Alignment.center,
                                                              child: Text("${parametros_unidad_simb[index]}", style: TextStyle(fontSize: 12, color: Colors.grey),))
                                                      )
                                                    ),
                                                  ),

                                                  SizedBox(width: 10,),

                                                  Container(
                                                    width: 80,
                                                    height: 30,
                                                    child: TextField(

                                                      controller: textControllers[index],
                                                      textAlign: TextAlign.center,
                                                      decoration: InputDecoration(
                                                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                                          border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5))),
                                                          onChanged: (value) {

                                                        if(parametros_unidad_simb[index] == 'L/s' ){


                                                          caudalText.text = value;
                                                          saveTextFieldValue(value, index);


                                                        }

                                                        if(parametros_unidad_simb[index] == 'µS/cm' ){
                                                          conductividadText.text = value;
                                                        }

                                                        if(parametros_unidad_simb[index] == 'NTU' ){
                                                          salinidadText.text = value;
                                                        }


                                                        print("Caudal --- ${caudalText.text}");
                                                        print("Cond elect --- ${conductividadText.text}");
                                                        print("Salinidad --- ${salinidadText.text}");

                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        );
                                      },
                                    ),
                                    SizedBox(height: 4,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          //exp      ),


                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(        color: Colors.white,   borderRadius: BorderRadius.circular(10.0) ),
                        child: Column(
                          children: [


                            ExpandableNotifier(  // <-- Provides ExpandableController to its children
                              child: Column(
                                children: [
                                  Expandable(           // <-- Driven by ExpandableController from ExpandableNotifier
                                    collapsed: ExpandableButton(  // <-- Expands when tapped on the cover photo
                                      child:   Container(

                                        decoration: BoxDecoration(
                                            color:  Color(0xFF9DCB47),
                                            borderRadius:  BorderRadius.circular(10.0)),

                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.add, color:  Colors.white, ),
                                                  SizedBox(width: 10,),
                                                  Text("Metales Totales", style: TextStyle(fontSize: 16, color: Colors.white,  fontWeight: FontWeight.w500),)
                                                ],
                                              ),

                                              Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Icon(Icons.arrow_drop_down_outlined, color: Color(0XFF4B82B9),)
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    expanded: Column(
                                        children: [
                                          Column(
                                            children: [
                                              ExpandableButton(
                                                child:   Container(
                                                  decoration: BoxDecoration(
                                                    color:  Color(0xFF9DCB47),
                                                    borderRadius: BorderRadius.only(
                                                        topRight: Radius.circular(5.0),
                                                        topLeft: Radius.circular(5.0)),),

                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(Icons.add, color:  Colors.white, ),
                                                            SizedBox(width: 10,), //( ${parametros_metales.length} )
                                                            Text("Metales Totales  ", style: TextStyle(fontSize: 16, color: Colors.white,  fontWeight: FontWeight.w500),)
                                                          ],
                                                        ),


                                                        Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                            child: Icon(Icons.arrow_drop_down_outlined, color: Color(0XFF4B82B9),)
                                                        ),



                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),


                                              FutureBuilder(
                                                future: RequestParametrosxPunto(),
                                                builder: (BuildContext ctx, AsyncSnapshot<List> snapshot) =>
                                                snapshot.hasData ? ListView.builder(
                                                  scrollDirection: Axis.vertical,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: parametros_metales.length,
                                                  itemBuilder: (BuildContext context, index) {

                                                    listOfItems = snapshot.data;
                                                    for(int i = 0; i < listOfItems!.length; i++){
                                                      itemCheckedState.add(false);
                                                    }

                                                    return  Padding(
                                                      padding: const EdgeInsets.all(4.0),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Container(
                                                                  width: MediaQuery.of(context).size.width*0.40,
                                                                      decoration: BoxDecoration(
                                                                      //   color: Colors.blue,
                                                                          borderRadius: BorderRadius.circular(10.0) ),

                                                                  child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          Container(
                                                                              child: Expanded(
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(Icons.chevron_right, color: Color(0XFFADC22F)),
                                                                                    SizedBox(width: 5,),
                                                                                    Container(child: Expanded(child: Text("${snapshot.data![index]['nombre_parametro']}", style: TextStyle(color: Color(0XFF505154), fontSize: 14),))),
                                                                                  ],
                                                                                ),
                                                                              )),

                                                                          Row(
                                                                            children: [
                                                                              Center(
                                                                                child: Container(
                                                                                  height: 45,
                                                                                  width: 30,
                                                                                    child: CheckboxListTile(
                                                                                      checkColor: Colors.white,
                                                                                      value: itemCheckedState[index],
                                                                               //     fillColor: MaterialStateProperty.resolveWith(getColor),
                                                                                      onChanged: (newValue) {

                                                                                        Future<void> saved() async {


                                                                                          SharedPreferences prefs = await SharedPreferences.getInstance();

                                                                                          int response = await sqlDb.insertData("INSERT INTO 'PuntoMetales' "
                                                                                              " ('id_punto',           'id_metal',            'valor',              'plan_punto_monitoreo_id'   ,           'gp_autoridad_id',              'flag_cambio',      'estado') VALUES "
                                                                                              " ('${widget.punto_id}',   '${snapshot.data![index]['ma_parametro_elemento_id']}', ' ', '${widget.plan_punto_monitoreo_id}',   '${widget.gp_autoridad_id}', '1', '1' ) ");
                                                                                          print("Guardado -- $response");
                                                                                          itemCheckedState[index] = newValue;
                                                                                          print('position true checkbox ${itemCheckedState.length} ---- $newValue');
                                                                                          //      print('read asistencia_check ---> ${asistenciaCurso}');

                                                                                          setState(() {
                                                                                            itemCheckedState[index] = true;
                                                                                          });

                                                                                          await prefs.setStringList("Punto-${widget.punto_id}", itemCheckedState.map((value) => value.toString()).toList());

                                                                                          Future.delayed(const Duration(milliseconds: 1000), () async {
                                                                                            List<Map> asistenciaCurso = await sqlDb.readData("SELECT * FROM PuntoMetales WHERE PuntoMetales.id_punto = '${widget.punto_id}' ");
                                                                                            print('read asistencia_check ---> ${asistenciaCurso}');
                                                                                            if(asistenciaCurso.isEmpty){

                                                                                              setState((){
                                                                                                hasCheckedAsisstant = false;
                                                                                              });


                                                                                            }else if(asistenciaCurso.isNotEmpty){
                                                                                              setState((){
                                                                                                hasCheckedAsisstant = true;
                                                                                              });
                                                                                            }
                                                                                          });

                                                                                          setState(() {
                                                                                            itemCheckedState = (prefs.getStringList("Punto-${widget.punto_id}") ?? <bool>[]).map((value) => value == 'true').toList();
                                                                                          });
                                                                                        }

                                                                                        Future<void> delete() async {

                                                                                          SharedPreferences prefs = await SharedPreferences.getInstance();

                                                                                          int responseDeletePuntoMetales = await sqlDb.deleteData("DELETE FROM PuntoMetales "
                                                                                              " WHERE PuntoMetales.id_punto  = '${widget.punto_id}' "
                                                                                              " AND PuntoMetales.id_metal = '${snapshot.data![index]['ma_parametro_elemento_id']}' " );
                                                                                          print("Delete registro PuntoMetales $responseDeletePuntoMetales");


                                                                                          print("Delete registro PuntoMetales $responseDeletePuntoMetales");
                                                                                          print('position false checkbox ${itemCheckedState.length} ---- $newValue');
                                                                                          // print('read asistencia_check ---> ${asistenciaCurso}');

                                                                                          Future.delayed(const Duration(milliseconds: 3000), () async{
                                                                                            List<Map> asistenciaCurso = await sqlDb.readData("SELECT * FROM PuntoMetales WHERE PuntoMetales.id_punto = '${widget.punto_id}' ");
                                                                                            print('read punto metales ---> ${asistenciaCurso}');

                                                                                            if(asistenciaCurso.isEmpty){



                                                                                              setState((){
                                                                                                hasCheckedAsisstant = false;
                                                                                              });


                                                                                            }else if(asistenciaCurso.isNotEmpty){
                                                                                              setState((){
                                                                                                hasCheckedAsisstant = true;
                                                                                              });
                                                                                            }
                                                                                          });


                                                                                          setState(() {
                                                                                            itemCheckedState[index] = false;
                                                                                          });

                                                                                          await prefs.setStringList("Punto-${widget.punto_id}", itemCheckedState.map((value) => value.toString()).toList());
                                                                                          setState(() {
                                                                                            itemCheckedState = (prefs.getStringList("Punto-${widget.punto_id}") ?? <bool>[]).map((value) => value == 'true').toList();
                                                                                          });

                                                                                        }

                                                                                        if(newValue == true) {
                                                                                          saved();
                                                                                          Future.delayed(const Duration(milliseconds: 1000), () {

                                                                                            setState(() {
                                                                                              if(itemCheckedState.contains(true)){
                                                                                                setState((){
                                                                                                  hasDataFlag = true;
                                                                                                });

                                                                                              }else{
                                                                                                setState((){
                                                                                                  hasDataFlag = false;
                                                                                                });
                                                                                              }

                                                                                            });

                                                                                          });

                                                                                        }else if (newValue == false){
                                                                                          delete();

                                                                                          Future.delayed(const Duration(milliseconds: 1000), () {

                                                                                            setState(() {
                                                                                              if(itemCheckedState.contains(true)){
                                                                                                setState((){
                                                                                                  hasDataFlag = true;
                                                                                                });

                                                                                              }else{
                                                                                                setState((){
                                                                                                  hasDataFlag = false;
                                                                                                });
                                                                                              }

                                                                                            });

                                                                                          });

                                                                                        }


                                                                                      },
                                                                                    ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),


                                                                        ],
                                                                      ),
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                          Divider(height: 1,),

                                                        ],
                                                      ),
                                                    );

                                                  },
                                                )  : const Center(
                                                  // render the loading indicator
                                                  child: CircularProgressIndicator(),
                                                )
                                              ),
                                              Visibility(
                                                //     visible: btnEliminarRegistro,
                                                visible: true,
                                                child: MaterialButton(onPressed: () async {
                                                  await sqlDb.mydeleteDatabase();
                                                },
                                                  child: Text("Eliminar registros", style: TextStyle(color: Colors.grey),),
                                                ),
                                              ),

                                            ],
                                          ),



                                        ]
                                    ),
                                  ),
                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 10,),


                  ],
                ),
              ),

              //Observaciones Screen

              Visibility(
                  visible: isObservaciones,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(5.0) ),

                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,

                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF9DCB47),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5.0),
                                      topLeft: Radius.circular(5.0)),),


                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.warning_amber_rounded , color: Colors.white,),
                                            SizedBox(width: 10,),
                                            Text("Excepción", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width*1,
                                        child:  DropdownButton<String>(
                                          isExpanded: true,
                                          value: dropdownValue,
                                          dropdownColor: Colors.white,
                                          icon: const Icon(Icons.arrow_drop_down_outlined),
                                          elevation: 18,
                                          style: const TextStyle(color: Color(0xFF4B82B9), fontWeight: FontWeight.w500, fontSize: 15),
                                          underline: Container(
                                            height: 2,
                                            color: Color(0XFFADC22F),
                                          ),
                                          onChanged: (String? value) {
                                            // This is called when the user selects an item.
                                            setState(() {
                                              dropdownValue = value!;
                                            });
                                          },
                                          items: list.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),


                                    ],
                                  ),
                                )
                              ],
              ),
                          ),


                       SizedBox(height: 20,),
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF9DCB47),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5.0),
                                        topLeft: Radius.circular(5.0)),),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.search, color: Colors.white,),

                                            SizedBox(width: 10,),
                                            Text("Observaciones", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context).size.width*1,
                                          child: TextField(
                                            minLines: 3, // Set this
                                            maxLines: 6, // and this
                                            keyboardType: TextInputType.multiline,
                                            style: TextStyle(color: Color(0xFF4B82B9), fontWeight: FontWeight.w500, fontSize: 14),
                                            decoration: InputDecoration(
                                              hintText: "Ingrese su Observación...",
                                              hintStyle: TextStyle(color: Colors.grey),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Color(0XFFADC22F), width: 2 ),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Color(0XFFADC22F), width: 2 ),
                                              ),
                                            ),
                                          )
                                      ),

                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              
              Visibility(
                visible: isEvidencia,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                          decoration: BoxDecoration(  color:Colors.white,   borderRadius: BorderRadius.circular(10.0) ),
                          width: MediaQuery.of(context).size.width*1,
                          child: Column(
                            children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF9DCB47),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5.0),
                                      topLeft: Radius.circular(5.0)),),
                                  child:
                                  Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.image_search_rounded, color: Colors.white,),
                                        SizedBox(width: 10,),
                                        Text("Registro de Evidencias", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500 ),),
                                      ],
                                    ),
                                  ),
                            ],),
                                ),
                              SizedBox(height: 16,),
                              InkWell(
                                onTap: (){
                                  myAlert();
                                },
                                child: Container(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        image != null
                                            ?    //IMG foto tomada / galeria
                                        Visibility(
                                          visible : true,
                                          child: Column(
                                            children: [
                                              DottedBorder(
                                                padding:
                                                EdgeInsets.all(4.0),
                                                color: Color(0xffADC22F),
                                                radius:
                                                Radius.circular(10.0),
                                                strokeWidth: 2,
                                                dashPattern: [10, 5],
                                                customPath: (size) {
                                                  return Path()
                                                    ..moveTo(10, 0)
                                                    ..lineTo(
                                                        size.width - 10, 0)
                                                    ..arcToPoint(
                                                        Offset(
                                                            size.width, 10),
                                                        radius:
                                                        Radius.circular(
                                                            10))
                                                    ..lineTo(size.width,
                                                        size.height - 10)
                                                    ..arcToPoint(
                                                        Offset(
                                                            size.width - 10,
                                                            size.height),
                                                        radius:
                                                        Radius.circular(
                                                            10))
                                                    ..lineTo(
                                                        10, size.height)
                                                    ..arcToPoint(
                                                        Offset(
                                                            0,
                                                            size.height -
                                                                10),
                                                        radius:
                                                        Radius.circular(
                                                            10))
                                                    ..lineTo(0, 10)
                                                    ..arcToPoint(
                                                        Offset(10, 0),
                                                        radius:
                                                        Radius.circular(
                                                            10));
                                                },
                                                child: ClipRRect(
                                                  //
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      8),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(8.0),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Image.file(
                                                          File(image!.path),
                                                          fit: BoxFit.fill,
                                                          //   width: MediaQuery.of(context).size.width,
                                                          //  height: 170,
                                                        ),
                                                        Positioned(
                                                          top: 0,
                                                          right: 0,
                                                          child:
                                                          GestureDetector(
                                                            onTap: () {
                                                              print(
                                                                  'Eliminar imagen');
                                                              setState(() {
                                                                print(
                                                                    'set new state of images');
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .all(
                                                                  8.0),
                                                              child:
                                                              Container(
                                                                decoration:
                                                                BoxDecoration(
                                                                  color: Color(
                                                                      0xff006DB5),
                                                                  border: Border.all(
                                                                      width:
                                                                      2,
                                                                      color:
                                                                      Colors.white),
                                                                  borderRadius: BorderRadius.only(
                                                                      topRight: Radius.circular(
                                                                          40.0),
                                                                      bottomRight: Radius.circular(
                                                                          40.0),
                                                                      topLeft: Radius.circular(
                                                                          40.0),
                                                                      bottomLeft:
                                                                      Radius.circular(40.0)),
                                                                ),
                                                                child:
                                                                InkWell(
                                                                  onTap:
                                                                      () {

                                                                    setState(() {
                                                                      fotoEvidencia = false;
                                                                      fotoRegistro = true;
                                                                    });
                                                                  },
                                                                  child:
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets.all(2.0),
                                                                    child:
                                                                    Icon(
                                                                      Icons
                                                                          .close_rounded,
                                                                      color:
                                                                      Colors.white,
                                                                      size:
                                                                      18,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(height: 10,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.camera_alt, size: 18, color: Color(0XFF006DB5),),
                                                  SizedBox(width: 6,),
                                                  Text("Evidencia 1", style: TextStyle(color: Color(0XFF505154), fontWeight: FontWeight.w500),)
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                            : Text(""),


                                        //img Registrar Evidencia
                                        Visibility(
                                          visible: fotoRegistro,
                                          child: DottedBorder(
                                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                            color: Color(0xffADC22F),
                                            radius: Radius.circular(10.0),
                                            strokeWidth: 2,
                                            dashPattern: [10, 5],
                                            customPath: (size) {
                                              return Path()
                                                ..moveTo(10, 0)
                                                ..lineTo(size.width - 10, 0)
                                                ..arcToPoint(
                                                    Offset(size.width, 10),
                                                    radius: Radius.circular(10))
                                                ..lineTo(size.width,
                                                    size.height - 10)
                                                ..arcToPoint(
                                                    Offset(size.width - 10,
                                                        size.height),
                                                    radius: Radius.circular(10))
                                                ..lineTo(10, size.height)
                                                ..arcToPoint(
                                                    Offset(0, size.height - 10),
                                                    radius: Radius.circular(10))
                                                ..lineTo(0, 10)
                                                ..arcToPoint(Offset(10, 0),
                                                    radius:
                                                    Radius.circular(10));
                                            },
                                            child: Visibility(
                                              visible: true,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          5.0) //
                                                  ),
                                                ),
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/subir_Evidencia_2.png',
                                                      width: 90,
                                                      height: 65,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "Evidencia 1",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontSize: 12,
                                                          color: Colors.grey),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    )
                                ),

                              ),



                              SizedBox(height: 7,),
                              Divider(height: 30, thickness: 1.5,),
                              SizedBox(height: 7,),




// Segunda Evidencia

                              InkWell(
                                onTap: (){
                                  myAlert2();
                                },
                                child: Container(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        image2 != null
                                            ?    //IMG foto tomada / galeria
                                        Visibility(
                                          visible : fotoEvidencia2,
                                          child: Column(
                                            children: [
                                              DottedBorder(
                                                padding:
                                                EdgeInsets.all(4.0),
                                                color: Color(0xffADC22F),
                                                radius:
                                                Radius.circular(10.0),
                                                strokeWidth: 2,
                                                dashPattern: [10, 5],
                                                customPath: (size) {
                                                  return Path()
                                                    ..moveTo(10, 0)
                                                    ..lineTo(
                                                        size.width - 10, 0)
                                                    ..arcToPoint(
                                                        Offset(
                                                            size.width, 10),
                                                        radius:
                                                        Radius.circular(
                                                            10))
                                                    ..lineTo(size.width,
                                                        size.height - 10)
                                                    ..arcToPoint(
                                                        Offset(
                                                            size.width - 10,
                                                            size.height),
                                                        radius:
                                                        Radius.circular(
                                                            10))
                                                    ..lineTo(
                                                        10, size.height)
                                                    ..arcToPoint(
                                                        Offset(
                                                            0,
                                                            size.height -
                                                                10),
                                                        radius:
                                                        Radius.circular(
                                                            10))
                                                    ..lineTo(0, 10)
                                                    ..arcToPoint(
                                                        Offset(10, 0),
                                                        radius:
                                                        Radius.circular(
                                                            10));
                                                },
                                                child: ClipRRect(
                                                  //
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      8),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(8.0),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Image.file(
                                                          File(image2!.path),
                                                          fit: BoxFit.fill,
                                                          //   width: MediaQuery.of(context).size.width,
                                                          //  height: 170,
                                                        ),
                                                        Positioned(
                                                          top: 0,
                                                          right: 0,
                                                          child:
                                                          GestureDetector(
                                                            onTap: () {
                                                              print(
                                                                  'Eliminar imagen');
                                                              setState(() {
                                                                print(
                                                                    'set new state of images');
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .all(
                                                                  8.0),
                                                              child:
                                                              Container(
                                                                decoration:
                                                                BoxDecoration(
                                                                  color: Color(
                                                                      0xff006DB5),
                                                                  border: Border.all(
                                                                      width:
                                                                      2,
                                                                      color:
                                                                      Colors.white),
                                                                  borderRadius: BorderRadius.only(
                                                                      topRight: Radius.circular(
                                                                          40.0),
                                                                      bottomRight: Radius.circular(
                                                                          40.0),
                                                                      topLeft: Radius.circular(
                                                                          40.0),
                                                                      bottomLeft:
                                                                      Radius.circular(40.0)),
                                                                ),
                                                                child:
                                                                InkWell(
                                                                  onTap:
                                                                      () {
                                                                        setState(() {
                                                                          fotoEvidencia2 = false;
                                                                          fotoRegistro2 = true;
                                                                        });
                                                                  },
                                                                  child:
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets.all(2.0),
                                                                    child:
                                                                    Icon(
                                                                      Icons
                                                                          .close_rounded,
                                                                      color:
                                                                      Colors.white,
                                                                      size:
                                                                      18,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(height: 10,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.camera_alt, size: 18, color: Color(0XFF006DB5),),
                                                  SizedBox(width: 6,),
                                                  Text("Evidencia 2", style: TextStyle(color: Color(0XFF505154), fontWeight: FontWeight.w500),)
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                            : Text(""),
                                        //img Registrar Evidencia
                                        Visibility(
                                          visible: fotoRegistro2,
                                          child: DottedBorder(
                                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                            color: Color(0xffADC22F),
                                            radius: Radius.circular(10.0),
                                            strokeWidth: 2,
                                            dashPattern: [10, 5],
                                            customPath: (size) {
                                              return Path()
                                                ..moveTo(10, 0)
                                                ..lineTo(size.width - 10, 0)
                                                ..arcToPoint(
                                                    Offset(size.width, 10),
                                                    radius: Radius.circular(10))
                                                ..lineTo(size.width,
                                                    size.height - 10)
                                                ..arcToPoint(
                                                    Offset(size.width - 10,
                                                        size.height),
                                                    radius: Radius.circular(10))
                                                ..lineTo(10, size.height)
                                                ..arcToPoint(
                                                    Offset(0, size.height - 10),
                                                    radius: Radius.circular(10))
                                                ..lineTo(0, 10)
                                                ..arcToPoint(Offset(10, 0),
                                                    radius:
                                                    Radius.circular(10));
                                            },
                                            child: Visibility(
                                              visible: true,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          5.0) //
                                                  ),
                                                ),
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/subir_Evidencia_2.png',
                                                      width: 90,
                                                      height: 65,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "Evidencia 2",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontSize: 12,
                                                          color: Colors.grey),
                                                    )

                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    )
                                ),

                              ),

                              SizedBox(height: 16,),
                            ],
                          )
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }



  Future <List< dynamic>> RequestParametrosxPunto() async {

    String punto_id = "${widget.punto_id}";
    String plan_monitoreo_id = "${widget.plan_monitoreo_id}";
    String grupo_monitoreo_id = "${widget.grupo_monitoreo_id}";

    var url = 'https://app.eco2biz.com/eco2biz/ws/null/pr_ws_punto_parametro?punto_id=$punto_id&plan_monitoreo_id=$plan_monitoreo_id&grupo_monitoreo_id=$grupo_monitoreo_id';
    var mapIncGen = Map<String, dynamic>();

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

    //parametros_metales = data.map((e) => Parametro_model.fromJson(e)).toList();
    parametros_metales = data as List;
    return data;
  }


  Future <http.Response>  SubirRegistro(String nom_punto) async {

    String punto_id = "${widget.punto_id}";
    String plan_monitoreo_id = "${widget.plan_monitoreo_id}";
    String grupo_monitoreo_id = "${widget.grupo_monitoreo_id}";

    var url = 'https://app.eco2biz.com/eco2biz/ws/null/pr_ws_actualizar_punto_param?flag=Tomado&nom_punto=$nom_punto';
    var mapIncGen = Map<String, dynamic>();

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

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MuestrasMonitoreo()));

    return response;
  }

/*
  Future <List<void>> RequestPuntosMonitoreo() async {


    var url = 'https://app.eco2biz.com/eco2biz/ws/null/pr_punto_monitoreo?punto_id=1';
    var mapIncGen = Map<String, dynamic>();
    var datos = [];
    var response = await http.post(Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "userLogin": "joshua.rojas@eco2biz_demo",
        "userPassword": "928504589",
        "systemRoot": "eco2biz"
      },

    );

    print("${response.statusCode}");

    datos = json.decode(response.body)['data'];
    final result =
    (datos.map((e) => puntoMonitoreo_model.fromJson(e)).toList() as List).map((emp) {
      print('Insertando.. $emp');
      sqlDb.createpuntoMonitoreo(emp);
    }).toList();
    return result;
  }

  Future <List<void>> RequestMetales() async {

    var url = 'https://app.safe2biz.com/safe2biz_demo/ws/null/pr_ws_metales_punto?punto_id=1';
    var mapIncGen = Map<String, dynamic>();
    var datos = [];
    var response = await http.post(Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "userLogin": "joshua.rojas@eco2biz_demo",
        "userPassword": "928504589",
        "systemRoot": "eco2biz"
      },

    );

    print("${response.statusCode}");

    datos = json.decode(response.body)['data'];
    final result =
    (datos.map((e) => Metales_model.fromJson(e)).toList() as List).map((emp) {
      print('Insertando.. $emp');
      sqlDb.createMuestraMetales(emp);
    }).toList();
    return result;

  }

 */
}
















