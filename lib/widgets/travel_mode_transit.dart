import 'package:flutter/material.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:provider/provider.dart';
import 'package:the_carbon_conscious_traveller/state/coordinates_state.dart';
import 'package:the_carbon_conscious_traveller/models/routes_model.dart';
import 'package:the_carbon_conscious_traveller/helpers/transit_emissions_calculator.dart';
import 'package:the_carbon_conscious_traveller/widgets/transit_list_view.dart';

class Transit extends StatefulWidget {
  const Transit({super.key});

  @override
  State<Transit> createState() => _TransitState();
}

class _TransitState extends State<Transit> {
  final travelMode = TravelMode.transit;
  RoutesModel? routesModel;
  List<DirectionsRoute>? routes = [];
  String? iconURL;
  CoordinatesState coordsState = CoordinatesState();
  TransitEmissionsCalculator? _transitEmissionsCalculator;
  List treeIconName = [];

  @override
  void initState() {
    _transitEmissionsCalculator = TransitEmissionsCalculator();
    super.initState();
  }

  Future<List<DirectionsRoute>> fetchRouteInfo() async {
    debugPrint("request sent");
    final coordsState = Provider.of<CoordinatesState>(context, listen: false);
    routesModel = RoutesModel(
      origin: GeoCoord(coordsState.originCoords.latitude,
          coordsState.originCoords.longitude),
      destination: GeoCoord(coordsState.destinationCoords.latitude,
          coordsState.destinationCoords.longitude),
      travelMode: TravelMode.transit,
    );
    debugPrint("request is about to return");
    routes = await routesModel?.getRouteInfo();
    debugPrint("routes $routes");
    if (routes == null) {
      return [];
    } else {
      coordsState.saveRouteData(routes!);
      return routes!;
    }
  }

  // String formatNumber(double number) {
  //   if (number >= 1000) {
  //     return '${(number / 1000).toStringAsFixed(2)} kg';
  //   } else {
  //     return '${number.round()} g';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: FutureBuilder<List<DirectionsRoute>>(
        future: fetchRouteInfo(),
        builder: (context, snapshot) {
          final emissions =
              _transitEmissionsCalculator?.calculateEmissions(context);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              heightFactor: 10,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return snapshot.data == null
                ? const Text('No data available')
                : Column(
                    children: [
                      // Text(
                      //     '${formatNumber(emissions!.reduce(min))} - ${formatNumber(emissions.reduce(max))}'),
                      // ListView.separated(
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   shrinkWrap: true,
                      //   itemCount: snapshot.data!.length,
                      //   itemBuilder: (context, index) {
                      //     int? stepsIdx =
                      //         snapshot.data?[index].legs?.first.steps?.length;
                      //     int i = 0;
                      //     return Container(
                      //       padding: const EdgeInsets.all(10),
                      //       child: Row(
                      //         children: [
                      //           Expanded(
                      //             flex: 2,
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(8.0),
                      //               child: Column(
                      //                 crossAxisAlignment:
                      //                     CrossAxisAlignment.start,
                      //                 children: [
                      //                   Wrap(
                      //                     children: [
                      //                       for (i = 0; i < stepsIdx!; i++) ...[
                      //                         if (snapshot
                      //                                 .data?[index]
                      //                                 .legs
                      //                                 ?.first
                      //                                 .steps?[i]
                      //                                 .transit
                      //                                 ?.line
                      //                                 ?.vehicle
                      //                                 ?.icon ==
                      //                             null)
                      //                           const Icon(
                      //                               Icons.directions_walk)
                      //                         else
                      //                           Wrap(
                      //                             children: [
                      //                               Image.network(
                      //                                   "https:${snapshot.data?[index].legs?.first.steps?[i].transit?.line?.vehicle?.icon}"),
                      //                               Text(
                      //                                   "${snapshot.data?[index].legs?.first.steps?[i].transit?.line?.shortName}"),
                      //                             ],
                      //                           ),
                      //                       ],
                      //                     ],
                      //                   ),
                      //                   Padding(
                      //                     padding:
                      //                         const EdgeInsets.only(top: 10),
                      //                     child: Text(
                      //                         "${snapshot.data?[index].legs?.first.departureTime?.text} - ${snapshot.data?[index].legs?.first.arrivalTime?.text}"),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //           Expanded(
                      //             flex: 1,
                      //             child: Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: [
                      //                 Row(
                      //                   children: [
                      //                     Text(formatNumber(emissions[index])),
                      //                     Image.asset('assets/icons/co2e.png',
                      //                         width: 40, height: 40),
                      //                   ],
                      //                 ),
                      //                 Text(
                      //                     "${snapshot.data?[index].legs?.first.distance?.text}"),
                      //                 Text(
                      //                     "${snapshot.data?[index].legs?.first.duration?.text}"),
                      //                 TreeIcons(
                      //                     treeIconName: treeIconName =
                      //                         upDateTreeIcons(
                      //                             emissions
                      //                                 .map((e) => e.toInt())
                      //                                 .toList(),
                      //                             index)),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     );
                      //   },
                      //   separatorBuilder: (BuildContext context, int index) =>
                      //       const Divider(),
                      // ),
                      if (emissions != null)
                        TransitListView(
                            snapshot: snapshot, emissions: emissions)
                      else
                        const Text('No emissions data available')
                    ],
                  );
          } else {
            return const Text('No data available');
          }
        },
      ),
    ));
  }
}
