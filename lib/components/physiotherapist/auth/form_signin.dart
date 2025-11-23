import 'package:flutter/material.dart';
import 'package:physioapp/exception/auth_signup_exception.dart';
import 'package:physioapp/services/auth/auth_form.dart';
import 'package:physioapp/services/auth/physio/auth_physio_service.dart';
import 'package:physioapp/utils/app_routes.dart';
import 'package:physioapp/utils/signup_page_form.dart';
import 'package:provider/provider.dart';

enum RadioButton {
  physioOption,
  therapyOption,
}

class FormSignIn extends StatefulWidget {
  const FormSignIn({super.key});

  @override
  FormSignInState createState() => FormSignInState();
}

class FormSignInState extends State<FormSignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _vibilityPassword = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formData = AuthFormData();
  final authException = AuthSignupException();
  RadioButton _radioPhysioValue = RadioButton.physioOption;
  bool _physioOptionSelect() => _radioPhysioValue == RadioButton.physioOption;

  void _onChangedRadioValue({required RadioButton? value}) {
    setState(() {
      _radioPhysioValue = value ?? RadioButton.physioOption;
    });
  }

  Future<void> _submit({required SignUpPageForm pageForm}) async {
    final auth = AuthPhysioService();
    try {
      pageForm.toggleLoadingValue();
      await auth.login(
        email: formData.email!,
        password: formData.password!,
      );

      if (mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.tabPagePhysio, (_) => false);
      }
    } catch (error) {
      if (mounted) {
        authException.showErrorSubmit(
            messageError: error.toString(), context: context);
      }
    } finally {
      pageForm.toggleLoadingValue();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageForm = Provider.of<SignUpPageForm>(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                  color: const Color.fromARGB(255, 110, 125, 162), width: 1),
            ),
            child: TextFormField(
              onChanged: (email) => formData.email = email,
              decoration: InputDecoration(
                label: Text(
                  'Email',
                  style: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.bodyMedium?.fontFamily,
                    color: Theme.of(context).textTheme.labelMedium?.color,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                  color: const Color.fromARGB(255, 110, 125, 162), width: 1),
            ),
            child: TextFormField(
              onChanged: (password) => formData.password = password,
              decoration: InputDecoration(
                label: Text(
                  'Senha',
                  style: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.bodyMedium?.fontFamily,
                    color: Theme.of(context).textTheme.labelMedium?.color,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                border: InputBorder.none,
                suffixIcon: _vibilityPassword == true
                    ? GestureDetector(
                        onTap: () {
                          setState(
                              () => _vibilityPassword = !_vibilityPassword);
                        },
                        child: Icon(
                          Icons.visibility_outlined,
                          color: Theme.of(context).textTheme.labelLarge?.color,
                          size: 22,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(
                              () => _vibilityPassword = !_vibilityPassword);
                        },
                        child: Icon(
                          Icons.visibility_off_outlined,
                          color: Theme.of(context).textTheme.labelLarge?.color,
                          size: 22,
                        ),
                      ),
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: _vibilityPassword == true ? false : true,
              controller: _passwordController,
            ),
          ),
          Container(
            height: 60,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 20),
            child: pageForm.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onPressed: () => _submit(pageForm: pageForm),
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily:
                            Theme.of(context).textTheme.titleLarge?.fontFamily,
                        fontSize:
                            Theme.of(context).textTheme.titleLarge?.fontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Esqueci minha senha',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontFamily:
                      Theme.of(context).textTheme.labelLarge?.fontFamily,
                  fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                  decorationColor: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
