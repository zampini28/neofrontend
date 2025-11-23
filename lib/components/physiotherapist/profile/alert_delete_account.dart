import 'package:flutter/material.dart';
import 'package:physioapp/services/auth/physio/auth_physio_service.dart';
import 'package:physioapp/services/navigation/bottom_nav_bar_controller.dart';
import 'package:physioapp/utils/app_routes.dart';
import 'package:provider/provider.dart';

class AlertDeleteAccount extends StatefulWidget {
  const AlertDeleteAccount({super.key});

  @override
  State<AlertDeleteAccount> createState() => _AlertDeleteAccountState();
}

class _AlertDeleteAccountState extends State<AlertDeleteAccount> {
  @override
  Widget build(BuildContext context) {
    final navigationPage = Provider.of<BottomNavBarPhysioController>(context);
    return AlertDialog.adaptive(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          Icon(
            Icons.warning_rounded,
            color: Theme.of(context).colorScheme.error,
          ),
          Text(
            'Excluir Conta',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ),
      content: const Text(
        'Esta é uma ação que não poderá ser desfeita, você tem certeza que deseja excluir de forma permanente sua conta?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Não'),
        ),
        TextButton(
          onPressed: () {
            final currentUser = AuthPhysioService();

            currentUser.deleteAccount(currentUser: currentUser.currentPhysioUser!);

            navigationPage.toggleIndex(index: 0);

            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.initial, (_) => false);
          },
          child: const Text('Sim'),
        ),
      ],
    );
  }
}
