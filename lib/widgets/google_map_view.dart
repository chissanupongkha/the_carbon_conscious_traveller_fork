import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => GoogleMapViewState();
}

class GoogleMapViewState extends State<GoogleMapView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Marker> markers = {};

  Set<Polyline> polylines = {
    const Polyline(
      polylineId: PolylineId('route1'),
      points: [
        LatLng(37.42796133580664, -122.085749655962),
        LatLng(37.42796133580664, -122.100),
      ],
      geodesic: true,
      color: Colors.blue,
      width: 4,
    ),
  };

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kTestLocation = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: _onMapCreated,
        markers: markers,
        polylines: polylines,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToLocation,
        label: const Text('Go to test location'),
        icon: const Icon(Icons.location_on),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setState(() {
      markers.add(
        const Marker(
          markerId: MarkerId('marker1'),
          position: LatLng(37.42796133580664, -122.085749655962),
          infoWindow: InfoWindow(title: 'San Francisco'),
        ),
      );
      markers.add(const Marker(
        markerId: MarkerId('marker2'),
        position: LatLng(37.42796133580664, -122.100),
        infoWindow: InfoWindow(title: 'Mountain View'),
      ));
    });
  }

  Future<void> _goToLocation() async {
    final GoogleMapController controller = await _controller.future;
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_kTestLocation));
  }
}
