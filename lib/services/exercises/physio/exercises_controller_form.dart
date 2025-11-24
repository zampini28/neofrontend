import 'package:flutter/material.dart';

class ExercisesControllerForm with ChangeNotifier {
  List<StepModel> steps = [StepModel()];

  bool get isAllStepsFilled => mainExercise.isFilled && steps.every((step) => step.isFilled);

  StepModel mainExercise = StepModel();

  int get quantitySteps => steps.length;

  bool isNextButtonEnable = false;

  bool get getEnableNextButton => isNextButtonEnable;

  void updateMainExercise({String? title, String? description}) {
    if (title != null) mainExercise.title = title;
    if (description != null) mainExercise.description = description;
    notifyListeners();
  }

  void enableNextButton() {
    isNextButtonEnable = true;
    notifyListeners();
  }

  void disableNextButton() {
    isNextButtonEnable = false;
    notifyListeners();
  }

  void updateStep(int index, {String? title, String? description}) {
    if (title != null) steps[index].title = title;
    if (description != null) steps[index].description = description;
    notifyListeners();
  }

  void addStep() {
    steps.add(StepModel());
    notifyListeners();
  }

  void resetSteps() {
    steps = [StepModel()];
    notifyListeners();
  }

  // OLD
  FormExercise get getSecondForm => FormExercise.secondForm;
  FormExercise get currentForm => _currentForm;
  FormExercise _currentForm = FormExercise.firstForm;
  double? durationVideo;
  void toggleForm({required FormExercise valueForm}) {
    _currentForm = valueForm;
    notifyListeners();
  }

  FormExercise get getFirstForm => FormExercise.firstForm;
  bool _selectedVideo = false;
  bool get videoSelected => _selectedVideo;
  void toggleValueVideo() {
    _selectedVideo = true;
    notifyListeners();
  }
}

class StepModel {
  String title;
  String description;

  StepModel({this.title = '', this.description = ''});

  bool get isFilled => title.trim().isNotEmpty && description.trim().isNotEmpty;
}

// OLD
enum FormExercise {
  firstForm,
  secondForm,
}
