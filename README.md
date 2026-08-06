# Form Plus

## Features
Default Form with async functionality.

## Usage
Use FormPlus for create Form base and FormFieldPlus for your components;


FormPlus example: 
```dart
 Widget build(BuildContext context) {
    return Scaffold(
      body: FormPlus(child: Center(child: Input())),
    );
  }
```


FormFieldPlus example:
```dart
class Input extends StatefulWidget {
  const Input({super.key});

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return FormFieldPlus<bool>(
      value: value,
      autovalidateMode: FormPlusAutovalidateMode.onChanged,
      validator: InputValidator(),
      builder: (error) => Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          GestureDetector(
            onTap: () async {
              setState(() {
                value = !value;
              });

              // final error = FormPlus.maybeOf(context)?.validate();
              // print(await error);
            },
            child: Container(width: 32, height: 32, color: value ? Colors.green : Colors.red),
          ),
          if (error != null) Text(error, style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}

class InputValidator extends FormValidatorBase<bool> {
  const InputValidator({super.forceErrorText, super.validatorErrorText});

  @override
  FutureOr<String?>? call(bool? value) {
    return (value ?? false) ? null : 'Some error when value = false';
  }
}

```