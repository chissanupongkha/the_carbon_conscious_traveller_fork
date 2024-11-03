import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_carbon_conscious_traveller/state/coordinates_state.dart';
import 'package:the_carbon_conscious_traveller/state/polylines_state.dart';
import 'package:the_carbon_conscious_traveller/state/private_car_state.dart';
import 'package:the_carbon_conscious_traveller/state/private_motorcycle_state.dart';
import 'package:the_carbon_conscious_traveller/state/transit_state.dart';
import 'package:the_carbon_conscious_traveller/widgets/vehicle_settings_bottom_sheet.dart';

class TravelModeButtons extends StatefulWidget {
  const TravelModeButtons({super.key});

  @override
  State<TravelModeButtons> createState() => _TravelModeButtonsState();
}

String getCurrentMinMaxEmissions(
  String mode,
  PrivateMotorcycleState motorcycleState,
  PrivateCarState carState,
  TransitState transitState,
) {
  String currentMaxEmissions = '';
  String currentMinEmissions = '';

  String formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)} kg';
    } else {
      return '${number.round()} g';
    }
  }

  if (mode == 'motorcycling') {
    currentMaxEmissions = formatNumber(motorcycleState.maxEmissionValue);
    currentMinEmissions = formatNumber(motorcycleState.minEmissionValue);
  } else if (mode == 'driving') {
    currentMaxEmissions = formatNumber(carState.maxEmissionValue);
    currentMinEmissions = formatNumber(carState.minEmissionValue);
  } else if (mode == 'transit') {
    currentMaxEmissions = formatNumber(transitState.maxEmissionValue);
    currentMinEmissions = formatNumber(transitState.minEmissionValue);
  }

  return '$currentMinEmissions - $currentMaxEmissions';
}

class _TravelModeButtonsState extends State<TravelModeButtons> {
  final List<bool> _selectedModes = <bool>[true, false, false, false];

  final List<({IconData icon, String mode})> transportModes = [
    (icon: Icons.directions_car_outlined, mode: 'driving'),
    (icon: Icons.sports_motorsports_outlined, mode: 'motorcycling'),
    (icon: Icons.train_outlined, mode: 'transit'),
    (icon: Icons.airplanemode_active_outlined, mode: 'flying'),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer5(builder: (BuildContext context,
        CoordinatesState coordinatesState,
        PrivateMotorcycleState motorcycleState,
        PrivateCarState carState,
        TransitState transitState,
        PolylinesState polylineState,
        child) {
      String currentMinMaxEmissions = getCurrentMinMaxEmissions(
        polylineState.mode,
        motorcycleState,
        carState,
        transitState,
      );

      return Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(
          children: [
            ToggleButtons(
              onPressed: (int index) {
                setState(() {
                  // The button that is tapped is set to true, and the others to false
                  for (int i = 0; i < _selectedModes.length; i++) {
                    _selectedModes[i] = i == index;
                  }
                });

                polylineState.transportMode = transportModes[index].mode;

                if (coordinatesState.coordinates.isEmpty) {
                  return;
                }
                polylineState.getPolyline(coordinatesState
                    .coordinates); // only call this function when the route coordinates are available
                _showModalBottomSheet();
              },
              selectedBorderColor: Colors.green[600],
              renderBorder: false,
              highlightColor: Colors.green[400],
              selectedColor: Colors.white,
              fillColor: Colors.green[600],
              color: Colors.green[600],
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 40.0,
              ),
              isSelected: _selectedModes,
              children: transportModes
                  .map(
                    (mode) => Icon(
                      mode.icon,
                      size: 30.0,
                    ),
                  )
                  .toList(),
            ),
            //),
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: Text(
                currentMinMaxEmissions,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.green[700], fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showModalBottomSheet() {
    showModalBottomSheet<void>(
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return const TravelModeBottomSheet();
      },
    );
  }
}
