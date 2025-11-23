import 'package:flutter/material.dart';
import 'package:physioapp/services/auth/physio/auth_physio_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddPatientPage extends StatelessWidget {
  const AddPatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthPhysioService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Paciente'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Adicione Pacientes',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                fontFamily:
                    Theme.of(context).textTheme.displayLarge?.fontFamily,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Compartilhe o QR-Code com seus pacientes\ne comece a automatizar seu atendimento!',
              style: TextStyle(
                fontFamily:
                    Theme.of(context).textTheme.displayLarge?.fontFamily,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.only(right: 20, left: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 223, 224, 234),
                      Color.fromARGB(255, 233, 235, 240),
                    ],
                  ),
                ),
                child: QrImageView(
                  data: currentUser
                      .currentPhysioUser!.id, // O correto é utilizar um token
                  version: QrVersions.auto,
                  size: 280,
                  errorStateBuilder: (context, error) =>
                      Text('Erro na geração de QR-Code: $error'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
