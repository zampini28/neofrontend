import 'package:flutter/material.dart';
import 'package:physioapp/components/patient/profile/alert_delete_account.dart';
import 'package:physioapp/components/patient/profile/change_password_form.dart';
import 'package:physioapp/utils/app_routes.dart';

class OtherOptionsPatient extends StatefulWidget {
  const OtherOptionsPatient({super.key});

  @override
  State<OtherOptionsPatient> createState() => _OtherOptionsPatientState();
}

class _OtherOptionsPatientState extends State<OtherOptionsPatient> {
  void _showChagePassword(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const ChangePasswordForm();
      },
    );
  }

  Future<void> _showDeleteAccount() async {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDeleteAccount();
      },
    );
  }

  Widget _componentListTile({
    required IconData icon,
    required String text,
    required Function() function,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? Theme.of(context).textTheme.labelLarge?.color,
      ),
      title: Text(
        text,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: color ?? Theme.of(context).textTheme.labelLarge?.color),
      ),
      trailing: IconButton(
        onPressed: () => function(),
        icon: Icon(
          Icons.arrow_forward_ios_rounded,
          color: color ?? Theme.of(context).textTheme.labelLarge?.color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _componentListTile(
          icon: Icons.privacy_tip_rounded,
          text: 'Política de Privacidade',
          function: () => Navigator.of(context)
              .pushNamed(AppRoutes.policyPrivacyPatientPage),
        ),
        _componentListTile(
          icon: Icons.lock,
          text: 'Mudar Senha',
          function: () => _showChagePassword(context),
        ),
        _componentListTile(
          icon: Icons.delete,
          text: 'Excluir Conta',
          function: () => _showDeleteAccount(),
          color: const Color.fromARGB(255, 255, 0, 16),
        ),
      ],
    );
  }
}
