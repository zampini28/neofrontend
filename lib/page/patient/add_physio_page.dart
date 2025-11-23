import 'package:flutter/material.dart';
import 'package:physioapp/components/patient/add_physio/list_physio_item.dart';
import 'package:physioapp/services/pair_users/patient/pair_with_physio.dart';
import 'package:provider/provider.dart';

class AddPhysioPage extends StatelessWidget {
  const AddPhysioPage({super.key});

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
