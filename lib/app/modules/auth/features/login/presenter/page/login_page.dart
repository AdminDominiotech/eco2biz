import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/modules/auth/features/login/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/auth/features/login/presenter/bloc/login_bloc.dart';
import 'package:safe2biz/app/modules/auth/features/login/presenter/page/login_body.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = GetIt.I<AuthController>();

    final idSede =
        LocalPreferences.prefs?.getString('current_sede_id') ?? '0';
    String urlExt = '';
    String urlApp = '';
    String arroba = '';
    String id = '';
    if (auth.user.value != null) {
      urlExt = auth.user.value!.urlExt;
      urlApp = auth.user.value!.urlApp;
      arroba = auth.user.value!.arroba;
      id = auth.user.value!.uuid;
    }

    return BlocProvider(
      create: (context) => LoginBloc(
        loginCheckUc: GetIt.I<LoginCheckUcImpl>(),
        authController: GetIt.I<AuthController>(),
        // getAccesosLocalUc: GetIt.I<GetAccesosLocalUcImpl>(),
        // saveAccesosLocalUc: GetIt.I<SaveAccesosLocalUcImpl>(),
      )..add(
          InitEv(),
        ),
      child: const LoginBody(),
    );
  }
}
