import 'package:flutter/material.dart';

enum CarSize {
  small('Small'),
  medium('Medium'),
  large('Large'),
  label('Size');

  const CarSize(this.size);
  final String size;
}

enum FuelType {
  petrol('Petrol'),
  diesel('Diesel'),
  large('Other'),
  label('Fuel Type');

  const FuelType(this.fuelType);
  final String fuelType;
}

class CarSettings extends StatefulWidget {
  const CarSettings({super.key});

  @override
  State<CarSettings> createState() => _CarSettingsState();
}

class _CarSettingsState extends State<CarSettings> {
  CarSize? selectedSize;
  FuelType? selectedFuel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Title(
            color: Colors.black,
            child: Text(
              "Car",
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DropdownMenu<CarSize>(
                  width: 300,
                  initialSelection: CarSize.label,
                  // controller: sizeController,
                  // requestFocusOnTap is enabled/disabled by platforms when it is null.
                  // On mobile platforms, this is false by default. Setting this to true will
                  // trigger focus request on the text field and virtual keyboard will appear
                  // afterward. On desktop platforms however, this defaults to true.
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
                      label: size.size,
                      enabled: size.size != 'Size',
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
                DropdownMenu<FuelType>(
                  width: 300,
                  initialSelection: FuelType.label,
                  // controller: sizeController,
                  // requestFocusOnTap is enabled/disabled by platforms when it is null.
                  // On mobile platforms, this is false by default. Setting this to true will
                  // trigger focus request on the text field and virtual keyboard will appear
                  // afterward. On desktop platforms however, this defaults to true.
                  requestFocusOnTap: true,
                  label: const Text('Fuel Type'),
                  onSelected: (FuelType? fuelType) {
                    setState(() {
                      selectedFuel = fuelType;
                    });
                  },
                  dropdownMenuEntries: FuelType.values
                      .map<DropdownMenuEntry<FuelType>>((FuelType type) {
                    return DropdownMenuEntry<FuelType>(
                      value: type,
                      label: type.fuelType,
                      enabled: type.fuelType != 'Fuel Type',
                      style: MenuItemButton.styleFrom(
                          foregroundColor: Colors.black),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () => {},
            child: const Text("Calculate"),
          ),
        ],
      ),
    );
  }
}
