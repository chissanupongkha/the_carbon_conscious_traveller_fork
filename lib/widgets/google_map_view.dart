import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:the_carbon_conscious_traveller/models/marker_model.dart';
import 'package:the_carbon_conscious_traveller/models/routes_model.dart';
import 'package:provider/provider.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => GoogleMapViewState();
}

class GoogleMapViewState extends State<GoogleMapView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Marker> markers = {};

  static const CameraPosition _originPlace = CameraPosition(
    target: LatLng(-33.83312702503771, 151.0854297797668),
    zoom: 14.4746,
  );

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  @override
  Widget build(BuildContext context) {
    final markerModel = Provider.of<MarkerModel>(context);
    final polylineModel = Provider.of<RoutesModel>(context);
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _originPlace,
        onMapCreated: _onMapCreated,
        markers: markerModel.markers,
        polylines: Set<Polyline>.of(polylineModel.polylines.values),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
  }
}
