import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_carbon_conscious_traveller/models/calculation_values.dart';
import 'package:the_carbon_conscious_traveller/models/private_vehicle_emissions_calculator.dart';
import 'package:the_carbon_conscious_traveller/models/routes_model.dart';

class MotorcyleSettings extends StatefulWidget {
  const MotorcyleSettings({super.key});

  @override
  State<MotorcyleSettings> createState() => _MotorcyleSettingsState();
}

class _MotorcyleSettingsState extends State<MotorcyleSettings> {
  MotorcycleSize? selectedSize;
  MotorcycleSize? size;
  MotorcycleSize? sizeValue;
  late PrivateVehicleEmissionsCalculator _emissionCalculator;

  @override
  Widget build(BuildContext context) {
    return Consumer<RoutesModel>(builder: (context, routesModel, child) {
      _emissionCalculator = PrivateVehicleEmissionsCalculator(
        routesModel: routesModel,
        vehicleSize: selectedSize ?? MotorcycleSize.label,
      );
      return Scaffold(
        body: Column(
          children: <Widget>[
            Title(
              color: Colors.black,
              child: Text(
                "Motorcycle",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DropdownMenu<MotorcycleSize>(
                    width: 300,
                    initialSelection: MotorcycleSize.label,
                    requestFocusOnTap: true,
                    label: const Text('Car Size'),
                    onSelected: (MotorcycleSize? size) {
                      setState(() {
                        selectedSize = size;
                      });
                    },
                    dropdownMenuEntries: MotorcycleSize.values
                        .map<DropdownMenuEntry<MotorcycleSize>>(
                            (MotorcycleSize size) {
                      return DropdownMenuEntry<MotorcycleSize>(
                        value: size,
                        label: size.name,
                        enabled: size.name != 'Size',
                        style: MenuItemButton.styleFrom(
                            foregroundColor: Colors.black),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Text(
                'MinEmission: ${_emissionCalculator.calculateMinEmission().round()}g'),
            Text(
                'MaxEmission: ${_emissionCalculator.calculateMaxEmission().round()}g'),
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: routesModel.distanceTexts.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors.green[100],
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Route ${index + 1}'),
                        Text(
                            'Emission: ${_emissionCalculator.calculateEmission(index).round()}g'),
                        Text('Distance: ${routesModel.distanceTexts[index]}'),
                        Text('Duration: ${routesModel.durationTexts[index]}'),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ],
        ),
      );
    });
  }
}
