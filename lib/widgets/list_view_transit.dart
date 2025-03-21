import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_carbon_conscious_traveller/helpers/transit_emissions_calculator.dart';
import 'package:the_carbon_conscious_traveller/helpers/tree_icons_calculator.dart';
import 'package:the_carbon_conscious_traveller/state/polylines_state.dart';
import 'package:the_carbon_conscious_traveller/state/transit_state.dart';
import 'package:the_carbon_conscious_traveller/widgets/transit_steps.dart';
import 'package:the_carbon_conscious_traveller/widgets/tree_icons.dart';

class TransitListView extends StatefulWidget {
  const TransitListView(
      {super.key, required this.snapshot, required this.emissions});

  final dynamic snapshot;
  final List<double> emissions;

  @override
  State<TransitListView> createState() => _TransitListViewState();
}

class _TransitListViewState extends State<TransitListView> {
  String formatNumber(double number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)} kg';
    } else {
      return '${number.round()} g';
    }
  }

  @override
  Widget build(BuildContext context) {
    TransitEmissionsCalculator? transitEmissionsCalculator =
        TransitEmissionsCalculator();

    //Run after the UI has finished building
    //Otherwise, notifylisteners() is called before the UI is built
    //Causing the UI to refresh before it has finished building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TransitState transitState =
          Provider.of<TransitState>(context, listen: false);
      transitState.updateTransitEmissions(widget.emissions);
    });

    int selectedIndex;

    return Consumer(builder: (context, PolylinesState polylinesState, child) {
      return Column(
        children: [
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.snapshot.data!.length,
            itemBuilder: (context, index) {
              List<dynamic> legs = widget.snapshot.data?[index].legs;
              List<dynamic> steps =
                  widget.snapshot.data?[index].legs?.first.steps;
              List<double> stepEmissions =
                  transitEmissionsCalculator.calculateStepEmissions(steps);

              selectedIndex = polylinesState.transitActiveRouteIndex;

              //Change the border color of the active route
              Color color = Colors.transparent;
              if (selectedIndex == index) {
                color = Colors.green;
              } else {
                color = Colors.transparent;
              }

              return InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  polylinesState.setActiveRoute(selectedIndex);
                },
                child: Container(
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
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(formatNumber(widget.emissions[index]),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
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
                                      widget.emissions
                                          .map((e) => e.toInt())
                                          .toList(),
                                      index)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ],
      );
    });
  }
}
