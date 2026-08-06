import 'dart:async';

import 'package:form_plus/form_plus.dart';

class CallbackValidator<T extends Object?> extends FormValidatorBase<T> {
  const CallbackValidator({required this.callback, super.forceErrorText, super.validatorErrorText});

  final FutureOr<String?>? Function(T? value) callback;

  @override
  FutureOr<String?>? call(T? value) => callback(value);
}
