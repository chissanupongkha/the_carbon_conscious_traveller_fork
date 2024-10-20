import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the_carbon_conscious_traveller/constants.dart';

class PolylinesState extends ChangeNotifier {
  final PolylinePoints _polylinePoints = PolylinePoints();
  final Map<PolylineId, Polyline> _polylines = {};
  final List<List<LatLng>> _routeCoordinates = [];
  List<PolylineResult> result = [];
  TravelMode _transportMode = TravelMode.driving;
  String _mode = 'motorcycling';
  int _activeRouteIndex = 0;
  // List<int> distance = [];
  final List<int> _distances = [];
  final List<String> _distanceTexts = [];
  final List<String> _durationTexts = [];

  PolylinePoints get polylinePoints => _polylinePoints;
  Map<PolylineId, Polyline> get polylines => _polylines;
  List<List<LatLng>> get routeCoordinates => _routeCoordinates;
  String get mode => _mode;
  int get activeRouteIndex => _activeRouteIndex;
  List<int> get distances => _distances;
  List<String> get distanceTexts => _distanceTexts;
  List<String> get durationTexts => _durationTexts;

  static const Map<String, TravelMode> _modeMap = {
    'driving': TravelMode.driving,
    'motorcycling': TravelMode.driving, // This should be motorcycling
    'transit': TravelMode.transit,
    'flying': TravelMode.walking, // This should be flying
  };

  set transportMode(String mode) {
    _transportMode = _modeMap[mode]!;
    _mode = mode;
    print("Transport mode in model: ${_modeMap[mode]}");
    //resetPolyline();
    notifyListeners();
  }

  void resetPolyline() {
    print("Resetting polyline");
    _routeCoordinates.clear();
    _activeRouteIndex = 0;
    notifyListeners();
  }

  void getPolyline(List<LatLng> coordinates) async {
    print("Getting polyline...");
    print("Active route index: $_activeRouteIndex");

    resetPolyline();

    result = await polylinePoints.getRouteWithAlternatives(
      googleApiKey: Constants.googleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(coordinates[0].latitude, coordinates[0].longitude),
        destination:
            PointLatLng(coordinates[1].latitude, coordinates[1].longitude),
        mode: _modeMap[mode]!,
        alternatives: true,
      ),
    );
    if (result.isNotEmpty) {
      for (int i = 0; i < result.length; i++) {
        List<LatLng> routeCoordinate = [];

        for (var point in result[i].points) {
          routeCoordinate.add(LatLng(point.latitude, point.longitude));
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
        patterns: _mode == "transit" ? dashPattern : [],
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
    // getDistanceValues();
    // getDurationValues();
    // getDistanceTexts();
    // getDurationTexts();
  }

  void getDistanceValues() {
    if (result.isNotEmpty && _distances.length < result.length) {
      for (var route in result) {
        distances.add(route.distanceValues!.first);
      }
    } else {
      print("No results");
    }
  }

  void getDistanceTexts() {
    if (result.isNotEmpty && distanceTexts.length < result.length) {
      print("distance text length: ${distanceTexts.length}");
      print("result texts length: ${result.length}");
      for (var route in result) {
        distanceTexts.add(route.distanceTexts!.first);
        print("Distance text: ${route.distanceTexts!.first}");
        print("Distance text length: ${distanceTexts.length}");
      }
    } else {
      print("No results");
    }
  }

  void getDurationTexts() {
    if (result.isNotEmpty && _durationTexts.length < result.length) {
      for (var route in result) {
        _durationTexts.add(route.durationTexts!.first);
      }
    } else {
      print("No results");
    }
  }

  void getDurationValues() {
    List<int> duration = [];
    if (result.isNotEmpty && _distanceTexts.length < result.length) {
      for (var route in result) {
        duration.add(route.durationValues!.first);
      }
    } else {
      print("No results");
    }
    print("Duration: $duration");
  }
}
