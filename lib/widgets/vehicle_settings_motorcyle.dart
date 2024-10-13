import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_carbon_conscious_traveller/models/calculation_values.dart';
import 'package:the_carbon_conscious_traveller/models/private_vehicle_emissions_calculator.dart';
import 'package:the_carbon_conscious_traveller/models/routes_model.dart';
import 'package:the_carbon_conscious_traveller/models/private_vehicle_state.dart';

class MotorcyleSettings extends StatefulWidget {
  const MotorcyleSettings({super.key});

  @override
  State<MotorcyleSettings> createState() => _MotorcyleSettingsState();
}

class _MotorcyleSettingsState extends State<MotorcyleSettings> {
  MotorcycleSize? selectedSize;
  bool isVisible = false;
  late PrivateVehicleEmissionsCalculator emissionCalculator;

  @override
  Widget build(BuildContext context) {
    RoutesModel routesModel = Provider.of<RoutesModel>(context);
    emissionCalculator = PrivateVehicleEmissionsCalculator(
      routesModel: routesModel,
      vehicleSize: selectedSize ?? MotorcycleSize.label,
    );
    return Consumer<PrivateVehicleState>(
      builder: (context, dropdownState, child) {
        void changeVisibility(bool isVisible) {
          dropdownState.updateVisibility(isVisible);
        }

        int minEmission = 0;
        int maxEmission = 0;

        void getMinMaxEmissions() {
          minEmission = emissionCalculator.calculateMinEmission().round();
          dropdownState.updateMinEmission(minEmission);
          maxEmission = emissionCalculator.calculateMaxEmission().round();
          dropdownState.updateMaxEmission(maxEmission);
        }

        void getEmissions() {
          List<int> emissions = [];
          for (int i = 0; i < routesModel.result.length; i++) {
            emissions.add(emissionCalculator.calculateEmission(i).round());
          }
          dropdownState.saveEmissions(emissions);
        }

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Title(
                    color: Colors.black,
                    child: Text(
                      "Motorcycle",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Consumer<PrivateVehicleState>(
                      //   builder: (context, dropdownState, child) {
                      //     void changeVisibility(bool isVisible) {
                      //       dropdownState.updateVisibility(isVisible);
                      //     }

                      //     int minEmission = 0;
                      //     int maxEmission = 0;

                      //     void getMinMaxEmissions() {
                      //       minEmission =
                      //           emissionCalculator.calculateMinEmission().round();
                      //       dropdownState.updateMinEmission(minEmission);
                      //       maxEmission =
                      //           emissionCalculator.calculateMaxEmission().round();
                      //       dropdownState.updateMaxEmission(maxEmission);
                      //     }

                      //     void getEmissions() {
                      //       List<int> emissions = [];
                      //       for (int i = 0; i < routesModel.result.length; i++) {
                      //         emissions.add(
                      //             emissionCalculator.calculateEmission(i).round());
                      //       }
                      //       dropdownState.saveEmissions(emissions);
                      //     }

                      //     return Column(
                      DropdownMenu<MotorcycleSize>(
                        width: 300,
                        initialSelection: dropdownState.selectedValue,
                        requestFocusOnTap: true,
                        label: const Text('Motorcycle Size'),
                        onSelected: (MotorcycleSize? size) {
                          dropdownState.updateSelectedValue(
                              size ?? MotorcycleSize.label);
                          setState(() {
                            selectedSize = dropdownState.selectedValue;
                          });
                        },
                        dropdownMenuEntries: MotorcycleSize.values
                            .map<DropdownMenuEntry<MotorcycleSize>>(
                                (MotorcycleSize size) {
                          return DropdownMenuEntry<MotorcycleSize>(
                            value: size,
                            label: size.name,
                            enabled: size.name != MotorcycleSize.label.name,
                            style: MenuItemButton.styleFrom(
                                foregroundColor: Colors.black),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    changeVisibility(true);
                    getMinMaxEmissions();
                    getEmissions();
                  },
                  child: const Text('Calculate Emissions'),
                ),
                Visibility(
                  visible: dropdownState.isVisible,
                  child: Column(
                    children: [
                      Text('MinEmission: ${dropdownState.minEmissionValue}g'),
                      Text('MaxEmission: ${dropdownState.maxEmissionValue}g'),
                      ListView.separated(
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
                                      'Emission: ${dropdownState.getEmission(index).toString()}g'),
                                  Text(
                                      'Distance: ${routesModel.distanceTexts[index]}'),
                                  Text(
                                      'Duration: ${routesModel.durationTexts[index]}'),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
