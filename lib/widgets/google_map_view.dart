import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:the_carbon_conscious_traveller/helpers/map_service.dart';
import 'package:the_carbon_conscious_traveller/state/marker_state.dart';
import 'package:the_carbon_conscious_traveller/state/polylines_state.dart';
import 'package:provider/provider.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => GoogleMapViewState();
}

class GoogleMapViewState extends State<GoogleMapView> {
  Set<Marker> markers = {};

  static const CameraPosition _originPlace = CameraPosition(
    target: LatLng(-26.853387500000004,
        133.27515449999999), // Australia in lieu of user location
    zoom: 3.4746,
  );

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  @override
  Widget build(BuildContext context) {
    final markerModel = Provider.of<MarkerState>(context);
    final polylineModel = Provider.of<PolylinesState>(context);
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _originPlace,
        onMapCreated: (GoogleMapController controller) {
          MapService().setController(controller);
        },
        markers: markerModel.markers,
        polylines: Set<Polyline>.of(polylineModel.polylines.values),
      ),
    );
  }

  // void _onMapCreated(GoogleMapController controller) async {
  //   _controller.complete(controller);
  // }
}
