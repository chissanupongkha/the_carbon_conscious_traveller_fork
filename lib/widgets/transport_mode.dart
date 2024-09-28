import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_carbon_conscious_traveller/models/coordinates_model.dart';
import 'package:the_carbon_conscious_traveller/models/polyline_model.dart';
import 'package:the_carbon_conscious_traveller/widgets/vehicle_settings_car.dart';

class TransportMode extends StatefulWidget {
  const TransportMode({super.key});

  @override
  State<TransportMode> createState() => _TransportModeState();
}

class _TransportModeState extends State<TransportMode> {
  final List<bool> _selectedModes = <bool>[true, false, false, false];

  final List<({IconData icon, String mode})> transportModes = [
    (icon: Icons.directions_car_outlined, mode: 'driving'),
    (icon: Icons.motorcycle_outlined, mode: 'motorcycling'),
    (icon: Icons.train_outlined, mode: 'transit'),
    (icon: Icons.airplanemode_active_outlined, mode: 'flying'),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<PolylineModel>(builder: (context, polylineModel, child) {
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
            polylineModel.transportMode = transportModes[index].mode;
            final coordinatesModel =
                Provider.of<CoordinatesModel>(context, listen: false);
            polylineModel.getPolyline(coordinatesModel.coordinates);
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
      context: context,
      builder: (BuildContext context) {
        return const CarSettings();
      },
    );
  }
}
