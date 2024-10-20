import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CoordinatesState with ChangeNotifier {
  final List<LatLng> _coordinates = [];
  LatLng _originCoords = const LatLng(0, 0);
  LatLng _destinationCoords = const LatLng(0, 0);

  List<LatLng> get coordinates => _coordinates;
  LatLng get originCoords => _originCoords;
  LatLng get destinationCoords => _destinationCoords;

  void saveCoordinates(LatLng coordinate) {
    coordinates.add(coordinate);
    notifyListeners();
  }

  void saveOriginCoords(LatLng coordinate) {
    _originCoords = coordinate;
    coordinates.add(coordinate);
    notifyListeners();
  }

  void saveDestinationCoords(LatLng coordinate) {
    _destinationCoords = coordinate;
    coordinates.add(coordinate);
    notifyListeners();
  }
}
