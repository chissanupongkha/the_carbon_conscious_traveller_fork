import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the_carbon_conscious_traveller/models/marker_model.dart';
import 'package:provider/provider.dart';

class MarkerWidget extends StatelessWidget {
  const MarkerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final markerModel = Provider.of<MarkerModel>(context, listen: false);

    return Container(
        //child: markerModel.addMarker(
        // position: LatLng(-33.83312702503771, 151.0854297797668),
        // markerId: 'marker1',
        //),
        );
  }
}
