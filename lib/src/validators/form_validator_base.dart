import 'dart:async';

abstract class FormValidatorBase<T extends Object?> {
  const FormValidatorBase({this.forceErrorText, this.validatorErrorText});

  /// Set an error to be returned immediately without validation.
  final String? forceErrorText;

  /// Error text for return from validate logic (`call()` method).
  final String? validatorErrorText;

  /// Validate value from field by validator function
  FutureOr<String?>? call(T? value);
}
