import 'dart:math';

import 'package:the_carbon_conscious_traveller/models/calculation_values.dart';
import 'package:the_carbon_conscious_traveller/models/routes_model.dart';

class PrivateCarEmissionsCalculator {
  final RoutesModel routesModel;
  final CarSize vehicleSize;
  final CarFuelType vehicleFuelType;
  double factor = 0.0;

  PrivateCarEmissionsCalculator({
    required this.routesModel,
    required this.vehicleSize,
    required this.vehicleFuelType,
  });

  void calculateFactor() {
    print("Car Size: ${vehicleSize.index} ${vehicleFuelType.index}");
    if (vehicleSize == CarSize.label || vehicleFuelType == CarFuelType.label) {
      return; // Skip operation for enum 'label'
    } else {
      factor = carValuesMatrix[vehicleSize.index][vehicleFuelType.index];
    }
  }

  double calculateEmissions(int index, CarSize size, CarFuelType fuelType) {
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
