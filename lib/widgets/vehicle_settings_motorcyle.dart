import 'package:flutter/material.dart';

enum MotorcycleSize {
  small('Small'),
  medium('Medium'),
  large('Large'),
  label('Size');

  const MotorcycleSize(this.size);
  final String size;
}

class MotorcyleSettings extends StatefulWidget {
  const MotorcyleSettings({super.key});

  @override
  State<MotorcyleSettings> createState() => _MotorcyleSettingsState();
}

class _MotorcyleSettingsState extends State<MotorcyleSettings> {
  MotorcycleSize? selectedSize;

  @override
  Widget build(BuildContext context) {
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
          FilledButton(
            onPressed: () => {},
            child: const Text("Calculate"),
          ),
        ],
      ),
    );
  }
}
