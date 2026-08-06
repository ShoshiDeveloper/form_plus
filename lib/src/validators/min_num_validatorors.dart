import 'dart:async';

import 'package:form_plus/form_plus.dart';

class MinNumValidator extends FormValidatorBase<num> {
  const MinNumValidator({
    required this.min,
    this.withEqual = true,
    super.forceErrorText,
    super.validatorErrorText,
  });

  final int min;
  final bool withEqual;

  @override
  FutureOr<String?>? call(num? value) {
    if (value == null) return null;

    if (withEqual) return value <= min ? validatorErrorText : null;

    return value < min ? validatorErrorText : null;
  }
}
