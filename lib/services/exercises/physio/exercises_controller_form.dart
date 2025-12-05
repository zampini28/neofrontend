import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ExercisesControllerForm with ChangeNotifier {
  List<StepModel> steps = [StepModel()];
  StepModel mainExercise = StepModel();
  XFile? videoFile;

  double? duration;

  bool get isAllStepsFilled =>
      mainExercise.isFilled && steps.every((step) => step.isFilled);
  int get quantitySteps => steps.length;
  bool get videoSelected => videoFile != null;

  bool isNextButtonEnable = false;
  bool get getEnableNextButton => isNextButtonEnable;
  bool isSecondForm = false;
  bool get secondForm => isSecondForm;

  void toggleSecondForm() {
    isSecondForm = !isSecondForm;
    notifyListeners();
  }

  void updateSecondForm() {
    isSecondForm = !isSecondForm;
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

  void updateVideoFile(XFile video) {
    videoFile = video;
    notifyListeners();
  }

  void updateMainExercise({String? title, String? description}) {
    if (title != null) mainExercise.title = title;
    if (description != null) mainExercise.description = description;
    notifyListeners();
  }

  void updateDuration(double value) {
    duration = value;
    notifyListeners();
  }

  void updateStep(int index, {String? title, String? description}) {
    if (title != null) steps[index].title = title;
    if (description != null) steps[index].description = description;
    notifyListeners();
  }

  void addStep({String? titleStep, String? descriptionStep}) {
    if (titleStep != null && descriptionStep != null) {
      steps.add(StepModel(title: titleStep, description: descriptionStep));
    } else {
      steps.add(StepModel());
    }
    notifyListeners();
  }

  void addLenghtListStep() {
    steps.add(StepModel());
    notifyListeners();
  }

  bool get firstForm => !isSecondForm;
  bool get getNextForm => isNextButtonEnable;
  String? get titleExercise => mainExercise.title;
  String? get descriptionExercise => mainExercise.description;
  List<Map<String, String>> get stepsExercise =>
      steps.map((s) => {s.title: s.description}).toList();
  double? get durationVideo => duration;

  set titleExercise(String? val) {
    if (val != null) mainExercise.title = val;
    notifyListeners();
  }

  set descriptionExercise(String? val) {
    if (val != null) mainExercise.description = val;
    notifyListeners();
  }

  set durationVideo(double? val) {
    duration = val;
    notifyListeners();
  }

  set titleStep(String? val) {
    if (steps.isNotEmpty && val != null) steps.last.title = val;
    notifyListeners();
  }

  set descriptionStep(String? val) {
    if (steps.isNotEmpty && val != null) steps.last.description = val;
    notifyListeners();
  }

  void toggleForm({dynamic valueForm}) {
    isSecondForm = !isSecondForm;
    notifyListeners();
  }

  void advanceForm() {
    isNextButtonEnable = true;
    notifyListeners();
  }

  void resetSteps() {
    steps = [StepModel()];
    mainExercise = StepModel();
    videoFile = null;
    duration = null;
    isSecondForm = false;
    isNextButtonEnable = false;
    notifyListeners();
  }

  void removeStep(int index) {
    if (steps.length > 1) {
      steps.removeAt(index);
      notifyListeners();
    }
  }
}

class StepModel {
  String title;
  String description;

  StepModel({this.title = '', this.description = ''});

  bool get isFilled => title.trim().isNotEmpty && description.trim().isNotEmpty;

  Map<String, String> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }
}
