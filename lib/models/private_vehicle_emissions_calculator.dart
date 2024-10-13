import 'dart:math';
import 'package:the_carbon_conscious_traveller/models/calculation_values.dart';
import 'package:the_carbon_conscious_traveller/models/routes_model.dart';

class PrivateVehicleEmissionsCalculator {
  final RoutesModel routesModel;
  final MotorcycleSize vehicleSize;

  PrivateVehicleEmissionsCalculator({
    required this.routesModel,
    required this.vehicleSize,
  });

  double calculateEmission(int index) {
    double distanceValue = 0.0;
    for (var i = 0; i <= routesModel.distances.length; i++) {
      distanceValue = routesModel.distances[index] * vehicleSize.value;
    }
    return distanceValue;
  }

  double calculateMinEmission() {
    return routesModel.distances.reduce(min) * vehicleSize.value;
  }

  double calculateMaxEmission() {
    return routesModel.distances.reduce(max) * vehicleSize.value;
  }
}
