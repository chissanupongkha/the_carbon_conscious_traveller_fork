import 'dart:math';

import 'package:the_carbon_conscious_traveller/models/calculation_values.dart';
import 'package:the_carbon_conscious_traveller/models/routes_model.dart';

class PrivateCarEmissionsCalculator {
  final RoutesModel routesModel;
  final CarSize vehicleSize;
  final CarFuelType vehicleFuelType;

  int carSizeCount = CarSize.values.length;
  int carFuelTypeCount = CarFuelType.values.length;
  double factor = 0.0;

  PrivateCarEmissionsCalculator({
    required this.routesModel,
    required this.vehicleSize,
    required this.vehicleFuelType,
  });

  void calculateFactor() {
    factor = carValuesMatrix[vehicleSize.index][vehicleFuelType.index];
  }

  double calculateEmission(int index, CarSize size, CarFuelType fuelType) {
    double emissionValue = 0.0;
    calculateFactor();
    for (var i = 0; i <= routesModel.distances.length; i++) {
      emissionValue = routesModel.distances[index] * factor;
    }
    return emissionValue;
  }

  double calculateMinEmission() {
    calculateFactor();
    return routesModel.distances.reduce(min) * factor;
  }

  double calculateMaxEmission() {
    calculateFactor();
    return routesModel.distances.reduce(max) * factor;
  }
}
