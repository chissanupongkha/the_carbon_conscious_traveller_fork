import 'package:flutter/material.dart';
import 'package:the_carbon_conscious_traveller/helpers/tree_icons_calculator.dart';
import 'dart:math';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
            '${formatNumber(emissions.reduce(min))} - ${formatNumber(emissions.reduce(max))}'),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            int? stepsIdx = snapshot.data?[index].legs?.first.steps?.length;
            int i = 0;
            return Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            children: [
                              for (i = 0; i < stepsIdx!; i++) ...[
                                if (snapshot.data?[index].legs?.first.steps?[i]
                                        .transit?.line?.vehicle?.icon ==
                                    null)
                                  const Icon(Icons.directions_walk)
                                else
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Image.network(
                                          "https:${snapshot.data?[index].legs?.first.steps?[i].transit?.line?.vehicle?.icon}"),
                                      Text(
                                          "${snapshot.data?[index].legs?.first.steps?[i].transit?.line?.shortName}"),
                                    ],
                                  ),
                              ],
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              snapshot.data?[index].legs?.first.departureTime
                                          ?.text ==
                                      null
                                  ? ""
                                  : "${snapshot.data?[index].legs?.first.departureTime?.text} - ${snapshot.data?[index].legs?.first.arrivalTime?.text}",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
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
                          "${snapshot.data?[index].legs?.first.distance?.text}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          "${snapshot.data?[index].legs?.first.duration?.text}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TreeIcons(
                            treeIconName: upDateTreeIcons(
                                emissions.map((e) => e.toInt()).toList(),
                                index)),
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
    );
  }
}
