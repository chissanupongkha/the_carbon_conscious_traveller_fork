import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_carbon_conscious_traveller/models/calculation_values.dart';
import 'package:the_carbon_conscious_traveller/models/private_car_emissions_calculator.dart';
import 'package:the_carbon_conscious_traveller/models/private_car_state.dart';
import 'package:the_carbon_conscious_traveller/models/routes_model.dart';

class CarSettings extends StatefulWidget {
  const CarSettings({super.key});

  @override
  State<CarSettings> createState() => _CarSettingsState();
}

class _CarSettingsState extends State<CarSettings> {
  CarSize? selectedSize;
  CarFuelType? selectedFuelType;
  late PrivateCarEmissionsCalculator emissionCalculator;

  @override
  Widget build(BuildContext context) {
    RoutesModel routesModel = Provider.of<RoutesModel>(context);
    emissionCalculator = PrivateCarEmissionsCalculator(
      routesModel: routesModel,
      vehicleSize: selectedSize ?? CarSize.smallCar,
      vehicleFuelType: selectedFuelType ?? CarFuelType.petrol,
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
          for (int i = 0; i < routesModel.result.length; i++) {
            emissions.add(emissionCalculator
                .calculateEmission(i, selectedSize ?? CarSize.smallCar,
                    selectedFuelType ?? CarFuelType.petrol)
                .round());
          }
          print("CarEmissions: $emissions");
          carState.saveEmissions(emissions);
        }

        void changeVisibility(bool isVisible) {
          carState.updateVisibility(isVisible);
        }

        String formatNumber(int number) {
          if (number >= 1000 && number < 1000000) {
            return '${(number / 1000).toStringAsFixed(2)} k';
          } else {
            return number.toString();
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
                        initialSelection: CarSize.smallCar,
                        requestFocusOnTap: true,
                        label: const Text('Car Size'),
                        onSelected: (CarSize? size) {
                          setState(() {
                            selectedSize = size;
                          });
                        },
                        dropdownMenuEntries: CarSize.values
                            .map<DropdownMenuEntry<CarSize>>((CarSize size) {
                          return DropdownMenuEntry<CarSize>(
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownMenu<CarFuelType>(
                        width: 300,
                        initialSelection: CarFuelType.petrol,
                        requestFocusOnTap: true,
                        label: const Text('Fuel Type'),
                        onSelected: (CarFuelType? fuelType) {
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
                            enabled: type.name != 'Fuel Type',
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
                    getCarEmissions();
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
                            'MinEmission: ${formatNumber(carState.minEmissionValue)}g'),
                        Text(
                            'MaxEmission: ${formatNumber(carState.maxEmissionValue)}g'),
                        ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8),
                          itemCount: routesModel.result.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              color: Colors.green[100],
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Route ${index + 1}'),
                                    //Text('Emission: ${emissions[index]}g'),
                                    Text(
                                        'Emission: ${formatNumber(carState.getEmission(index))}g'),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
