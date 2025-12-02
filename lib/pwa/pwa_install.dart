import 'package:flutter/material.dart';

class InstallPwa extends StatelessWidget {
  const InstallPwa({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const InstallPwaScreen(),
    );
  }
}

class InstallPwaScreen extends StatelessWidget {
  const InstallPwaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24.0),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logotipo.png',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Instale Nosso App',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Para a melhor experiência, adicione este aplicativo à sua tela inicial.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Instruções:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                _buildInstructionStep(
                  '1. Toque no ícone “Compartilhar”',
                  'No iOS, ele está na parte inferior. No Android, encontre‑o no menu do navegador.',
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? Icons.ios_share
                      : Icons.more_vert,
                ),
                const SizedBox(height: 16),
                _buildInstructionStep(
                  '2. Selecione “Adicionar à Tela Inicial”',
                  'Pode ser necessário rolar a tela para encontrá‑lo.',
                  Icons.add_to_home_screen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionStep(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue, size: 32),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }
}
