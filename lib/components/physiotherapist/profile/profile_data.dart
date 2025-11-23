import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/profile/change_email_form.dart';
import 'package:physioapp/components/physiotherapist/profile/change_name_form.dart';
import 'package:physioapp/components/physiotherapist/profile/profile_option_tile.dart';
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/services/profile/physio/physio_profile_service.dart';
import 'package:provider/provider.dart';

class ProfileData extends StatelessWidget {
  final void Function() refreshPage;
  const ProfileData({super.key, required this.refreshPage});
  Widget _listTileData({
    required IconData icon,
    required String title,
    required String subtitle,
    required BuildContext context,
    required void Function(BuildContext) fn,
  }) {
    return ListTileComponent(
      title: title,
      subtitle: subtitle,
      icon: icon,
      fn: fn,
    );
  }

  void _showChangNameForm({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ChangeNameForm(
          refreshPage: refreshPage,
        );
      },
    );
  }

  void _showChangEmailForm({
    required BuildContext context,
  }) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ChangeEmailForm(
            refreshPage: refreshPage,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = UserDataCache();
    final profileProvider = Provider.of<PhysioProfileService>(context);

    return Column(
      children: [
        _listTileData(
          context: context,
          icon: Icons.person,
          title: 'Nome',
          fn: (context) => _showChangNameForm(context: context),
          subtitle:
              profileProvider.isVisible ? currentUser.name : obscureText(currentUser.name),
        ),
        _listTileData(
          context: context,
          icon: Icons.mail,
          title: 'Email',
          fn: (context) => _showChangEmailForm(context: context),
          subtitle: profileProvider.isVisible
              ? currentUser.email
              : obscureText(currentUser.email),
        ),
      ],
    );
  }
}
