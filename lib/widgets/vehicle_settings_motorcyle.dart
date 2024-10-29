import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_carbon_conscious_traveller/models/calculation_values.dart';
import 'package:the_carbon_conscious_traveller/models/private_vehicle_emissions_calculator.dart';
import 'package:the_carbon_conscious_traveller/models/polylines_state.dart';
import 'package:the_carbon_conscious_traveller/models/private_motorcycle_state.dart';
import 'package:the_carbon_conscious_traveller/widgets/tree_icons.dart';

class MotorcyleSettings extends StatefulWidget {
  const MotorcyleSettings({super.key});

  @override
  State<MotorcyleSettings> createState() => _MotorcyleSettingsState();
}

class _MotorcyleSettingsState extends State<MotorcyleSettings> {
  MotorcycleSize? selectedSize;
  bool isVisible = false;
  late PrivateVehicleEmissionsCalculator emissionCalculator;
  List<int> emissions = [];
  List<String> treeIconName = [];

  @override
  Widget build(BuildContext context) {
    PolylinesState polylinesState = Provider.of<PolylinesState>(context);
    emissionCalculator = PrivateVehicleEmissionsCalculator(
      polylinesState: polylinesState,
      vehicleSize: selectedSize ?? MotorcycleSize.label,
    );

    return Consumer<PrivateMotorcycleState>(
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
          for (int i = 0; i < polylinesState.result.length; i++) {
            emissions.add(emissionCalculator.calculateEmission(i).round());
          }
          dropdownState.saveEmissions(emissions);
        }

        String formatNumber(int number) {
          if (number >= 1000) {
            return '${(number / 1000).toStringAsFixed(2)} kg';
          } else {
            return '${number.round()} g';
          }
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
                    getEmissions();
                    getMinMaxEmissions();
                  },
                  child: const Text('Calculate Emissions'),
                ),
                Visibility(
                  visible: dropdownState.isVisible,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      children: [
                        Text(
                            '${formatNumber(dropdownState.minEmissionValue)} - ${formatNumber(dropdownState.maxEmissionValue)}'),
                        ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8),
                          itemCount: polylinesState.result.length,
                          itemBuilder: (BuildContext context, int index) {
                            dropdownState.getTreeIcons(index);
                            return Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: const Icon(
                                                  Icons.motorcycle,
                                                  color: Colors.green,
                                                  size: 30),
                                            ),
                                            Expanded(
                                              child: Text(
                                                  'via ${polylinesState.routeSummary[index]}'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(formatNumber(dropdownState
                                                .getEmission(index))),
                                            Image.asset('assets/icons/co2e.png',
                                                width: 40, height: 40),
                                          ],
                                        ),
                                        Text(polylinesState
                                            .distanceTexts[index]),
                                        Text(polylinesState
                                            .durationTexts[index]),
                                        TreeIcons(
                                            treeIconName:
                                                dropdownState.treeIcons),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                      ],
                    ),
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
