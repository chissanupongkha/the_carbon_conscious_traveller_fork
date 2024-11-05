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

const String motorcycling = 'motorcycling';
const String driving = 'driving';
const String transit = 'transit';

String motorcycleEmissions = '';
String carEmissions = '';
String transitEmissions = '';

String getCurrentMinMaxEmissions(
  String mode,
  PrivateMotorcycleState motorcycleState,
  PrivateCarState carState,
  TransitState transitState,
) {
  String formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)} kg';
    } else {
      return '${number.round()} g';
    }
  }

  String getEmissions(int maxEmissionValue, int minEmissionValue) {
    String currentMaxEmissions = formatNumber(maxEmissionValue);
    String currentMinEmissions = formatNumber(minEmissionValue);
    if (maxEmissionValue == 0) {
      return '';
    } else if (maxEmissionValue == minEmissionValue) {
      return currentMaxEmissions;
    }
    return '$currentMinEmissions - $currentMaxEmissions';
  }

  switch (mode) {
    case motorcycling:
      motorcycleEmissions = getEmissions(
        motorcycleState.maxEmissionValue,
        motorcycleState.minEmissionValue,
      );
      return motorcycleEmissions;
    case driving:
      carEmissions = getEmissions(
        carState.maxEmissionValue,
        carState.minEmissionValue,
      );
      return carEmissions;
    case transit:
      transitEmissions = getEmissions(
        transitState.maxEmissionValue,
        transitState.minEmissionValue,
      );
      return transitEmissions;
    default:
      return '';
  }
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
      getCurrentMinMaxEmissions(
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ToggleButtons(
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

                  polylineState.setActiveRoute(polylineState.getActiveRoute());
                  polylineState.getPolyline(coordinatesState
                      .coordinates); // only call this function when the route coordinates are available
                  _showModalBottomSheet();
                },
                //selectedBorderColor: Colors.green[600],
                renderBorder: false,
                highlightColor: Colors.green[400],
                selectedColor: Colors.green[600],
                color: Colors.grey[600],
                splashColor: Colors.green[200],
                fillColor: Colors.transparent,
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 40.0,
                ),
                isSelected: _selectedModes,
                children: transportModes
                    .map(
                      (travelMode) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Icon(
                                travelMode.icon,
                                size: 30.0,
                              ),
                            ),
                            if (travelMode.mode == 'motorcycling')
                              Text(motorcycleEmissions,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                            if (travelMode.mode == 'driving')
                              Text(
                                carEmissions,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            if (travelMode.mode == 'transit')
                              Text(
                                transitEmissions,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
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
