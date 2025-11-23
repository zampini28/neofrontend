import 'package:flutter/material.dart';

class PatientProfileService with ChangeNotifier{
  bool _isVisible = true;

  bool get isVisible => _isVisible;

  void toggleVisibilty() {
    _isVisible = !_isVisible;
    notifyListeners();
  }
}