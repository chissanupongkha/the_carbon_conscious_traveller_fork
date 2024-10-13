import 'package:flutter/material.dart';
import 'package:the_carbon_conscious_traveller/models/calculation_values.dart';

class PrivateCarState extends ChangeNotifier {
  CarSize? _selectedSize;
  CarFuelType? _selectedFuelType;
  bool? _isVisible;
  int? _minEmission;
  int? _maxEmission;
  List<int> _emissions = [];

  CarSize? get selectedSize => _selectedSize;
  CarFuelType? get selectedFuelType => _selectedFuelType;
  bool get isVisible => _isVisible ?? false;
  int get minEmissionValue => _minEmission ?? 0;
  int get maxEmissionValue => _maxEmission ?? 0;
  List<int> get emissions => _emissions;

  void updateSelectedSize(CarSize newValue) {
    print("updateSelectedValue: $newValue");
    _selectedSize = newValue;
    notifyListeners();
  }

  void updateSelectedFuelType(CarFuelType newValue) {
    print("updateSelectedValue: $newValue");
    _selectedFuelType = newValue;
    notifyListeners();
  }

  void updateVisibility(bool isVisible) {
    _isVisible = isVisible;
    notifyListeners();
  }

  void updateMinEmission(int minEmission) {
    _minEmission = minEmission;
    notifyListeners();
  }

  void updateMaxEmission(int maxEmission) {
    _maxEmission = maxEmission;
    notifyListeners();
  }

  void saveEmissions(List<int> emissions) {
    _emissions = emissions;
    notifyListeners();
  }

  int getEmission(int index) {
    if (index >= 0 && index < _emissions.length) {
      return _emissions[index];
    }
    return 0;
  }
}
