

import 'package:flutter/material.dart';

class BaseModel extends  ChangeNotifier{
  bool _buzy  = false;

  bool get buzy => _buzy;


  void setBuzy(bool buzy){
    _buzy = buzy;
    notifyListeners();
  }

}