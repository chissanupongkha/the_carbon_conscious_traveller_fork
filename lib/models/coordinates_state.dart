import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CoordinatesState with ChangeNotifier {
  final List<LatLng> _coordinates = [];

  List<LatLng> get coordinates => _coordinates;

  void saveCoordinates(LatLng coordinate) {
    coordinates.add(coordinate);
    notifyListeners();
  }
}
