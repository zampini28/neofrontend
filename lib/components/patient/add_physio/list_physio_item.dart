import 'package:flutter/material.dart';
import 'package:physioapp/model/user/physio/physio_user.dart';
import 'package:physioapp/utils/app_routes.dart';

class ListPhysioItem extends StatelessWidget {
  final PhysioUser user;
  const ListPhysioItem({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.grey,
            maxRadius: 30,
          ),
          title: Text(
            user.userName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            user.emailSemiAnonimized,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.pairedPhysioDataPage, arguments: user),
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Theme.of(context).textTheme.labelLarge?.color,
            ),
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.5,
          indent: 90,
        ),
      ],
    );
  }
}
