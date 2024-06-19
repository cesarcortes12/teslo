import 'package:formz/formz.dart';

enum RepeatPasswordError { empty, length, format, noMatch }

class RepeatPassword extends FormzInput<String, RepeatPasswordError> {
  final String password;

  static final RegExp passwordRegExp = RegExp(
    r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$',
  );
  const RepeatPassword.pure({required this.password}) : super.pure('');

  const RepeatPassword.dirty({
    required String value,
    required this.password,
  }) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == RepeatPasswordError.empty)
      return 'El campo es obligatorio';
    if (displayError == RepeatPasswordError.length)
      return 'minimo 6 caracteres';
    if (displayError == RepeatPasswordError.format)
      return 'Debe tener mayuscula, letras y un numero';
    if (displayError == RepeatPasswordError.noMatch)
      return 'contraseña no coincide';
  }

  @override
  RepeatPasswordError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return RepeatPasswordError.empty;
    if (value.length < 6) return RepeatPasswordError.length;
    if (!passwordRegExp.hasMatch(value)) return RepeatPasswordError.format;
    if (password != value) return RepeatPasswordError.noMatch;
  }
}
