import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physioapp/main.dart';
import 'package:physioapp/page/physio_or_patient_page.dart';

void main() {
  const Size telaDeTeste = Size(400, 900);

  testWidgets('Teste estático da PhysioOrPatientPage', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(telaDeTeste);

    await tester.pumpWidget(
      const MaterialApp(
        home: PhysioOrPatientPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bem Vindo!'), findsOneWidget);
    expect(find.text('Paciente'), findsOneWidget);
    expect(find.text('Próximo'), findsOneWidget);
    expect(find.text('Fisioterapeuta'), findsNothing);
  });

  testWidgets('Deve trocar de Paciente para Fisioterapeuta ao tocar no seletor',
      (WidgetTester tester) async {
        
    await tester.binding.setSurfaceSize(telaDeTeste);

    await tester.pumpWidget(
      const MaterialApp(
        home: PhysioOrPatientPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Paciente'), findsOneWidget);
    expect(find.text('Fisioterapeuta'), findsNothing);

    await tester.tap(find.text('Paciente'));
    await tester.pumpAndSettle();

    expect(find.text('Paciente'), findsNothing);
    expect(find.text('Fisioterapeuta'), findsOneWidget);
  });

  testWidgets(
    'Fluxo Fisioterapeuta: Deve navegar da Auth -> Signup -> Signin',
    (WidgetTester tester) async {
      
      void verificarTelaAuth() {
        expect(find.text('Junte-se a nós \n& atenda com Confiança'), findsOneWidget);
        expect(find.text('Entre com email e senha'), findsOneWidget);
        expect(find.byIcon(Icons.mail_outline_outlined), findsOneWidget);
        expect(find.text('Não possui conta? '), findsOneWidget);
        expect(find.text('Cadastre-se agora!'), findsOneWidget);
      }

      void verificarTelaSignup() {
        final expectedTexts = [
          'Cadastre-se',
          'Fisioterapia',
          'Terapia\nOcupacional',
          'Próximo',
          'Número Crefito',
          'Já possui conta? ',
          'Entre agora!',
        ];
        for (final text in expectedTexts) {
          expect(find.text(text), findsOneWidget, reason: 'Não encontrou "$text"');
        }
        expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);
      }

      void verificarTelaSignin() {
        expect(find.text('Entrar'), findsNWidgets(2), reason: 'Não encontrou 2 "Entrar"');
        
        final expectedTexts = [
          'Email',
          'Senha',
          'Esqueci minha senha',
          'Não possui conta? ',
          'Cadastre-se agora!',
        ];
        for (final text in expectedTexts) {
          expect(find.text(text), findsOneWidget, reason: 'Não encontrou "$text"');
        }
      }

      await tester.binding.setSurfaceSize(const Size(800, 900));
      await tester.pumpWidget(const PhysioApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Paciente'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Próximo'));
      await tester.pumpAndSettle();
      expect(find.text('Bem Vindo!'), findsNothing);

      verificarTelaAuth();
      await tester.tap(find.text('Cadastre-se agora!'));
      await tester.pumpAndSettle();

      verificarTelaSignup();
      await tester.tap(find.text('Entre agora!'));
      await tester.pumpAndSettle();

      verificarTelaSignin();
    },
  );
}
