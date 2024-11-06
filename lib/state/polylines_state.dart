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
  String _mode = '';
  int _activeRouteIndex = 0;
  final List<num> _distances = [];
  final List<String> _distanceTexts = [];
  final List<String> _durationTexts = [];
  final List<String> _routeSummary = [];
  int _carActiveRouteIndex = 0;
  int _motorcycleActiveRouteIndex = 0;
  int _transitActiveRouteIndex = 0;
  RoutesModel? routesModel;
  List<DirectionsRoute>? routes = [];
  List<DirectionsRoute> resultForPrivateVehicle = [];

  poly.PolylinePoints get polylinePoints => _polylinePoints;
  Map<PolylineId, Polyline> get polylines => _polylines;
  List<List<LatLng>> get routeCoordinates => _routeCoordinates;
  String get mode => _mode;
  int get activeRouteIndex => _activeRouteIndex;
  List<num> get distances => _distances;
  List<String> get distanceTexts => _distanceTexts;
  List<String> get durationTexts => _durationTexts;
  List<String> get routeSummary => _routeSummary;
  int get carActiveRouteIndex => _carActiveRouteIndex;
  int get motorcycleActiveRouteIndex => _motorcycleActiveRouteIndex;
  int get transitActiveRouteIndex => _transitActiveRouteIndex;

  static const Map<String, TravelMode> _modeMap = {
    'driving': TravelMode.driving,
    'motorcycling': TravelMode.driving,
    'transit': TravelMode.transit,
    'flying': TravelMode.walking, // This should be flying
  };

  set transportMode(String mode) {
    _transportMode = _modeMap[mode]!;
    _mode = mode;
    notifyListeners();
  }

  void resetPolyline() {
    _routeCoordinates.clear();
    notifyListeners();
  }

  Future<void> getPolyline(List<LatLng> coordinates) async {
    resetPolyline();

    Future<List<DirectionsRoute>> fetchRouteInfo() async {
      routesModel = RoutesModel(
        origin: GeoCoord(coordinates[0].latitude, coordinates[0].longitude),
        destination:
            GeoCoord(coordinates[1].latitude, coordinates[1].longitude),
        travelMode: _transportMode,
      );
      routes = await routesModel?.getRouteInfo();
      if (routes == null) {
        return [];
      } else {
        return routes!;
      }
    }

    // This result is used to render polylines
    // and to get route info such as distance, duration, summary
    result = await fetchRouteInfo();

    // This result is used to retrieve the correct array length for driving mode
    // so that the app doesn't crash when switching from transit mode to car or motorcycle mode
    // (used in vehicle_settings_motorcyle.dart and vehicle_settings_dar.dart)
    // It appears that the above request does not get enough time to
    // complete when switching back to car or driving mode
    if (_transportMode == TravelMode.driving) {
      resultForPrivateVehicle = await fetchRouteInfo();
    }

    if (result.isNotEmpty) {
      for (int i = 0; i < result.length; i++) {
        List<LatLng> routeCoordinate = [];

        if (result[i].overviewPolyline!.points!.isEmpty) {
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
      PolylineId id = PolylineId('poly$i');
      Polyline polyline = Polyline(
        polylineId: id,
        color: i == _activeRouteIndex
            ? const Color.fromARGB(255, 40, 33, 243)
            : const Color.fromARGB(255, 136, 136, 136),
        points: routeCoordinates[i],
        width: i == _activeRouteIndex ? 7 : 5,
        zIndex: i == _activeRouteIndex ? 1 : 0, // Put active route on top
        geodesic: true,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        consumeTapEvents: true,
        onTap: () => setActiveRoute(i),
      );
      polylines[id] = polyline;
      getDistanceValues();
      getDurationValues();
      getDistanceTexts();
      getDurationTexts();
      getRouteSummary();
    }

    notifyListeners();
  }

  void setActiveRoute(int index) {
    if (index >= 0 && index < _routeCoordinates.length) {
      if (_mode == 'driving') {
        _carActiveRouteIndex = index;
        _updateActiveRoute(_carActiveRouteIndex);
      } else if (_mode == 'motorcycling') {
        _motorcycleActiveRouteIndex = index;
        _updateActiveRoute(_motorcycleActiveRouteIndex);
      } else if (_mode == 'transit') {
        _transitActiveRouteIndex = index;
        _updateActiveRoute(_transitActiveRouteIndex);
      }
    }
    getDistanceValues();
    getDurationValues();
    getDistanceTexts();
    getDurationTexts();
    getRouteSummary();
  }

  int getActiveRoute() {
    if (_mode == 'driving') {
      return _carActiveRouteIndex;
    } else if (_mode == 'motorcycling') {
      return _motorcycleActiveRouteIndex;
    } else if (_mode == 'transit') {
      return _transitActiveRouteIndex;
    } else {
      return _activeRouteIndex;
    }
  }

  void getDistanceValues() {
    if (result.isNotEmpty && _distances.length < result.length) {
      for (var route in result) {
        distances.add(route.legs!.first.distance!.value ?? 0);
      }
    } else {
      "No results";
    }
  }

  void getDistanceTexts() {
    if (result.isNotEmpty && _distanceTexts.length < result.length) {
      for (var route in result) {
        distanceTexts.add(route.legs!.first.distance!.text!);
      }
    } else {
      "No results";
    }
  }

  void getDurationValues() {
    List<num> duration = [];
    if (result.isNotEmpty && _distanceTexts.length < result.length) {
      for (var route in result) {
        duration.add(route.legs!.first.duration!.value!);
      }
    } else {
      "No results";
    }
  }

  void getDurationTexts() {
    if (result.isNotEmpty && _durationTexts.length < result.length) {
      for (var route in result) {
        _durationTexts.add(route.legs!.first.duration!.text!);
      }
    } else {
      "No results";
    }
  }

  void getRouteSummary() {
    if (result.isNotEmpty) {
      for (var route in result) {
        _routeSummary.add(route.summary!);
      }
    } else {
      "No results";
    }
  }
}
