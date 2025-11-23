import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/utils/get_image.dart';

class PhotoProfilePhysio extends StatefulWidget {
  const PhotoProfilePhysio({super.key});

  @override
  PhotoProfilePhysioState createState() => PhotoProfilePhysioState();
}

class PhotoProfilePhysioState extends State<PhotoProfilePhysio> {
  @override
  Widget build(BuildContext context) {
    final currentUser = UserDataCache();
    return SizedBox(
      height: 110,
      width: 110,
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: currentUser.imageProfile,
            maxRadius: 50,
          ),
          Positioned(
            bottom: 3,
            right: 7,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(1, 1),
                    blurRadius: 4,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () async {
                  debugPrint('--- updating profile image');
                  await updateImage(context);
                  setState(() => {});
                  debugPrint('--- DONE WITH: updating profile image');
                },
                icon: Icon(
                  Icons.camera_alt_rounded,
                  color: Theme.of(context).textTheme.labelSmall?.color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
