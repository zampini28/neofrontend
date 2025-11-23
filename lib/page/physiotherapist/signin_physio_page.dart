import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/auth/form_signin.dart';
import 'package:physioapp/utils/app_routes.dart';

class SigninPhysioPage extends StatelessWidget {
  const SigninPhysioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage('assets/images/background_image_auth_physio.png'),
              fit: BoxFit.cover,
            ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Entrar',
                      style: TextStyle(
                        fontFamily: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.fontFamily,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize:
                            Theme.of(context).textTheme.displayMedium?.fontSize,
                      ),
                    ),
                  ],
                ),
                Text(
                    'Acesse sua conta e otimize o acompanhamento dos seus pacientes.',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.bodyMedium?.fontFamily,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium?.fontSize,
                    )),
                const SizedBox(height: 20),
                const FormSignIn(),
                Container(
                  margin: const EdgeInsets.only(top: 24, bottom: 64),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Não possui conta? ',
                        style: TextStyle(
                          fontFamily: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.fontFamily,
                          color: Theme.of(context).textTheme.labelLarge?.color,
                          fontSize:
                              Theme.of(context).textTheme.labelLarge?.fontSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushNamed(AppRoutes.signUpPhysioPage),
                        child: Text(
                          'Cadastre-se agora!',
                          style: TextStyle(
                            fontFamily: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.fontFamily,
                            fontSize:
                                Theme.of(context).textTheme.bodyLarge?.fontSize,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                Theme.of(context).colorScheme.primary,
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
