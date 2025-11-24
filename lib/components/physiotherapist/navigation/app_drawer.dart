import 'package:flutter/material.dart';
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/services/navigation/bottom_nav_bar_controller.dart';
import 'package:physioapp/utils/app_routes.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = UserDataCache();
    final currentPage = Provider.of<BottomNavBarPhysioController>(context);

    Widget userComponentDrawer(
        {required String name, required String email, required ImageProvider imageProfile}) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: imageProfile,
            maxRadius: 30,
          ),
          title: Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            email,
            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 14),
          ),
        ),
      );
    }

    Widget componentDrawer(
        {required IconData icon, required String title, required Function() function}) {
      return ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () {
          Navigator.of(context).pop();
          function();
        },
      );
    }

    return Container(
      child: Drawer(
        child: Column(
          children: [
            const SizedBox(
              height: 45,
            ),
            userComponentDrawer(
              name: currentUser.userName,
              email: currentUser.email,
              imageProfile: currentUser.imageProfile,
            ),
            Divider(
              color: Colors.grey[300],
            ),
            componentDrawer(
              icon: Icons.account_circle_rounded,
              title: 'Minha Conta',
              function: () => currentPage.toggleIndex(index: 3),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            componentDrawer(
              icon: Icons.person_add_alt_1_rounded,
              title: 'Adicionar Paciente',
              function: () => Navigator.of(context).pushNamed(AppRoutes.addPatientPage),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            componentDrawer(
                icon: Icons.logout_rounded,
                title: 'Sair',
                function: () async {
                  await logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.initial,
                    (_) => false,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
