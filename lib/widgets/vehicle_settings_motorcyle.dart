import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_carbon_conscious_traveller/models/calculation_values.dart';
import 'package:the_carbon_conscious_traveller/models/routes_model.dart';

// enum MotorcycleSize {
//   small('Small'),
//   medium('Medium'),
//   large('Large'),
//   label('Size');

//   const MotorcycleSize(this.size);
//   final String size;
// }

class MotorcyleSettings extends StatefulWidget {
  const MotorcyleSettings({super.key});

  @override
  State<MotorcyleSettings> createState() => _MotorcyleSettingsState();
}

class _MotorcyleSettingsState extends State<MotorcyleSettings> {
  MotorcycleSize? selectedSize;
  MotorcycleSize? size;
  MotorcycleSize? sizeValue;

  stateinit() {
    super.initState();
    for (size in MotorcycleSize.values) {
      print("Size $size");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoutesModel>(builder: (context, routesModel, child) {
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
            FilledButton(
              onPressed: () => calculateValue(selectedSize),
              child: const Text("Calculate"),
            ),
            Text(
              sizeValue?.value.toString() ?? "Size is empty",
            ),
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
                            'Emmisions: ${routesModel.distances[index] * (sizeValue?.value ?? 0)}'),
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

  void calculateValue(MotorcycleSize? size) {
    final routesModel = Provider.of<RoutesModel>(context, listen: false);

    if (size != null) {
      final vehicleSize = MotorcycleSize.values.firstWhere(
        (e) => e.name == size.name,
        orElse: () => MotorcycleSize.label,
      );
      print("Motorcycle Distance: ${routesModel.distances}");
      print("motorcycle value again: ${vehicleSize.value}");
      //ERROR - START HERE
      print(
          "Motorcycle emmisions: ${routesModel.distances[routesModel.activeRouteIndex] * vehicleSize.value}");
      print("Motorcycle emmisions: ${vehicleSize.value}");
      print(
          "Motorcycle emmisions routes mpodel index: ${routesModel.activeRouteIndex}"); // the index keeps getting bigger
    }
    setState(() {
      sizeValue = size;
    });
  }
}
