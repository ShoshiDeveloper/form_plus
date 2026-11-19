import 'dart:async';

import 'package:form_plus/form_plus.dart';

class RequiredValidator<T extends Object?> extends FormValidatorBase<T> {
  const RequiredValidator({super.forceErrorText, super.validatorErrorText});

  @override
  FutureOr<String?>? call(T? value) {
    if (value is String) return value.trim().isEmpty ? validatorErrorText : null;
    if (value is bool) return !value ? validatorErrorText : null;

    return value == null ? validatorErrorText : null;
  }
}
