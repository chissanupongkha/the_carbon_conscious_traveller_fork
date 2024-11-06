import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_carbon_conscious_traveller/state/polylines_state.dart';
import 'package:the_carbon_conscious_traveller/widgets/tree_icons.dart';

class MotorcycleListView extends StatefulWidget {
  const MotorcycleListView(
      {super.key,
      required this.vehicleState,
      required this.polylinesState,
      required this.icon});

  final dynamic vehicleState;
  final PolylinesState polylinesState;
  final IconData icon;

  @override
  State<MotorcycleListView> createState() => _MotorcycleListViewState();
}

class _MotorcycleListViewState extends State<MotorcycleListView> {
  @override
  Widget build(BuildContext context) {
    String formatNumber(int number) {
      if (number >= 1000) {
        return '${(number / 1000).toStringAsFixed(2)} kg';
      } else {
        return '${number.round()} g';
      }
    }

    int selectedIndex;

    return Consumer(builder: (context, PolylinesState polylinesState, child) {
      return Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            itemCount: widget.polylinesState.resultForPrivateVehicle.length,
            itemBuilder: (BuildContext context, int index) {
              widget.vehicleState.getTreeIcons(index);

              selectedIndex = polylinesState.motorcycleActiveRouteIndex;

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
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Icon(widget.icon,
                                      color: Colors.green, size: 30),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 30),
                                    child: Text(
                                        'via ${widget.polylinesState.routeSummary[index]}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(formatNumber(
                                    widget.vehicleState.getEmission(index))),
                                Image.asset('assets/icons/co2e.png',
                                    width: 30, height: 30),
                              ],
                            ),
                            Text(widget.polylinesState.distanceTexts[index],
                                style: Theme.of(context).textTheme.bodySmall),
                            Text(widget.polylinesState.durationTexts[index],
                                style: Theme.of(context).textTheme.bodySmall),
                            TreeIcons(
                                treeIconName: widget.vehicleState.treeIcons),
                          ],
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
