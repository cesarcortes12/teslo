import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:teslo_shop/features/auth/infraestructure/infraestructure.dart';
import 'package:teslo_shop/features/shared/infraestructure/inputs/services/key_value_storage_service.dart';
import 'package:teslo_shop/features/shared/infraestructure/inputs/services/key_value_storage_service_impl.dart';

import '../../../domain/domain.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthCubit(
      {required this.authRepository, required this.keyValueStorageService})
      : super(AuthState()) {
    checkAuthStatus();
  }

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

  //sino hace la peticion revisar ip
  Future<void> registerUser(
      String email, String password, String fullName) async {
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

  Future<void> checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');

    if (token == null) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  Future<void> logout([String? errorMessage]) //ese error mesage es opcional
  async {
    //TODO: limpiar token
    await keyValueStorageService.removeKey('token');
    emit(state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage));
    print('funciona logged out: ${state.authStatus}');
  }

//metodo centralizado y privado ya que las funciones hacen un estado similar
  void _setLoggedUser(User user) async {
    //TODO: NECESITO GUARDAR EL TOKEN FISICAMENTE
    await keyValueStorageService.setKeyValue('token', user.token);
    emit(state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
    ));
    print('funciona setloggeduser: ${state.authStatus}');
  }
}
