import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the_carbon_conscious_traveller/constants.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => GoogleMapViewState();
}

class GoogleMapViewState extends State<GoogleMapView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Marker> markers = {};

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kDestinantion = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.42796133580664, -122.097899799974),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: _onMapCreated,
          markers: markers,
          polylines: Set<Polyline>.of(polylines.values)),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    _getPolyline();
    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId('marker1'),
          position: LatLng(
              _kGooglePlex.target.latitude, _kGooglePlex.target.longitude),
          infoWindow: const InfoWindow(title: 'San Francisco'),
        ),
      );
      markers.add(const Marker(
        markerId: MarkerId('marker2'),
        position: LatLng(37.42796133580664, -122.097899799974),
        infoWindow: InfoWindow(title: 'Mountain View'),
      ));
    });
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
            _kGooglePlex.target.latitude, _kGooglePlex.target.longitude),
        destination: PointLatLng(
            _kDestinantion.target.latitude, _kDestinantion.target.longitude),
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
