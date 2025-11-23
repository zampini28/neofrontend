import 'package:flutter/material.dart';
import 'package:physioapp/services/profile/physio/physio_profile_service.dart';
import 'package:provider/provider.dart';

class DataVisualizationPhysio extends StatefulWidget {
  const DataVisualizationPhysio({super.key});

  @override
  State<DataVisualizationPhysio> createState() => _DataVisualizationState();
}

class _DataVisualizationState extends State<DataVisualizationPhysio> {
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<PhysioProfileService>(context);
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
