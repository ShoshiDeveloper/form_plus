import 'dart:async';

import 'package:form_plus/form_plus.dart';

class RequiredValidator<T extends Object?> extends FormValidatorBase<T> {
  const RequiredValidator({super.forceErrorText, super.validatorErrorText});

  @override
  FutureOr<String?>? call(T? value) => value != null ? validatorErrorText : null;
}
