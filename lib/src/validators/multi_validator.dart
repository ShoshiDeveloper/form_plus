import 'dart:async';

import 'package:form_plus/form_plus.dart';

class MultiValidator<T extends Object?> extends FormValidatorBase<T> {
  const MultiValidator({
    this.validators = const [],
    super.forceErrorText,
    super.validatorErrorText,
  });

  final List<FormValidatorBase> validators;

  @override
  FutureOr<String?>? call(T? value) async {
    for (final validator in validators) {
      final error = await validator.call(value);

      if (error != null) return validatorErrorText ?? error;
    }

    return null;
  }
}
