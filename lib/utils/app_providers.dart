import 'package:physioapp/repositories/relationship_repository.dart';
import 'package:physioapp/services/services.dart';
import 'package:physioapp/utils/signup_page_form.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  
  AppProviders._();

  static List<SingleChildWidget> get global => [
    ChangeNotifierProvider(create: (_) => RelationshipProvider()),
    ChangeNotifierProvider(create: (_) => SignUpPageForm()),
    ChangeNotifierProvider(create: (_) => AuthFormData()),
    ChangeNotifierProvider(create: (_) => ExercisesControllerComponent()),
    ChangeNotifierProvider(create: (_) => BottomNavBarPhysioController()),
    ChangeNotifierProvider(create: (_) => BottomNavBarPatientController()),
    ChangeNotifierProvider(create: (_) => ScheduleAppointmentForm()),
    ChangeNotifierProvider(create: (_) => ExerciseController()),
    ChangeNotifierProvider(create: (_) => ExercisesControllerForm()),
    ChangeNotifierProvider(create: (_) => ScheduleAppointmentController()),
    ChangeNotifierProvider(create: (_) => PhysioProfileService()),
    ChangeNotifierProvider(create: (_) => PatientProfileService()),
    ChangeNotifierProvider(create: (_) => PairWithPhysio()),
    ChangeNotifierProvider(create: (_) => PairWithPatient()),
  ];
}
