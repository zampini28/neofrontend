import 'package:flutter/material.dart';

enum SignUpForm {
  firstForm,
  secondForm,
}

class SignUpPageForm with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void toggleLoadingValue() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  SignUpForm currentPageForm = SignUpForm.firstForm;

  SignUpForm get firstForm => SignUpForm.firstForm;
  SignUpForm get secondForm => SignUpForm.secondForm;

  bool get firstPageForm => currentPageForm == SignUpForm.firstForm;
  bool get secondPageForm => currentPageForm == SignUpForm.secondForm;

  void toggleForm({required SignUpForm value}) {
    currentPageForm = value;
    notifyListeners();
  }
}
