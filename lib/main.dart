import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/infraestructure/repositories/auth_repository_impl.dart';
import 'package:teslo_shop/features/auth/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:teslo_shop/features/auth/presentation/cubit/login_form_cubit/login_form_cubit.dart';
import 'package:teslo_shop/features/auth/presentation/cubit/register_form_cubit/register_form_cubit.dart';
import 'package:teslo_shop/features/shared/infraestructure/inputs/services/key_value_storage_service_impl.dart';

void main() async {
  await Enviroment.initEnviroment();
  final authRepositoryImpl = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AuthCubit(
                authRepository: authRepositoryImpl,
                keyValueStorageService: keyValueStorageService)),
        BlocProvider(
            create: (context) =>
                LoginFormCubit(authCubit: BlocProvider.of<AuthCubit>(context))),
        BlocProvider(
            create: (context) => RegisterFormCubit(
                authCubit: BlocProvider.of<AuthCubit>(context))),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: Approuter(context.watch<AuthCubit>()).appRouter,
        theme: AppTheme().getTheme(),
      );
    });
    
  }
}
