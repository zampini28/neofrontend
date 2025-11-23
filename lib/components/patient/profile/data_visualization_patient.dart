import 'package:flutter/material.dart';
import 'package:physioapp/services/profile/patient/patient_profile_service.dart';
import 'package:provider/provider.dart';

class DataVisualizationPatient extends StatefulWidget {
  const DataVisualizationPatient({super.key});

  @override
  State<DataVisualizationPatient> createState() => _DataVisualizationPatientState();
}

class _DataVisualizationPatientState extends State<DataVisualizationPatient> {
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<PatientProfileService>(context);
    return IconButton(
      onPressed: () => profileProvider.toggleVisibilty(),
      icon: Icon(
        profileProvider.isVisible
            ? Icons.visibility_sharp
            : Icons.visibility_off_sharp,
        color: Theme.of(context).textTheme.labelSmall?.color,
      ),
    );
  }
}
