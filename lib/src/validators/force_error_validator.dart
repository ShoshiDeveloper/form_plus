import 'dart:async';

import 'package:form_plus/form_plus.dart';

class ForceErrorValidator<T extends Object?> extends FormValidatorBase<T> {
  const ForceErrorValidator({super.forceErrorText});

  @override
  FutureOr<String?>? call(T? value) {
    return forceErrorText;
  }
}
