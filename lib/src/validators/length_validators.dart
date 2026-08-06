import 'dart:async';

import 'package:form_plus/form_plus.dart';

class OverStringLengthValidator extends FormValidatorBase<String> {
  const OverStringLengthValidator({
    required this.length,
    this.withEqual = true,
    super.forceErrorText,
    super.validatorErrorText,
  });

  final int length;
  final bool withEqual;

  @override
  FutureOr<String?>? call(String? value) {
    if (value == null) return null;

    if (withEqual) return value.length >= length ? validatorErrorText : null;

    return value.length > length ? validatorErrorText : null;
  }
}

class UnderStringLengthValidator extends FormValidatorBase<String> {
  const UnderStringLengthValidator({
    required this.length,
    this.withEqual = true,
    super.forceErrorText,
    super.validatorErrorText,
  });

  final int length;
  final bool withEqual;

  @override
  FutureOr<String?>? call(String? value) {
    if (value == null) return null;

    if (withEqual) return value.length <= length ? validatorErrorText : null;

    return value.length < length ? validatorErrorText : null;
  }
}
