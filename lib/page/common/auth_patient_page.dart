import 'package:flutter/material.dart';
import 'package:physioapp/utils/app_routes.dart';

class AuthPatientPage extends StatelessWidget {
  const AuthPatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 236, 236),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Color.fromARGB(78, 255, 255, 255), BlendMode.colorDodge),
            filterQuality: FilterQuality.high,
            opacity: 0.9,
            image: AssetImage(
              'assets/images/background_image_auth_patient.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 70),
              child: Text(
                'O seu\natendimento\ndireto no celular',
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.justify,
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              margin: const EdgeInsets.only(
                top: 20,
                right: 16,
                left: 16,
                bottom: 60,
              ),
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.signInPatientPage),
                label: Text(
                  'Entre com email e senha',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                    fontFamily: Theme.of(context).textTheme.titleLarge?.fontFamily,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                icon: const Icon(
                  Icons.mail_outline_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Não possui conta? ',
                    style: TextStyle(
                      fontFamily: Theme.of(context).textTheme.labelLarge?.fontFamily,
                      color: Theme.of(context).textTheme.labelLarge?.color,
                      fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(AppRoutes.signUpPatientPage),
                    child: Text(
                      'Cadastre-se agora!',
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
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
