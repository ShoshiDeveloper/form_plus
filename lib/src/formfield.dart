import 'dart:async';

import 'package:flutter/material.dart';
import 'package:form_plus/src/form.dart';

enum FormPlusAutovalidateMode {
  /// Use FormPlus.maybeOf(context)?.validate() for validate the form
  disabled,

  /// Form will be validate automaticly on initState and didUpdateWidget in FomrPlusState
  always,

  /// Form will be validate when formFieldPlus.value was changed and it detected on didUpdateWidget
  changed,
}

class FormPlusState extends State<FormPlus> {
  final fields = <FormFieldPlusState>[];

  void register(FormFieldPlusState formField) {
    fields.add(formField);
  }

  FutureOr<bool> validate() async {
    for (final field in fields) {
      final error = await field.validate();

      if (error != null) false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FormPlusScope(formState: this, child: widget.child);
  }
}

class FormFieldPlus<T extends Object?> extends StatefulWidget {
  const FormFieldPlus({
    required this.builder,
    required this.validator,
    this.value,
    this.forceErrorText,
    this.autovalidateMode = FormPlusAutovalidateMode.disabled,
    super.key,
  });

  /// Set actual value from field
  final T? value;

  /// Set an error to be returned immediately without validation.
  final String? forceErrorText;

  /// Build widget by error text from validator
  final Widget Function(String? error) builder;

  /// Validate value from field by validator function
  final FutureOr<String?>? Function(T? value) validator;

  final FormPlusAutovalidateMode autovalidateMode;

  @override
  State<FormFieldPlus<T>> createState() => FormFieldPlusState<T>();
}

@protected
class FormFieldPlusState<T extends Object?> extends State<FormFieldPlus<T>> {
  final ValueNotifier<String?> _error = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
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
        widget.autovalidateMode == FormPlusAutovalidateMode.changed) {
      validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _error,
      builder: (final context, final value, _) => widget.builder(widget.forceErrorText ?? value),
    );
  }
}
