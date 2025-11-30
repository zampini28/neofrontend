import 'package:flutter/material.dart';
import 'package:physioapp/page/page.dart';

class AppRoutes {
  AppRoutes._();

  static const String initial = '/';

  static const String welcomePhysioPage = '/wecolme-physio-page';
  static const String welcomePatientPage = '/wecolme-patient-page';

  static const String signInPhysioPage = '/signin-physio-page';
  static const String signUpPhysioPage = '/signup-physio-page';
  static const String signInPatientPage = '/signin-patient-page';
  static const String signUpPatientPage = '/signup-patient-page';
  static const String messagePage = '/message-page';
  static const String exercisesListPage = '/exercises-list-page';
  static const String exercisesDetailPage = '/exercises-detail-page';
  static const String addExercisePage = '/add-exercise-page';
  static const String tabPagePatient = '/tab-page-patient';
  static const String tabPagePhysio = '/tab-page-physio';
  static const String addPatientPage = '/add-patient-page';
  static const String addPhysioPage = '/add-physio-page';
  static const String exercisesPagePhysio = '/exercises-page-physio';
  static const String policyPrivacyPage = '/policy-privacy-page';
  static const String policyPrivacyPatientPage = '/policy-privacy-patient-page';
  static const String pairedPhysioDataPage = 'paired-physio-data-page';

  static Map<String, WidgetBuilder> get map => {
    initial: (_) => const InitialPage(),

    welcomePhysioPage: (_) => const WelcomePage(kind: WelcomePageKind.physio),
    welcomePatientPage: (_) => const WelcomePage(kind: WelcomePageKind.patient),

    signInPhysioPage: (_) => const SigninPhysioPage(),
    signUpPhysioPage: (_) => const SignupPhysioPage(),
    signInPatientPage: (_) => const SigninPatientPage(),
    signUpPatientPage: (_) => const SignupPatientPage(),
    messagePage: (_) => const MessagePage(),
    exercisesListPage: (_) => const ExercisesListPage(),
    exercisesDetailPage: (_) => const ExercisesDetailPage(),
    addExercisePage: (_) => const AddExercisePage(),
    tabPagePatient: (_) => const TabsPagePatient(),
    addPatientPage: (_) => const AddPatientPage(),
    addPhysioPage: (_) => const AddPhysioPage(),
    tabPagePhysio: (_) => const TabsPagePhysio(),
    exercisesPagePhysio: (_) => const ExercisesPagePhysio(),
    policyPrivacyPage: (_) => const PolicyPrivacyPage(),
    policyPrivacyPatientPage: (_) => const PolicyPrivacyPatientPage(),
    pairedPhysioDataPage: (_) => const PairedPhysioDataPage(),
  };
}

