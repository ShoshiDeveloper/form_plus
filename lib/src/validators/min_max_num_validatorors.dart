import 'dart:async';

import 'package:form_plus/form_plus.dart';

class MaxNumValidator extends FormValidatorBase<num> {
  const MaxNumValidator({
    required this.max,
    required this.min,
    this.withEqual = true,
    super.forceErrorText,
    super.validatorErrorText,
  });

  final int max;
  final int min;
  final bool withEqual;

  @override
  FutureOr<String?>? call(num? value) {
    if (value == null) return null;

    if (withEqual) return value <= min || value >= max ? validatorErrorText : null;

    return value < min || value > max ? validatorErrorText : null;
  }
}
