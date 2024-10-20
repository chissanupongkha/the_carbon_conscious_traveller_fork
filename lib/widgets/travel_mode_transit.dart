import 'package:flutter/material.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:provider/provider.dart';
import 'package:the_carbon_conscious_traveller/models/coordinates_state.dart';
import 'package:the_carbon_conscious_traveller/models/routes_model.dart';

class Transit extends StatefulWidget {
  const Transit({super.key});

  @override
  State<Transit> createState() => _TransitState();
}

class _TransitState extends State<Transit> {
  final travelMode = TravelMode.transit;
  RoutesModel? routesModel;
  dynamic routes;
  String? iconURL;

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
      debugPrint("routes returned? $routes");
      return routes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 500,
      child: FutureBuilder<List<DirectionsRoute>>(
        future: fetchRouteInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            print("snapshot data: ${snapshot.data!.length}");
            return snapshot.data == null
                ? const Text('No data available')
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            int? stepsIdx =
                                snapshot.data?[index].legs?.first.steps?.length;
                            int i = 0;
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (i = 0; i < stepsIdx!; i++) ...[
                                      if (snapshot
                                              .data?[index]
                                              .legs
                                              ?.first
                                              .steps?[i]
                                              .transit
                                              ?.line
                                              ?.vehicle
                                              ?.icon ==
                                          null)
                                        const Icon(Icons.directions_walk)
                                      else
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                Text(
                                    "${snapshot.data?[index].legs?.first.departureTime?.text} - ${snapshot.data?[index].legs?.first.arrivalTime?.text}"),
                                Text(
                                    "${snapshot.data?[index].legs?.first.distance?.text}"),
                                Text(
                                    "${snapshot.data?[index].legs?.first.duration?.text}"),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                      ],
                    ),
                  );
          } else {
            return const Text('No data available');
          }
        },
      ),
    );
  }
}
