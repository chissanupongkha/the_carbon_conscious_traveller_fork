import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the_carbon_conscious_traveller/constants.dart';

class PolylineModel extends ChangeNotifier {
  final PolylinePoints _polylinePoints = PolylinePoints();
  final Map<PolylineId, Polyline> _polylines = {};
  final List<List<LatLng>> _routeCoordinates = [];
  TravelMode _transportMode = TravelMode.driving;
  String _mode = 'driving';
  int _activeRouteIndex = 0;

  PolylinePoints get polylinePoints => _polylinePoints;
  Map<PolylineId, Polyline> get polylines => _polylines;
  List<List<LatLng>> get routeCoordinates => _routeCoordinates;
  String get mode => _mode;
  int get activeRouteIndex => _activeRouteIndex;

  static const Map<String, TravelMode> _modeMap = {
    'driving': TravelMode.driving,
    'motorcycling': TravelMode.driving, // This should be motorcycling
    'transit': TravelMode.transit,
    'flying': TravelMode.walking, // This should be flying
  };

  set transportMode(String mode) {
    _transportMode = _modeMap[mode]!;
    _mode = mode;
    print("Transport mode in model: $_transportMode");
    resetPolyline();
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

    List<PolylineResult> result = await polylinePoints.getRouteWithAlternatives(
      googleApiKey: Constants.googleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(coordinates[0].latitude, coordinates[0].longitude),
        destination:
            PointLatLng(coordinates[1].latitude, coordinates[1].longitude),
        mode: _transportMode,
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
      _updateActiveRoute(0);
    }
    notifyListeners();
  }

  void _updateActiveRoute(int index) {
    _activeRouteIndex = index;
    polylines.clear();

    for (int i = 0; i < routeCoordinates.length; i++) {
      PolylineId id = PolylineId('poly$i');
      Polyline polyline = Polyline(
        polylineId: id,
        color: i == activeRouteIndex ? Colors.blue : Colors.grey,
        points: routeCoordinates[i],
        width: i == activeRouteIndex ? 5 : 3,
        zIndex: i == _activeRouteIndex ? 1 : 0, // Put active route on top
        consumeTapEvents: true,
        onTap: () => setActiveRoute(i),
      );
      polylines[id] = polyline;
    }
    notifyListeners();
  }

  void setActiveRoute(int index) {
    if (index >= 0 && index < _routeCoordinates.length) {
      _updateActiveRoute(index);
    }
  }
}
