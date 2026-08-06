import 'dart:async';

import 'package:flutter/material.dart';
import 'package:form_plus/src/core/form.dart';
import 'package:form_plus/src/validators/form_validator_base.dart';

enum FormPlusAutovalidateMode {
  /// Use FormPlus.maybeOf(context)?.validate() for validate the form
  disabled,

  /// Form will be validate automaticly on initState and didUpdateWidget in FomrPlusState
  always,

  /// Form will be validate when formFieldPlus.value was changed and it detected on didUpdateWidget
  onChanged,

  /// Form will be validate when focus was unfocused
  onUnfocus,

  /// Form will be validate when focus was focused
  onFocus,
}

class FormFieldPlus<T extends Object?> extends StatefulWidget {
  const FormFieldPlus({
    required this.builder,
    required this.validator,
    this.value,
    this.autovalidateMode = FormPlusAutovalidateMode.disabled,
    this.observedFocus,
    super.key,
  });

  /// Set actual value from field
  final T? value;

  /// Class with validator that will be validate formField
  final FormValidatorBase validator;

  /// Set FocusNode from field for validate form on onUnfocus and onFocus
  final FocusNode? observedFocus;

  final FormPlusAutovalidateMode autovalidateMode;

  /// Build widget by error text from validator
  final Widget Function(String? error) builder;

  @override
  State<FormFieldPlus<T>> createState() => FormFieldPlusState<T>();
}

@protected
class FormFieldPlusState<T extends Object?> extends State<FormFieldPlus<T>> {
  final ValueNotifier<String?> _error = ValueNotifier(null);

  @override
  void initState() {
    super.initState();

    if (widget.autovalidateMode == FormPlusAutovalidateMode.onFocus ||
        widget.autovalidateMode == FormPlusAutovalidateMode.onUnfocus) {
      widget.observedFocus?.addListener(focusHandler);
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FormPlus.maybeOf(context)?.register(this);
      if (widget.autovalidateMode == FormPlusAutovalidateMode.always) {
        validate();
      }
    });
  }

  FutureOr<String?>? validate() async {
    _error.value = await widget.validator.call(widget.value);

    return _error.value;
  }

  @override
  void didUpdateWidget(covariant FormFieldPlus<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autovalidateMode == FormPlusAutovalidateMode.always) {
      validate();
    } else if (widget.value != oldWidget.value &&
        widget.autovalidateMode == FormPlusAutovalidateMode.onChanged) {
      validate();
    }
  }

  @override
  void dispose() {
    _error.dispose();
    widget.observedFocus?.removeListener(focusHandler);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _error,
      builder: (final context, final value, _) =>
          widget.builder(widget.validator.forceErrorText ?? value),
    );
  }

  void focusHandler() {
    final hasFocus = widget.observedFocus?.hasFocus ?? false;

    final hasFocusAndModeFocus =
        hasFocus && widget.autovalidateMode == FormPlusAutovalidateMode.onFocus;

    final hasNotFocusAndModeUnfocus =
        !hasFocus && widget.autovalidateMode == FormPlusAutovalidateMode.onUnfocus;

    if (hasFocusAndModeFocus || hasNotFocusAndModeUnfocus) validate();
  }
}
