import 'package:flutter/material.dart';
import 'package:physioapp/components/patient/auth/form_signup_patient.dart';
import 'package:physioapp/components/physiotherapist/auth/image_picker_widget.dart';
import 'package:physioapp/exception/auth_signup_exception.dart';
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/services/auth/auth_form.dart';
import 'package:physioapp/utils/app_routes.dart';
import 'package:physioapp/utils/signup_page_form.dart';
import 'package:provider/provider.dart';

class SignupPatientPage extends StatefulWidget {
  const SignupPatientPage({super.key});

  @override
  State<SignupPatientPage> createState() => _SignupPatientPageState();
}

class _SignupPatientPageState extends State<SignupPatientPage> {
  Future<void> _submit(AuthFormData authData) async {
    final pageForm = Provider.of<SignUpPageForm>(context, listen: false);

    void showBarError(String message) =>
        AuthSignupException().showErrorValidate(message: message, context: context);

    void showPopupError(String message) =>
        AuthSignupException().showErrorSubmit(messageError: message, context: context);

    try {
      // get user data
      final String? image = AuthFormData.imageProfile;
      final String name = authData.name!;
      final String email = authData.email!;
      final String password = authData.password!;

      // verify image
      if (image == null) {
        showBarError('Imagem não selecionada!');
        return;
      }

      debugPrint(' -- image: ${image.substring(0, 10)}...');
      debugPrint(' -- name: $name');
      debugPrint(' -- email: $email');
      debugPrint(' -- password: $password');

      pageForm.toggleLoadingValue();

      // register user
      final register = await authRegister(
        imageProfile: image,
        fullname: name,
        email: email,
        password: password,
        userType: 'PATIENT',
      );

      if (!register) {
        showPopupError('Usuário já cadastrado!');
        return;
      }
      // login user
      final login = await authLogin(email: email, password: password);

      if (!login) {
        showPopupError('Erro ao conectar com o servidor!');
        return;
      }

      pageForm.toggleForm(value: pageForm.firstForm);

      debugPrint('-- done --');

      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.tabPagePhysio,
        (_) => false,
      );
    } catch (e) {
      debugPrint(' -- error: $e');
      showPopupError('Erro ao conectar com o servidor!');
    } finally {
      pageForm.toggleLoadingValue();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/background_image_auth_patient.jpg',
                ),
                fit: BoxFit.cover),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(114, 20, 24, 27),
                  Color.fromARGB(255, 20, 24, 27),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const ImagePicket(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Cadastre-se',
                      style: TextStyle(
                        fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: Theme.of(context).textTheme.displayMedium?.fontSize,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Crie sua conta e inicie sua jornada de recuperação com apoio profissional.',
                  style: TextStyle(
                    fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FormSignUpPatient(
                  onSubmited: _submit,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, bottom: 64),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Já possui conta? ',
                        style: TextStyle(
                          fontFamily: Theme.of(context).textTheme.labelLarge?.fontFamily,
                          color: Theme.of(context).textTheme.labelLarge?.color,
                          fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).pushReplacementNamed(AppRoutes.signInPatientPage),
                        child: Text(
                          'Entre agora!',
                          style: TextStyle(
                            fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
                            fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
