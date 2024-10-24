import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as poly;
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the_carbon_conscious_traveller/models/routes_model.dart';

class PolylinesState extends ChangeNotifier {
  final poly.PolylinePoints _polylinePoints = poly.PolylinePoints();
  final Map<PolylineId, Polyline> _polylines = {};
  final List<List<LatLng>> _routeCoordinates = [];
  List<DirectionsRoute> result = [];
  TravelMode _transportMode = TravelMode.driving;
  String _mode = 'driving';
  int _activeRouteIndex = 0;
  final List<num> _distances = [];
  final List<String> _distanceTexts = [];
  final List<String> _durationTexts = [];

  RoutesModel? routesModel;

  List<DirectionsRoute>? routes = [];

  poly.PolylinePoints get polylinePoints => _polylinePoints;
  Map<PolylineId, Polyline> get polylines => _polylines;
  List<List<LatLng>> get routeCoordinates => _routeCoordinates;
  String get mode => _mode;
  int get activeRouteIndex => _activeRouteIndex;
  List<num> get distances => _distances;
  List<String> get distanceTexts => _distanceTexts;
  List<String> get durationTexts => _durationTexts;

  static const Map<String, TravelMode> _modeMap = {
    'driving': TravelMode.driving,
    'motorcycling': TravelMode.driving,
    'transit': TravelMode.transit,
    'flying': TravelMode.walking, // This should be flying
  };

  set transportMode(String mode) {
    _transportMode = _modeMap[mode]!;
    _mode = mode;
    debugPrint("Transport mode in model: ${_modeMap[mode]}");
    notifyListeners();
  }

  void resetPolyline() {
    debugPrint("Resetting polyline");
    _routeCoordinates.clear();
    _activeRouteIndex = 0;
    notifyListeners();
  }

  Future<void> getPolyline(List<LatLng> coordinates) async {
    debugPrint("Getting polyline...");
    debugPrint("Active route index: $_activeRouteIndex");

    resetPolyline();

    Future<List<DirectionsRoute>> fetchRouteInfo() async {
      debugPrint("request sent");
      routesModel = RoutesModel(
        origin: GeoCoord(coordinates[0].latitude, coordinates[0].longitude),
        destination:
            GeoCoord(coordinates[1].latitude, coordinates[1].longitude),
        travelMode: _transportMode,
      );
      debugPrint("request is about to return");
      routes = await routesModel?.getRouteInfo();
      debugPrint("routes $routes");
      if (routes == null) {
        return [];
      } else {
        return routes!;
      }
    }

    result = await fetchRouteInfo();

    if (result.isNotEmpty) {
      for (int i = 0; i < result.length; i++) {
        List<LatLng> routeCoordinate = [];

        if (result[i].overviewPolyline!.points!.isEmpty) {
          print("No points found");
          return;
        } else {
          List<LatLng> decodedPoints = _polylinePoints
              .decodePolyline(result[i].overviewPolyline!.points!)
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();
          routeCoordinate.addAll(decodedPoints);
        }
        routeCoordinates.add(routeCoordinate);
      }
    }
    _updateActiveRoute(_activeRouteIndex);
    notifyListeners();
  }

  void _updateActiveRoute(int index) {
    _activeRouteIndex = index;
    polylines.clear();

    for (int i = 0; i < result.length; i++) {
      List<PatternItem> dashPattern = [
        PatternItem.dash(10.0),
        PatternItem.gap(5.0),
      ];
      // this was (int i = 0; i < routeCoordinates.length.length; i++) {
      PolylineId id = PolylineId('poly$i');
      Polyline polyline = Polyline(
        polylineId: id,
        //color: i == activeRouteIndex ? Colors.blue : Colors.grey,
        //color: routeSegments[i].travelMode == 'WALKING' ? Colors.green : Colors.blue,
        color: i == activeRouteIndex ? Colors.blue : Colors.grey,
        patterns: result.first.legs?.first.steps?.first.travelMode.toString() ==
                "WALKING"
            ? dashPattern
            : [],
        points: routeCoordinates[i],
        width: i == activeRouteIndex ? 5 : 3,
        zIndex: i == _activeRouteIndex ? 1 : 0, // Put active route on top
        consumeTapEvents: true,
        onTap: () => setActiveRoute(i),
      );
      polylines[id] = polyline;
      getDistanceValues();
      getDurationValues();
      getDistanceTexts();
      getDurationTexts();
    }

    notifyListeners();
  }

  void setActiveRoute(int index) {
    if (index >= 0 && index < _routeCoordinates.length) {
      print("Setting active route to $index");
      _updateActiveRoute(index);
    }
    getDistanceValues();
    getDurationValues();
    getDistanceTexts();
    getDurationTexts();
  }

  void getDistanceValues() {
    print("Getting distance values");
    if (result.isNotEmpty && _distances.length < result.length) {
      for (var route in result) {
        distances.add(route.legs!.first.distance!.value ?? 0);
      }
    } else {
      print("No results");
    }
  }

  void getDistanceTexts() {
    if (result.isNotEmpty && _distanceTexts.length < result.length) {
      for (var route in result) {
        distanceTexts.add(route.legs!.first.distance!.text!);
      }
    } else {
      debugPrint("No results");
    }
  }

  void getDurationValues() {
    List<num> duration = [];
    if (result.isNotEmpty && _distanceTexts.length < result.length) {
      for (var route in result) {
        duration.add(route.legs!.first.duration!.value!);
      }
    } else {
      debugPrint("No results");
    }
    debugPrint("Duration: $duration");
  }

  void getDurationTexts() {
    if (result.isNotEmpty && _durationTexts.length < result.length) {
      for (var route in result) {
        _durationTexts.add(route.legs!.first.duration!.text!);
      }
    } else {
      debugPrint("No results");
    }
  }
}
