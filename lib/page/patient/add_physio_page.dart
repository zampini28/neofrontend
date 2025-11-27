import 'package:flutter/material.dart';
import 'package:physioapp/components/patient/add_physio/list_physio_item.dart';
import 'package:physioapp/services/pair_users/patient/pair_with_physio.dart';
import 'package:provider/provider.dart';
import 'package:physioapp/page/qrscanner_page.dart';
import 'package:physioapp/repositories/relationship_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddPhysioPage extends StatefulWidget {
  const AddPhysioPage({super.key});

  @override
  State<AddPhysioPage> createState() => _AddPhysioPageState();
}

class _AddPhysioPageState extends State<AddPhysioPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RelationshipProvider>(context, listen: false).loadMyQrCode();
    });
  }

  void _openScanner() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const QrScannerPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final relationshipProvider = Provider.of<RelationshipProvider>(context);
    final qrData = relationshipProvider.myQrCodeLink;
    final isLoading = relationshipProvider.isLoading;
    final hasError = relationshipProvider.error != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Fisioterapeuta'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                'Seu QR Code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Peça para seu fisioterapeuta escanear este código para conectar-se a você.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    if (isLoading && qrData == null)
                      const SizedBox(
                        height: 260,
                        width: 260,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (hasError)
                      SizedBox(
                        height: 260,
                        width: 260,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 40),
                            const SizedBox(height: 10),
                            Text('Erro ao carregar.\n${relationshipProvider.error}',
                                textAlign: TextAlign.center),
                            TextButton(
                              onPressed: () => relationshipProvider.loadMyQrCode(),
                              child: const Text('Tentar Novamente'),
                            )
                          ],
                        ),
                      )
                    else
                      QrImageView(
                        data: qrData ?? 'error',
                        version: QrVersions.auto,
                        size: 260,
                        backgroundColor: Colors.white,
                        eyeStyle: QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Theme.of(context).primaryColor,
                        ),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Colors.grey[800],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _openScanner,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                  label: const Text(
                    'Escanear QR de Paciente',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}







class _AddPhysioPage extends StatelessWidget {
  const _AddPhysioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pairPhysioProvider = Provider.of<PairWithPhysio>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Fisioterapeuta'),
        actions: [
          IconButton(
            onPressed: () => pairPhysioProvider.readQRcode(),
            icon: const Icon(
              Icons.add_rounded,
              size: 26,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (pairPhysioProvider.listPhysioPair.isNotEmpty)
              Container(
                height: 20,
                padding: const EdgeInsets.all(10),
                child: const Text('Fisioterapeutas Adicionados'),
              ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: pairPhysioProvider.listPhysioPair.length,
              itemBuilder: (context, index) => ListPhysioItem(
                user: pairPhysioProvider.listPhysioPair.elementAt(index),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        maxRadius: 30,
        child: IconButton(
          onPressed: () => pairPhysioProvider.readQRcode(),
          icon: const Icon(
            Icons.qr_code_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
