import 'package:flutter/material.dart';
import 'package:physioapp/model/user/physio/physio_user.dart';

class PairedUsersData with ChangeNotifier {
  final List<PhysioUser> _listPhysioPair = [];

  set setListPhysioPair(PhysioUser userPhysio) {
    _listPhysioPair.add(userPhysio);
    notifyListeners();
  }

  List<PhysioUser> get listPhysioPair => [..._listPhysioPair];

  static List<Map<String, Object>> pairedUsers = [];
}
