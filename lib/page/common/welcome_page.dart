import 'package:flutter/material.dart';
import 'package:physioapp/utils/app_routes.dart';

enum WelcomePageKind { patient, physio }

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    super.key,
    required this.kind,
  });

  final WelcomePageKind kind;

  String get _backgroundAsset => switch (kind) {
        WelcomePageKind.patient => 'assets/images/background_image_auth_patient.jpg',
        WelcomePageKind.physio => 'assets/images/background_image_auth_physio.png',
      };

  String get _title => switch (kind) {
        WelcomePageKind.patient => 'O seu\natendimento\ndireto no celular',
        WelcomePageKind.physio => 'Junte-se a nós \n& atenda com Confiança',
      };

  TextAlign get _titleAlign => switch (kind) {
        WelcomePageKind.patient => TextAlign.justify,
        WelcomePageKind.physio => TextAlign.center,
      };

  double get _titleBottomMargin => switch (kind) {
        WelcomePageKind.patient => 70,
        WelcomePageKind.physio => 40,
      };

  String get _signInRoute => switch (kind) {
        WelcomePageKind.patient => AppRoutes.signInPatientPage,
        WelcomePageKind.physio => AppRoutes.signInPhysioPage,
      };

  String get _signUpRoute => switch (kind) {
        WelcomePageKind.patient => AppRoutes.signUpPatientPage,
        WelcomePageKind.physio => AppRoutes.signUpPhysioPage,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 236, 236),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: const ColorFilter.mode(
              Color.fromARGB(78, 255, 255, 255),
              BlendMode.colorDodge,
            ),
            filterQuality: FilterQuality.high,
            opacity: 0.9,
            image: AssetImage(_backgroundAsset),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: _titleBottomMargin),
              child: Text(
                _title,
                style: theme.textTheme.displayMedium,
                textAlign: _titleAlign,
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(primary),
                ),
                onPressed: () => Navigator.of(context).pushNamed(_signInRoute),
                icon: const Icon(Icons.mail_outline_outlined,
                    color: Colors.white, size: 24),
                label: Text(
                  'Entre com email e senha',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: theme.textTheme.titleLarge?.fontSize,
                    fontFamily: theme.textTheme.titleLarge?.fontFamily,
                    fontWeight: FontWeight.w700,
                  ),
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
                      fontFamily: theme.textTheme.labelLarge?.fontFamily,
                      color: theme.textTheme.labelLarge?.color,
                      fontSize: theme.textTheme.labelLarge?.fontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(_signUpRoute),
                    child: Text(
                      'Cadastre-se agora!',
                      style: TextStyle(
                        fontFamily: theme.textTheme.bodyLarge?.fontFamily,
                        fontSize: theme.textTheme.bodyLarge?.fontSize,
                        fontWeight: FontWeight.w700,
                        color: primary,
                        decoration: TextDecoration.underline,
                        decorationColor: primary,
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
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
