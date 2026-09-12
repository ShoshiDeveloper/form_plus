import 'package:flutter/material.dart';
import 'package:form_plus/form_plus.dart';

void main() {
  runApp(const FormPlusExampleApp());
}

class FormPlusExampleApp extends StatelessWidget {
  const FormPlusExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Plus example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const ExampleFormPage(),
    );
  }
}

class ExampleFormPage extends StatefulWidget {
  const ExampleFormPage({super.key});

  @override
  State<ExampleFormPage> createState() => _ExampleFormPageState();
}

class _ExampleFormPageState extends State<ExampleFormPage> {
  String? email;
  String? password;
  String? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Plus')),
      body: FormPlus(
        child: Builder(
          builder: (context) => ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Create an account',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              FormFieldPlus<String>(
                value: email,
                autovalidateMode: FormPlusAutovalidateMode.onChanged,
                validator: MultiValidator<String>(
                  validators: [
                    const RequiredValidator<String>(
                      validatorErrorText: 'Email is required',
                    ),
                    const EmailValidator(
                      validatorErrorText: 'Enter a valid email',
                    ),
                  ],
                ),
                builder: (error) => _Field(
                  label: 'Email',
                  error: error,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => setState(() => email = value),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FormFieldPlus<String>(
                value: password,
                autovalidateMode: FormPlusAutovalidateMode.onChanged,
                validator: CallbackValidator<String>(
                  callback: (value) async {
                    await Future<void>.delayed(
                      const Duration(milliseconds: 250),
                    );
                    if (value == null || value.length < 8) {
                      return 'Use at least 8 characters';
                    }
                    return null;
                  },
                ),
                builder: (error) => _Field(
                  label: 'Password',
                  error: error,
                  child: TextField(
                    obscureText: true,
                    onChanged: (value) => setState(() => password = value),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  final isValid =
                      await FormPlus.maybeOf(context)?.validate() ?? false;
                  setState(() {
                    result = isValid
                        ? 'Form is valid'
                        : 'Please fix the errors above';
                  });
                },
                child: const Text('Validate'),
              ),
              if (result != null) ...[
                const SizedBox(height: 12),
                Text(
                  result!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.error,
    required this.child,
  });

  final String label;
  final String? error;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        child,
        if (error != null) ...[
          const SizedBox(height: 4),
          Text(
            error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ],
    );
  }
}
