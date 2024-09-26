import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_carbon_conscious_traveller/models/polyline_model.dart';

const List<Widget> modes = <Widget>[
  Icon(
    Icons.directions_car_outlined,
    key: Key('driving'),
  ),
  Icon(
    Icons.motorcycle_outlined,
    key: Key('driving'), // This must be motorcycling
  ),
  Icon(
    Icons.train_outlined,
    key: Key('transit'),
  ),
  Icon(
    Icons.airplanemode_active_outlined,
    key: Key('walking'), // This must be flying
  ),
];

class TransportMode extends StatefulWidget {
  const TransportMode({super.key});

  @override
  State<TransportMode> createState() => _TransportModeState();
}

class _TransportModeState extends State<TransportMode> {
  final List<bool> _selectedModes = <bool>[true, false, false, false];

  @override
  Widget build(BuildContext context) {
    final PolylineModel polylineModel =
        Provider.of<PolylineModel>(context, listen: false);

    final selectedMode = modes[0];
    final selectedKey = selectedMode.key as Key;
    print("Selected key: ${selectedKey.toString()}");
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
            switch (index) {
              case 0:
                polylineModel.transportMode = "driving";
                break;
              case 1:
                polylineModel.transportMode =
                    "driving"; // This must be motorcycling
                break;
              case 2:
                polylineModel.transportMode = "transit";
                break;
              case 3:
                polylineModel.transportMode = "flying"; //
            }
            print("Transport mode: ${polylineModel.mode}");
          });
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
        children: modes,
      ),
    );
  }
}
