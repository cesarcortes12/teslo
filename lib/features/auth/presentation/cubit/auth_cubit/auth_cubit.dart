import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:teslo_shop/features/auth/infraestructure/infraestructure.dart';

import '../../../domain/domain.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(AuthState());

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(
        const Duration(milliseconds: 500)); //por seguridad relentizamos
    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado');
    }
  }

  Future<void> registerUser(String email, String password, String fullName) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final user = await authRepository.register(email, password, fullName);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout("error no controlado");
    }
  }

  void checkAuthStatus() async {}

  Future<void> logout([String? errorMessage]) //ese error mesage es opcional
  async {
    //TODO: limpiar token
    emit(state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage));
  }

//metodo centralizado y privado ya que las funciones hacen un estado similar
  void _setLoggedUser(User user) {
    //TODO: NECESITO GUARDAR EL TOKEN FISICAMENTE
    emit(state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
    ));
  }
}
