import 'package:flutter/material.dart';
import 'package:physioapp/services/auth/patient/auth_patient_service.dart';
import 'package:physioapp/utils/get_image.dart';

class PhotoProfilePatient extends StatefulWidget {
  const PhotoProfilePatient({super.key});

  @override
  PhotoProfilePatientState createState() => PhotoProfilePatientState();
}

class PhotoProfilePatientState extends State<PhotoProfilePatient> {
  @override
  Widget build(BuildContext context) {
    final currentUser = AuthPatientService();
    return SizedBox(
      height: 110,
      width: 110,
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage:
                FileImage(currentUser.currentPatientUser!.imageProfile),
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
                onPressed: () => getImage(context),
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
