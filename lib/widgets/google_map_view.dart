import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:the_carbon_conscious_traveller/constants.dart';

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

  /// LatLng is included in google_maps_flutter
  List<LatLng> points = [
    LatLng(_kGooglePlex.target.latitude, _kGooglePlex.target.longitude),
    LatLng(_kDestinantion.target.latitude, _kDestinantion.target.longitude),
  ];

  MapsRoutes route = MapsRoutes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: _onMapCreated,
        markers: markers,
        polylines: route.routes,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    // Add route to map
    await route.drawRoute(points, "test route",
        const Color.fromRGBO(130, 78, 210, 1.0), Constants.googleApiKey,
        travelMode: TravelModes.driving);
    //Display markers
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
}
