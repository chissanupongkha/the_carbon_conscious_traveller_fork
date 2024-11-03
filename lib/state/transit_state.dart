import 'package:flutter/material.dart';

class TransitState extends ChangeNotifier {
  List<double> _transitEmissions = [];
  int _minEmissions = 0;
  int _maxEmissions = 0;

  List<double> get transitEmissions => _transitEmissions;
  int get minEmissionValue => _minEmissions;
  int get maxEmissionValue => _maxEmissions;

  void saveTransitEmissions(List<double> emissions) {
    _transitEmissions = emissions;
    notifyListeners();
  }

  void updateMinEmissions(int minEmissions) {
    _minEmissions = minEmissions;
    // notifyListeners();
  }

  void updateMaxEmissions(int maxEmissions) {
    _maxEmissions = maxEmissions;
    //notifyListeners();
  }
}
