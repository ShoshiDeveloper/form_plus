import 'dart:async';

import 'package:form_plus/form_plus.dart';

class MaxNumValidator extends FormValidatorBase<num> {
  const MaxNumValidator({
    required this.max,
    this.withEqual = true,
    super.forceErrorText,
    super.validatorErrorText,
  });

  final int max;
  final bool withEqual;

  @override
  FutureOr<String?>? call(num? value) {
    if (value == null) return null;

    if (withEqual) return value >= max ? validatorErrorText : null;

    return value > max ? validatorErrorText : null;
  }
}
