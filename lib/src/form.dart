import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_plus/src/formfield.dart';

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
