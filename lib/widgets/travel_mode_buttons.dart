import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_carbon_conscious_traveller/state/coordinates_state.dart';
import 'package:the_carbon_conscious_traveller/state/polylines_state.dart';
import 'package:the_carbon_conscious_traveller/widgets/vehicle_settings_bottom_sheet.dart';

class TravelModeButtons extends StatefulWidget {
  const TravelModeButtons({super.key});

  @override
  State<TravelModeButtons> createState() => _TravelModeButtonsState();
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
    return Consumer<PolylinesState>(builder: (context, polylineState, child) {
      return Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: ToggleButtons(
          onPressed: (int index) {
            setState(() {
              // The button that is tapped is set to true, and the others to false
              for (int i = 0; i < _selectedModes.length; i++) {
                _selectedModes[i] = i == index;
              }
            });

            polylineState.transportMode = transportModes[index].mode;

            final coordinatesModel =
                Provider.of<CoordinatesState>(context, listen: false);

            if (coordinatesModel.coordinates.isEmpty) {
              return;
            }
            polylineState.getPolyline(coordinatesModel
                .coordinates); // only call this function when the route coordinates are available
            _showModalBottomSheet();
          },
          selectedBorderColor: Colors.green[700],
          selectedColor: Colors.white,
          fillColor: Colors.green[200],
          color: Colors.green[400],
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
