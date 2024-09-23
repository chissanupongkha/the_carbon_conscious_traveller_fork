import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the_carbon_conscious_traveller/constants.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';
import 'package:the_carbon_conscious_traveller/models/marker_model.dart';

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

  static const CameraPosition _destinationPlace = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-33.8271275189807, 151.08711818603933),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MarkerModel>(
        builder: (context, markerModel, child) {
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _originPlace,
            onMapCreated: _onMapCreated,
            markers: markerModel.markers,
            polylines: Set<Polyline>.of(polylines.values),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Provider.of<MarkerModel>(context, listen: false).addMarker();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    _getPolyline();
  }

  _drawPolyline() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 5);
    polylines[id] = polyline;
    setState(() {/*the polyline is drawn*/});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: Constants.googleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(
            _originPlace.target.latitude, _originPlace.target.longitude),
        destination: PointLatLng(_destinationPlace.target.latitude,
            _destinationPlace.target.longitude),
        mode: TravelMode.driving,
      ),
    );
    if (result.points.isNotEmpty) {
      for (PointLatLng point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    _drawPolyline();
  }
}
