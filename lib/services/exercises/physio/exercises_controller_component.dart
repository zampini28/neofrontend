import 'package:flutter/material.dart';

class ExercisesControllerComponent with ChangeNotifier {
  final List<Widget> _listComponent = [];
  List<Widget> get listComponent => [..._listComponent];

  int get listLength => _listComponent.length;

  void addComponent({required Widget component}) {
    _listComponent.add(component);
    notifyListeners();
  }
}