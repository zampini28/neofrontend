import 'package:flutter/material.dart';
import 'package:physioapp/model/user/physio/physio_user.dart';
import 'package:physioapp/services/pair_users/patient/pair_with_physio.dart';
import 'package:provider/provider.dart';

class PairedPhysioDataPage extends StatelessWidget {
  const PairedPhysioDataPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pairPhysioProvider = Provider.of<PairWithPhysio>(context);
    final userPhysioData =
        ModalRoute.of(context)!.settings.arguments! as PhysioUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados do Fisioterapeuta'),
      ),
      body: Container(
        height: 300,
        width: 400,
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 223, 224, 234),
              Color.fromARGB(255, 233, 235, 240),
            ],
          ),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundColor: Colors.grey,
              maxRadius: 70,
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              userPhysioData.userName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              userPhysioData.emailSemiAnonimized,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 60,
        child: ElevatedButton.icon(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            backgroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.error,
            ),
          ),
          onPressed: () {
            pairPhysioProvider.removePairPhysio(
              user: userPhysioData,
            );

            Navigator.of(context).pop();
          },
          label: const Text(
            'Remover Fisioterapeuta',
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(
            Icons.person_remove_alt_1_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
