import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_carbon_conscious_traveller/helpers/transit_emissions_calculator.dart';
import 'package:the_carbon_conscious_traveller/helpers/tree_icons_calculator.dart';
import 'package:the_carbon_conscious_traveller/state/polylines_state.dart';
import 'package:the_carbon_conscious_traveller/state/transit_state.dart';
import 'package:the_carbon_conscious_traveller/widgets/transit_steps.dart';
import 'package:the_carbon_conscious_traveller/widgets/tree_icons.dart';

class TransitListView extends StatelessWidget {
  const TransitListView(
      {super.key, required this.snapshot, required this.emissions});

  final dynamic snapshot;
  final List<double> emissions;

  String formatNumber(double number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)} kg';
    } else {
      return '${number.round()} g';
    }
  }

  // Color parseColor(String? colorString, Color defaultColor) {
  //   if (colorString != null) {
  //     return Color(int.parse(colorString.replaceAll('#', '0xff')));
  //   }
  //   return defaultColor;
  // }

  @override
  Widget build(BuildContext context) {
    TransitEmissionsCalculator? transitEmissionsCalculator =
        TransitEmissionsCalculator();

    PolylinesState polylinesState = Provider.of<PolylinesState>(context);
    TransitState transitState = Provider.of<TransitState>(context);
    transitState.updateMaxEmissions(emissions.reduce(max).toInt());
    transitState.updateMinEmissions(emissions.reduce(min).toInt());

    return Column(
      children: [
        Text(
            '${formatNumber(emissions.reduce(min))} - ${formatNumber(emissions.reduce(max))}'),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            List<dynamic> legs = snapshot.data?[index].legs;
            List<dynamic> steps = snapshot.data?[index].legs?.first.steps;
            List<double> stepEmissions =
                transitEmissionsCalculator.calculateStepEmissions(steps);
            Color color = Colors.transparent;

            if (polylinesState.activeRouteIndex == index) {
              color = Colors.green;
            } else {
              color = Colors.transparent;
            }

            return Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: color,
                    width: 4.0,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 12, right: 20, top: 16, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TransitSteps(
                              steps: steps, stepEmissions: stepEmissions),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              legs.first.departureTime?.text == null
                                  ? ""
                                  : "${legs.first.departureTime?.text} - ${legs.first.arrivalTime?.text}",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(formatNumber(emissions[index]),
                                  style: Theme.of(context).textTheme.bodyLarge),
                              Image.asset('assets/icons/co2e.png',
                                  width: 30, height: 30),
                            ],
                          ),
                          Text(
                            "${legs.first.distance?.text}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            "${legs.first.duration?.text}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TreeIcons(
                              treeIconName: upDateTreeIcons(
                                  emissions.map((e) => e.toInt()).toList(),
                                  index)),
                        ],
                      ),
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
    );
  }
}
