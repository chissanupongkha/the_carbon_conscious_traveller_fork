import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_carbon_conscious_traveller/models/routes_model.dart';
import 'package:the_carbon_conscious_traveller/widgets/travel_mode_flying.dart';
import 'package:the_carbon_conscious_traveller/widgets/travel_mode_transit.dart';
import 'package:the_carbon_conscious_traveller/widgets/vehicle_settings_car.dart';
import 'package:the_carbon_conscious_traveller/widgets/vehicle_settings_motorcyle.dart';

class TravelModeBottomSheet extends StatelessWidget {
  const TravelModeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final polylineModel = Provider.of<RoutesModel>(context, listen: false);
    String travelMode = polylineModel.mode;
    return Builder(
      builder: (context) {
        if (travelMode == "motorcycling") {
          return const MotorcyleSettings();
        } else if (travelMode == "transit") {
          return const Transit();
        } else if (travelMode == "flying") {
          return const Flying();
        }
        return const CarSettings();
      },
    );
  }
}
