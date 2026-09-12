import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_plus/src/core/formfield.dart';

@protected
class FormPlusScope extends InheritedWidget {
  const FormPlusScope({super.key, required super.child, required this.formState});

  final FormPlusState formState;

  @override
  bool updateShouldNotify(FormPlusScope oldWidget) =>
      listEquals(formState.fields, oldWidget.formState.fields);
}

class FormPlus extends StatefulWidget {
  const FormPlus({required this.child, super.key});

  final Widget child;

  static FormPlusState? maybeOf(final BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FormPlusScope>()?.formState;

  @override
  State<FormPlus> createState() => FormPlusState();
}

class FormPlusState extends State<FormPlus> {
  final fields = <FormFieldPlusState>[];

  void register(FormFieldPlusState formField) {
    fields.add(formField);
  }

  FutureOr<bool> validate() async {
    for (final field in fields) {
      final error = await field.validate();

      if (error != null) return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FormPlusScope(formState: this, child: widget.child);
  }
}
