import 'package:flutter/material.dart';
import 'package:physioapp/components/form_components.dart';
import 'package:physioapp/exception/auth_signup_exception.dart';
import 'package:physioapp/services/auth/auth_form.dart';
import 'package:physioapp/utils/signup_page_form.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FormSignUpPatient extends StatefulWidget {
  final void Function(AuthFormData) onSubmited;
  const FormSignUpPatient({
    super.key,
    required this.onSubmited,
  });

  @override
  FormSignUpPatientState createState() => FormSignUpPatientState();
}

class FormSignUpPatientState extends State<FormSignUpPatient> {
  bool termOfUseAccepted = false;
  final Uri urlTermOfUse = Uri.parse('https://zampini28.github.io/termo-de-uso-physioapp');
  // Atributos de controle
  final AuthFormData _authForm = AuthFormData();
  final _authException = AuthSignupException();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _vibilityPassword = false;
  bool _visibilityConfirmPassword = false;
  final TextEditingController _passwordController = TextEditingController();

  // Metodo para submissão de formulário
  Future<void> _validateForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid == false) return;

    // Validação de campos
    if (_authForm.name == null || _authForm.name!.isEmpty || _authForm.name!.length < 5) {
      return _authException.showErrorValidate(
        message: 'Digite seu nome completo!',
        context: context,
      );
    }
    if (_authForm.email == null || _authForm.email!.isEmpty || !_authForm.email!.contains('@')) {
      return _authException.showErrorValidate(
        message: 'Digite um e-mail valído!',
        context: context,
      );
    }
    if (_authForm.password == null ||
        _authForm.password!.isEmpty ||
        _authForm.password!.length < 6) {
      return _authException.showErrorValidate(
        message: 'Digite uma senha com pelo menos 6 caracteres!',
        context: context,
      );
    }
    if (_passwordController.text != _authForm.password) {
      return _authException.showErrorValidate(
        message: 'As senhas digitadas estão divergentes!',
        context: context,
      );
    }
    
    if (!termOfUseAccepted) {
      return _authException.showErrorValidate(
        message: 'Você deve aceitar os termos de uso!',
        context: context,
      );
    }

    widget.onSubmited(_authForm);
  }

  @override
  Widget build(BuildContext context) {
    final pageForm = Provider.of<SignUpPageForm>(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FormComponents(
            textForm: TextFormField(
              onChanged: (name) => _authForm.name = name,
              decoration: InputDecoration(
                label: Text(
                  'Nome Completo',
                  style: TextStyle(
                    fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                    color: Theme.of(context).textTheme.labelMedium?.color,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.name,
            ),
          ),
          FormComponents(
            textForm: TextFormField(
              onChanged: (email) => _authForm.email = email,
              decoration: InputDecoration(
                label: Text(
                  'Email',
                  style: TextStyle(
                    fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                    color: Theme.of(context).textTheme.labelMedium?.color,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          FormComponents(
            textForm: TextFormField(
              onChanged: (password) => _authForm.password = password,
              decoration: InputDecoration(
                label: Text(
                  'Senha',
                  style: TextStyle(
                    fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                    color: Theme.of(context).textTheme.labelMedium?.color,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                border: InputBorder.none,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() => _vibilityPassword = !_vibilityPassword);
                  },
                  child: Icon(
                    _vibilityPassword == true
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Theme.of(context).textTheme.labelLarge?.color,
                    size: 22,
                  ),
                ),
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: _vibilityPassword == true ? false : true,
            ),
          ),
          FormComponents(
            textForm: TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                label: Text(
                  'Confirmar Senha',
                  style: TextStyle(
                    fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                    color: Theme.of(context).textTheme.labelMedium?.color,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                border: InputBorder.none,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(
                      () => _visibilityConfirmPassword = !_visibilityConfirmPassword,
                    );
                  },
                  child: Icon(
                    _visibilityConfirmPassword == true
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Theme.of(context).textTheme.labelLarge?.color,
                    size: 22,
                  ),
                ),
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: _visibilityConfirmPassword == true ? false : true,
            ),
          ),
          //  termos de uso
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Aceite nosso', style: TextStyle(color: Colors.white)),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => launchUrl(urlTermOfUse),
                  child: Text(
                    'Termo de Uso.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Checkbox(
                  value: termOfUseAccepted,
                  onChanged: (val) => setState(() => termOfUseAccepted = val ?? false),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 60,
            margin: const EdgeInsets.symmetric(vertical: 20),
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
                    onPressed: () {
                      _validateForm();
                    },
                    child: Text(
                      'Cadastrar',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: Theme.of(context).textTheme.titleLarge?.fontFamily,
                        fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
