import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:teslo_shop/features/shared/infraestructure/inputs/repeat_password.dart';
import 'package:teslo_shop/features/shared/shared.dart';

part 'register_form_state.dart';

class RegisterFormCubit extends Cubit<RegisterFormState> {
  final AuthCubit authCubit;
  RegisterFormCubit({required this.authCubit}) : super(RegisterFormState());

  void emailChange(String value) {
    final newEmail = Email.dirty(value);
    emit(state.copyWith(
        email: newEmail,
        isValid: Formz.validate(
            [newEmail, state.password, state.fullName, state.repeatPassword])));
  }

  void passwordChange(String value) {
    final newPassword = Password.dirty(value);
    //final newRepeatPassword = RepeatPassword.dirty(state.repeatPassword.value);
    emit(state.copyWith(
        password: newPassword,
        //repeatPassword: newRepeatPassword,
        isValid: Formz.validate(
            [newPassword, state.email, state.fullName, state.repeatPassword])));
  }

  void repeatPasswordChange(String value) {
    final newRepeatPassword =
        RepeatPassword.dirty(password: state.password.value, value: value);
    emit(state.copyWith(
        repeatPassword: newRepeatPassword,
        isValid: Formz.validate(
            [newRepeatPassword, state.email, state.password, state.fullName])));
  }

  void fullNameChange(String value) {
    final newFullName = FullName.dirty(value);
    emit(state.copyWith(
      fullName: newFullName,
      isValid: Formz.validate(
          [newFullName, state.email, state.password, state.repeatPassword]),
    ));
  }

  void onSubmit() async {
    _tocuchEveryfield();
    if (!state.isValid) return;
    await authCubit.registerUser(
        state.email.value, state.password.value, state.fullName.value);
    print(state);
  }

  void _tocuchEveryfield() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final repeatPassword = RepeatPassword.dirty(password: state.password.value, value: state.repeatPassword.value);
    final fullName = FullName.dirty(state.fullName.value);

    emit(state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      fullName: fullName,
      repeatPassword: repeatPassword,
      isValid: Formz.validate([email, password, fullName, repeatPassword]),
    ));
  }
}
