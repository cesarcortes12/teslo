part of 'register_form_cubit.dart';

class RegisterFormState extends Equatable {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;
  final FullName fullName;
  final RepeatPassword repeatPassword;

  const RegisterFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.fullName = const FullName.pure(),
      this.repeatPassword= const RepeatPassword.pure(password: '') });

  RegisterFormState copyWith(
          {bool? isPosting,
          bool? isFormPosted,
          bool? isValid,
          Email? email,
          Password? password,
          FullName? fullName,
          RepeatPassword? repeatPassword}) =>
      RegisterFormState(
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isValid: isValid ?? this.isValid,
          email: email ?? this.email,
          password: password ?? this.password,
          fullName: fullName ?? this.fullName,
          repeatPassword: repeatPassword ?? this.repeatPassword);

  @override
  List<Object> get props =>
      [isPosting, isFormPosted, isValid, email, password, fullName, repeatPassword];

  //ESTO ES PARA CUANDO HAGAMOS UN PRINT ENTONCES ES MAS FACIL VER LOS DATOS
  @override
  String toString() {
    return '''
  RegisterFormState:
    isPosting: $isPosting,
    isFormPosted: $isFormPosted,
    isValid: $isValid,
    email: $email,
    password: $password,
    fullName: $fullName,
    repeatPassword: $repeatPassword
''';
  }


}


