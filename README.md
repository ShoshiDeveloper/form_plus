# Form Plus

[![pub package](https://img.shields.io/pub/v/form_plus.svg)](https://pub.dev/packages/form_plus)

`form_plus` provides a lightweight, composable form layer for Flutter. Build
custom form controls with a shared form scope, synchronous or asynchronous
validation, and validation feedback rendered by the field itself.

## Features

- Wrap a group of fields with `FormPlus`.
- Create custom controls with the generic `FormFieldPlus<T>` widget.
- Use synchronous or asynchronous validators (`FutureOr<String?>`).
- Validate fields manually or automatically.
- Compose validators with `MultiValidator`.
- Use built-in required, email, callback, length, and numeric validators.

## Installation

Add `form_plus` to your `pubspec.yaml`:

```yaml
dependencies:
  form_plus: ^0.0.6
```

Then fetch the package:

```bash
flutter pub get
```

Import it in your Dart code:

```dart
import 'package:form_plus/form_plus.dart';
```

## Basic usage

Place `FormFieldPlus` widgets below a `FormPlus` and provide a builder that
renders the current validation error:

```dart
class NameField extends StatefulWidget {
  const NameField({super.key});

  @override
  State<NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField> {
  String? name;

  @override
  Widget build(BuildContext context) {
    return FormFieldPlus<String>(
      value: name,
      validator: CallbackValidator<String>(
        callback: (value) {
          return value == null || value.isEmpty ? 'Name is required' : null;
        },
      ),
      autovalidateMode: FormPlusAutovalidateMode.onChanged,
      builder: (error) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (value) => setState(() => name = value),
          ),
          if (error != null)
            Text(error, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FormPlus(
      child: const NameField(),
    );
  }
}
```

## Validating a form

Call `FormPlus.maybeOf(context)?.validate()` from a descendant of `FormPlus`.
Validation may be asynchronous, so await the returned result:

```dart
final isValid = await FormPlus.maybeOf(context)?.validate() ?? false;

if (isValid) {
  // Submit the form.
}
```

## Autovalidation

Set `FormPlusAutovalidateMode` on a field:

- `disabled`: validate only when `validate()` is called.
- `always`: validate during initialization and widget updates.
- `onChanged`: validate when the field value changes.
- `onFocus`: validate when the observed focus node gains focus.
- `onUnfocus`: validate when the observed focus node loses focus.

For `onFocus` and `onUnfocus`, pass the field's `FocusNode` as
`observedFocus`.

## Built-in validators

The package exports these validators:

- `RequiredValidator<T>`
- `EmailValidator`
- `CallbackValidator<T>`
- `MultiValidator<T>`
- `OverStringLengthValidator`
- `UnderStringLengthValidator`
- `MinNumValidator`
- `MaxNumValidator`
- `MinMaxNumValidator`

All validators support `validatorErrorText`, which is returned when validation
fails, and `forceErrorText`, which displays an error without running
validation. `CallbackValidator` and custom validators can return a
`Future<String?>` for asynchronous checks:

```dart
final validator = CallbackValidator<String>(
  validatorErrorText: 'This name is unavailable',
  callback: (value) async {
    if (value == null || value.isEmpty) return 'Enter a name';

    final available = await checkNameAvailability(value);
    return available ? null : 'This name is unavailable';
  },
);
```

Combine multiple validators and stop at the first error:

```dart
final validator = MultiValidator<String>(
  validators: [
    const RequiredValidator<String>(validatorErrorText: 'Required'),
    const EmailValidator(validatorErrorText: 'Invalid email'),
  ],
);
```

## Custom validators

Extend `FormValidatorBase<T>` when the built-in validators do not cover your
case:

```dart
import 'dart:async';

class TermsValidator extends FormValidatorBase<bool> {
  const TermsValidator();

  @override
  FutureOr<String?>? call(bool? value) {
    return value == true ? null : 'Accept the terms to continue';
  }
}
```

## Example app

Run the included example from the repository root:

```bash
cd example
flutter pub get
flutter run
```

## Requirements

- Dart SDK `>=3.11.5`
- Flutter `>=1.17.0`

## License

This package is available under the BSD 3-Clause license. See [LICENSE](LICENSE)
for the full text.

## Links

- [Package on pub.dev](https://pub.dev/packages/form_plus)
- [Source repository](https://github.com/ShoshiDeveloper/form_plus)
- [Homepage](https://shoshi.tech)
