import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ExercisesControllerForm with ChangeNotifier {
  List<StepModel> steps = [StepModel()];

  bool get isAllStepsFilled => mainExercise.isFilled && steps.every((step) => step.isFilled);

  StepModel mainExercise = StepModel();

  int get quantitySteps => steps.length;

  bool isNextButtonEnable = false;

  bool get getEnableNextButton => isNextButtonEnable;

  XFile? videoFile;

  double? duration;

  bool get videoSelected => videoFile != null;

  bool isSecondForm = false;

  bool get secondForm => isSecondForm;

  void updateDuration(double value) {
    duration = value;
    notifyListeners();
  }

  void toggleSecondForm() {
    isSecondForm = !isSecondForm;
    notifyListeners();
  }

  void updateVideoFile(XFile video) {
    videoFile = video;
    notifyListeners();
  }

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
  void resetSteps() {
    steps = [StepModel()];
    mainExercise = StepModel();
    notifyListeners();
  }

  void updateSecondForm() {
    isSecondForm = !isSecondForm;
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
}

class StepModel {
  String title;
  String description;

  StepModel({this.title = '', this.description = ''});

  bool get isFilled => title.trim().isNotEmpty && description.trim().isNotEmpty;
}

