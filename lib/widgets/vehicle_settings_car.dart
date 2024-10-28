import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_carbon_conscious_traveller/models/calculation_values.dart';
import 'package:the_carbon_conscious_traveller/models/private_car_emissions_calculator.dart';
import 'package:the_carbon_conscious_traveller/models/private_car_state.dart';
import 'package:the_carbon_conscious_traveller/models/polylines_state.dart';
import 'package:the_carbon_conscious_traveller/models/tree_icons_calculator.dart';
import 'package:the_carbon_conscious_traveller/widgets/tree_icons.dart';

class CarSettings extends StatefulWidget {
  const CarSettings({super.key});

  @override
  State<CarSettings> createState() => _CarSettingsState();
}

class _CarSettingsState extends State<CarSettings> {
  CarSize? selectedSize;
  CarFuelType? selectedFuelType;
  late PrivateCarEmissionsCalculator emissionCalculator;
  List treeIconName = [];

  @override
  Widget build(BuildContext context) {
    PolylinesState polylineState = Provider.of<PolylinesState>(context);
    emissionCalculator = PrivateCarEmissionsCalculator(
      polylinesState: polylineState,
      vehicleSize: selectedSize ?? CarSize.label,
      vehicleFuelType: selectedFuelType ?? CarFuelType.label,
    );

    return Consumer<PrivateCarState>(
      builder: (context, carState, child) {
        int minEmission = 0;
        int maxEmission = 0;

        void getMinMaxEmissions() {
          minEmission = emissionCalculator.calculateMinEmission().round();
          carState.updateMinEmission(minEmission);
          maxEmission = emissionCalculator.calculateMaxEmission().round();
          carState.updateMaxEmission(maxEmission);
        }

        void getCarEmissions() {
          List<int> emissions = [];
          for (int i = 0; i < polylineState.result.length; i++) {
            emissions.add(emissionCalculator
                .calculateEmissions(i, selectedSize!, selectedFuelType!)
                .round());
          }
          print("CarEmissions: $emissions");
          carState.saveEmissions(emissions);
        }

        void changeVisibility(bool isVisible) {
          carState.updateVisibility(isVisible);
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
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Title(
                    color: Colors.black,
                    child: Text(
                      "Car",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownMenu<CarSize>(
                        width: 300,
                        initialSelection: carState.selectedSize,
                        requestFocusOnTap: true,
                        label: const Text('Car Size'),
                        onSelected: (CarSize? size) {
                          carState.updateSelectedSize(size ?? CarSize.label);
                          setState(() {
                            selectedSize = carState.selectedSize;
                          });
                        },
                        dropdownMenuEntries: CarSize.values
                            .map<DropdownMenuEntry<CarSize>>((CarSize size) {
                          return DropdownMenuEntry<CarSize>(
                            value: size,
                            label: size.name,
                            enabled: size.name != 'Select',
                            style: MenuItemButton.styleFrom(
                                foregroundColor: Colors.black),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownMenu<CarFuelType>(
                        width: 300,
                        initialSelection: carState.selectedFuelType,
                        requestFocusOnTap: true,
                        label: const Text('Fuel Type'),
                        onSelected: (CarFuelType? fuelType) {
                          carState.updateSelectedFuelType(
                              fuelType ?? CarFuelType.label);
                          setState(() {
                            selectedFuelType = fuelType;
                          });
                        },
                        dropdownMenuEntries: CarFuelType.values
                            .map<DropdownMenuEntry<CarFuelType>>(
                                (CarFuelType type) {
                          return DropdownMenuEntry<CarFuelType>(
                            value: type,
                            label: type.name,
                            enabled: type.name != 'Select',
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
                    if (selectedSize == null || selectedFuelType == null) {
                      return;
                    } else {
                      changeVisibility(true);
                      getMinMaxEmissions();
                      getCarEmissions();
                    }
                  },
                  child: const Text("Calculate Emissions"),
                ),
                Visibility(
                  visible: carState.isVisible,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      children: [
                        Text(
                            '${formatNumber(carState.minEmissionValue)} - ${formatNumber(carState.maxEmissionValue)}'),
                        ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8),
                          itemCount: polylineState.result.length,
                          itemBuilder: (BuildContext context, int index) {
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
                                                Icons.directions_car_outlined,
                                                color: Colors.green,
                                              ),
                                            ),
                                            Text(
                                                'via ${polylineState.routeSummary[index]}'),
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
                                            Text(formatNumber(
                                                carState.getEmission(index))),
                                            Image.asset('assets/icons/co2e.png',
                                                width: 40, height: 40),
                                          ],
                                        ),
                                        Text(
                                            polylineState.distanceTexts[index]),
                                        Text(
                                            polylineState.durationTexts[index]),
                                        TreeIcons(
                                            treeIconName: treeIconName =
                                                upDateTreeIcons(
                                                    carState.emissions, index)),
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
