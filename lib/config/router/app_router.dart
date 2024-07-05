import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:teslo_shop/features/products/products.dart';

class Approuter {
  final AuthCubit authCubit;
  Approuter(this.authCubit);

  late final GoRouter appRouter = GoRouter(
      initialLocation: '/splash',
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const CheckAuthStatusScreen(),
        ),

        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),

        ///* Product Routes
        GoRoute(
          path: '/',
          builder: (context, state) => const ProductsScreen(),
        ),
        GoRoute(
          path: '/product/:id',
          builder: (context, state) =>  ProductScreen(
            productId: state.params['id'] ?? 'no-id' ,),
        ),

      ],
      redirect: (context, state) {
        final isGointTo = state.subloc;
        AuthStatus authStatus = authCubit.state.authStatus;

        /*(
          listener: (context, state) {
            if (state.authStatus == AuthStatus.authenticated) {
              authStatus = AuthStatus.authenticated;
            }
          },
        );*/

        print('GoRouter authStatus: $authStatus, isGointTo: $isGointTo');

        if (isGointTo == '/splash' && authStatus == AuthStatus.checking)
          return null;

        if (authStatus == AuthStatus.notAuthenticated) {
          if (isGointTo == '/login' || isGointTo == '/register') return null;
          return '/login';
        }

        if (authStatus == AuthStatus.authenticated) {
          if (isGointTo == '/login' ||
              isGointTo == '/register' ||
              isGointTo == '/splash') {
            return '/';
          }
        }
        print('fffffffffffffff ${state.subloc}');
        return null;
      });
}
