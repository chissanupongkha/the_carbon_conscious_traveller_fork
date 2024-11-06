import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  static final MapService _instance = MapService._internal();

  factory MapService() {
    return _instance;
  }

  MapService._internal();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Future<void> goToLocation(BuildContext context, LatLng coords) async {
    if (!context.mounted) return;

    final GoogleMapController controller = await _controller.future;

    if (!context.mounted) return;

    await controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            coords.latitude,
            coords.longitude,
          ),
          zoom: 12.0,
        ),
      ),
    );
  }

  void setController(GoogleMapController controller) {
    _controller.complete(controller);
  }
}
