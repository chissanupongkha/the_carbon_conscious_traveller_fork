import 'dart:math';

import 'package:the_carbon_conscious_traveller/data/calculation_values.dart';
import 'package:the_carbon_conscious_traveller/state/polylines_state.dart';

class PrivateCarEmissionsCalculator {
  final PolylinesState polylinesState;
  final CarSize vehicleSize;
  final CarFuelType vehicleFuelType;
  double factor = 0.0;

  PrivateCarEmissionsCalculator({
    required this.polylinesState,
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
    for (var i = 0; i <= polylinesState.distances.length; i++) {
      emissionValue = polylinesState.distances[index] * factor;
    }
    return emissionValue;
  }

  double calculateMinEmission() {
    calculateFactor();
    return polylinesState.distances.reduce(min) * factor;
  }

  double calculateMaxEmission() {
    calculateFactor();
    return polylinesState.distances.reduce(max) * factor;
  }
}
