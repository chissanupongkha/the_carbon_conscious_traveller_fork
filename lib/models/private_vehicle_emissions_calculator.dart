import 'dart:math';
import 'package:the_carbon_conscious_traveller/models/calculation_values.dart';
import 'package:the_carbon_conscious_traveller/models/polylines_state.dart';

class PrivateVehicleEmissionsCalculator {
  final PolylinesState polylinesState;
  final MotorcycleSize vehicleSize;

  PrivateVehicleEmissionsCalculator({
    required this.polylinesState,
    required this.vehicleSize,
  });

  double calculateEmission(int index) {
    double distanceValue = 0.0;
    for (var i = 0; i <= polylinesState.distances.length; i++) {
      distanceValue = polylinesState.distances[index] * vehicleSize.value;
    }
    return distanceValue;
  }

  double calculateMinEmission() {
    return polylinesState.distances.reduce(min) * vehicleSize.value;
  }

  double calculateMaxEmission() {
    return polylinesState.distances.reduce(max) * vehicleSize.value;
  }
}
