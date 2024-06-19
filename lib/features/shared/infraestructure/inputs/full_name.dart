import 'package:formz/formz.dart';

enum FullNameError { empty, value }

class FullName extends FormzInput<String, FullNameError> {
  const FullName.pure() : super.pure('');

  const FullName.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == FullNameError.empty) return 'El campo es obligatorio';

    return null;
  }

  @override
  FullNameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return FullNameError.empty;

    return null;
  }
}
