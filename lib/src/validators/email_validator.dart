import 'dart:async';

import 'package:form_plus/form_plus.dart';

class EmailValidator extends FormValidatorBase<String> {
  const EmailValidator({super.forceErrorText, super.validatorErrorText});

  @override
  FutureOr<String?>? call(String? value) {
    if (value == null) return validatorErrorText;

    final parts = value.split('@');

    if (parts.length < 2 || parts.length > 2 || parts[1].split('.').length != 2) {
      return validatorErrorText;
    }

    return null;
  }
}
