import 'package:flutter/material.dart';

class BottomNavBarPhysioController with ChangeNotifier{
  int _index = 0;

  int get index => _index;

  void toggleIndex({required int index}) {
    _index = index;
    notifyListeners();
  }
}
