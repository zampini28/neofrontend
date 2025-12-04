import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:physioapp/components/form_components.dart';
import 'package:physioapp/exception/auth_signup_exception.dart';
import 'package:physioapp/services/auth/auth_form.dart';
import 'package:physioapp/utils/signup_page_form.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SecondFormSignUp extends StatefulWidget {
  final void Function(AuthFormData) onSubmited;
  const SecondFormSignUp({super.key, required this.onSubmited});

  @override
  SecondFormSignUpState createState() => SecondFormSignUpState();
}

class SecondFormSignUpState extends State<SecondFormSignUp> {
  bool termOfUseAccepted = false;
  final Uri urlTermOfUse = Uri.parse('https://zampini28.github.io/termo-de-uso-physioapp');

  // Atributos de controle
  final AuthSignupException _authException = AuthSignupException();
  final AuthFormData _authForm = AuthFormData();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _vibilityPassword = false;
  bool _visibilityConfirmPassword = false;

  // Metodo para submissão de formulário
  Future<void> _submit() async {
    // PQP - pq vc colocou essa merda aqui se não tem validação nenhuma no form?
    // final isValid = _formKey.currentState?.validate() ?? false;
    // if (isValid == false) return;

    debugPrint('--- sumbit physio register');

    // campos
    final String fname = _authForm.name?.trim() ?? '';
    final String email = _authForm.email?.trim() ?? '';
    final String password = _authForm.password ?? '';
    final String confirmPassword = _confirmPasswordController.text;

    void errorMessage(String message) =>
        _authException.showErrorValidate(message: message, context: context);

    // validações

    // --- nome completo ---
    // 1) deve conter pelo menos um espaço - message: 'Digite seu nome completo!'
    // 2) não deve conter números ou caracteres especiais - message: 'Nome completo não deve conter números ou caracteres especiais!'

    // 1)
    if (fname.isEmpty || !fname.contains(' ')) {
      errorMessage('Digite seu nome completo!');
      return;
    }

    // 2)
    final RegExp nameRegex = RegExp(r'^[a-zA-ZÀ-ÖØ-öø-ÿ\s]+$');
    if (!nameRegex.hasMatch(fname)) {
      errorMessage('Nome completo não deve conter números ou caracteres especiais!');
      return;
    }

    // --- email ---
    // 1) deve ser um email válido - message: 'Digite um e-mail valído!'

    // 1)
    if (!EmailValidator.validate(email)) {
      errorMessage('Digite um e-mail valído!');
      return;
    }

    // --- password ---
    // 1) deve ter pelo menos 8 caracteres - message: 'Digite uma senha com pelo menos 8 caracteres!'
    // 2) deve ter pelo menos uma letra e número - message: 'A senha deve conter ao menos uma letra e um número!'
    // 3) não deve conter mais de 30 caracteres - message: 'A senha não deve conter mais de 30 caracteres!'
    // 4) deve ser igual ao campo de confirmação de senha - message: 'As senhas digitadas estão divergentes!'

    bool _hasLetter(String s) => RegExp(r'[A-Za-z]').hasMatch(s);
    bool _hasDigit(String s)  => RegExp(r'\d').hasMatch(s);

    // 1)
    if (password.length < 8) {
      errorMessage('Digite uma senha com pelo menos 8 caracteres!');
      return;
    }

    // 2)
    if (!(_hasLetter(password) && _hasDigit(password))) {
      errorMessage('A senha deve conter ao menos uma letra e um número!');
      return;
    }

    // 3)
    if (password.length > 30) {
      errorMessage('A senha não deve conter mais de 30 caracteres!');
      return;
    }

    // 4)
    if (password != confirmPassword) {
      errorMessage('As senhas digitadas estão divergentes!');
      return;
    }

    // --- Termo de Uso ---
    if (!termOfUseAccepted) {
      errorMessage('Você deve aceitar o Termo de Uso!');
      return;
    }

    widget.onSubmited(_authForm);
  }

  @override
  Widget build(BuildContext context) {
    final pageForm = Provider.of<SignUpPageForm>(context, listen: false);
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
              controller: _confirmPasswordController,
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
            margin: const EdgeInsets.only(bottom: 10, top: 10),
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
                      _submit();
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
