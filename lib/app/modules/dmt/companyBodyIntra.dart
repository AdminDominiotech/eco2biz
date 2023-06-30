import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:safe2biz/app/global/controllers/auth_controller.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/global/core/routing/routing.dart';
import 'package:safe2biz/app/modules/auth/features/login/domain/entities/user.dart';
import 'package:safe2biz/app/modules/auth/features/login/presenter/page/login_page.dart';
import 'package:safe2biz/app/modules/eco2biz/toma_muestras_monitoreo/MuestrasMonitoreo.dart';
//-import 'package:safe2biz/app/modules/dmt/moduloCompany.dart';
class CompanyBodyIntra extends StatefulWidget {

  final String? user_login, user_id;
  CompanyBodyIntra({Key? key, this.user_login, this.user_id}) : super(key: key);

  @override
  State<CompanyBodyIntra> createState() => _CompanyBodyIntraState();
}

class _CompanyBodyIntraState extends State<CompanyBodyIntra> {
  @override
  Widget build(BuildContext context) {

    print("sc_id ---> ${widget.user_id}");

    return Scaffold(

      appBar: AppBar(
        title: Text("Módulos",
          style: TextStyle(fontSize: S2BTypography.h6, fontWeight: FontWeight.w500),),
        backgroundColor: Color(0xffADC22F),

        actions: [

          IconButton(icon: Icon(Icons.logout), color: S2BColors.whiteSecundary, onPressed: () {

            _logout(context);

          },)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Modulo 1
            SizedBox(height: 12,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(

                    width: MediaQuery.of(context).size.width*0.94,
                    height: 90,
                    child: InkWell(
                      onTap: (){
                     //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => MisTareas(sc_id: '${widget.sc_id}',)));
                      },

                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: Color(0xffADC22F),
                              width: 1//<-- SEE HERE
                          ),
                        ),
                        color: Colors.white,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color:  Color(0xffADC22F),
                                        ),
                                        padding:  EdgeInsets.all(8.0),
                                        child: Image.asset('assets/icons/incidencia.png',  width: 40, color: Colors.white,)
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 14),
                                      child: Text("Incidentes Ambientales", style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w500,  ),),
                                    ),
                                  ],
                                ),

                                Container(
                                  child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey,),
                                )





                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate()
                .fade(duration: 100.ms),


            //Modulo Tareas


            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(


                    width: MediaQuery.of(context).size.width*0.94,
                    height: 90,
                    child: InkWell(
                      onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MuestrasMonitoreo()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: Color(0xffADC22F),
                              width: 1//<-- SEE HERE
                          ),
                        ),
                        color: Colors.white,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color:  Color(0xffADC22F),
                                        ),
                                        padding:  EdgeInsets.all(8.0),


                                        child: Image.asset('assets/icons/muestras_monitoreo.png',  width: 40,  color: Colors.white)
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 14),
                                      child: Text("Muestras de Monitoreo", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500,  ),),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey,),
                                )


                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            ).animate()
                .fade(duration: 500.ms),



            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(

                    width: MediaQuery.of(context).size.width*0.94,
                    height: 90,
                    child: InkWell(
                      onTap: (){
                      //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MisIncidencias(user_login : '${widget.user_login}')));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: Color(0xffADC22F),
                              width: 1//<-- SEE HERE
                          ),
                        ),
                        color: Colors.white,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color:  Color(0xffADC22F),
                                        ),
                                        padding:  EdgeInsets.all(8.0),


                                        child: Image.asset('assets/icons/aprobacion_materias.png',  width: 40,  color: Colors.white)
                                    ),

                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 14),
                                      child: Text("Aprobación de Muestras", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500,  ),),
                                    ),


                                  ],
                                ),

                                Container(
                                  child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey,),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate()
                .fade(duration: 1200.ms),

            //Modulo 2
            Container(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(

                    width: MediaQuery.of(context).size.width*0.94,
                    height: 90,
                    child: InkWell(
                      onTap: (){

                    //    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Incidencias()));


                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: Color(0xffADC22F),
                              width: 1//<-- SEE HERE
                          ),
                        ),
                        color: Colors.white,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color:  Color(0xffADC22F),
                                        ),
                                        padding:  EdgeInsets.all(8.0),
                                        child:    Image.asset('assets/icons/residuos_almacenamiento.png' , width: 40, color: Colors.white)
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 14),
                                      child: Text("Residuos Almacenamiento", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500,  ),),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey,),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate()
                .fade(duration: 1900.ms),

            //Modulo 3


            Container(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(

                    width: MediaQuery.of(context).size.width*0.94,
                    height: 90,
                    child: InkWell(
                      onTap: (){
                  //      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Pases()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: Color(0xffADC22F),
                              width: 1//<-- SEE HERE
                          ),
                        ),
                        color: Colors.white,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color:  Color(0xffADC22F),
                                        ),
                                        padding:  EdgeInsets.all(8.0),

                                        child: Image.asset('assets/icons/residuos_disp_final.png',  width: 40,  color: Colors.white)
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 14),
                                      child: Text("Residuos Disposición Final", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500,  ),),
                                    ),

                                  ],
                                ),
                                Container(
                                  child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey,),
                                )

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate()
                .fade(duration: 2600.ms),



            //Modulo 4

            Container(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(

                    width: MediaQuery.of(context).size.width*0.94,
                    height: 90,
                    child: InkWell(
                      onTap: (){
                    //    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Facturas()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: Color(0xffADC22F),
                              width: 1//<-- SEE HERE
                          ),
                        ),
                        color: Colors.white,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [

                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color:  Color(0xffADC22F),
                                        ),
                                        padding:  EdgeInsets.all(8.0),

                                        child: Image.asset('assets/icons/planes_accion.png',  width: 40,  color: Colors.white)
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 14),
                                      child: Text("Planes de Acción", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500,  ),),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey,),
                                )

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate()
                .fade(duration: 3300.ms),



            //Modulo 5


            Container(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(

                    width: MediaQuery.of(context).size.width*0.94,
                    height: 90,
                    child: InkWell(
                      onTap: (){
                  //      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SaldoProyecto()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: Color(0xffADC22F),
                              width: 1//<-- SEE HERE
                          ),
                        ),
                        color: Colors.white,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color:  Color(0xffADC22F),
                                        ),
                                        padding:  EdgeInsets.all(8.0),


                                        child: Image.asset('assets/icons/estadistica_monitoreo.png',  height: 50, width: 40, color: Colors.white,)
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 14),
                                      child: Text("Estadística Monitoreo", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500,  ),),
                                    ),

                                  ],
                                ),
                                Container(
                                  child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey,),
                                )

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate()
                .fade(duration: 4000.ms),

            Container(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(

                    width: MediaQuery.of(context).size.width*0.94,
                    height: 90,
                    child: InkWell(
                      onTap: (){
                        //      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SaldoProyecto()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: Color(0xffADC22F),
                              width: 1//<-- SEE HERE
                          ),
                        ),
                        color: Colors.white,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color:  Color(0xffADC22F),
                                        ),
                                        padding:  EdgeInsets.all(8.0),


                                        child: Image.asset('assets/icons/estadistica_residuos.png',  height: 50, width: 40, color: Colors.white,)
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 14),
                                      child: Text("Estadística Residuos", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500,  ),),
                                    ),

                                  ],
                                ),

                                Container(
                                  child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey,),
                                )

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate()
                .fade(duration: 4700.ms),
          ],
        ),
      ),
    );
  }
}


void _logout(BuildContext context) {
  PopupMessage(
    context: context,
    title: 'Cerrar Sesión',
    bodyText: '¿Esta seguro que desea cerrar la sesión?',
    isDismissible: false,
    onSucess: () async {
      final auth = GetIt.I<AuthController>();

      final result = await auth.logout();
      if (result) {
        await Navigator.pushAndRemoveUntil(
          context,
          FadePageRoute(newPage: const LoginPage()),
              (route) => false,
        );
      } else {
        Toast.show(
          description: 'Hubo un error',
          toastType: ToastType.error,
        );
      }
    },
  );
}
