import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as places;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the_carbon_conscious_traveller/constants.dart';
import 'package:the_carbon_conscious_traveller/models/marker_model.dart';
import 'package:the_carbon_conscious_traveller/models/coordinates_model.dart';
import 'package:provider/provider.dart';
import 'package:the_carbon_conscious_traveller/models/polyline_model.dart';
import 'package:the_carbon_conscious_traveller/widgets/transport_mode.dart';
import 'package:the_carbon_conscious_traveller/widgets/vehicle_settings_car.dart';

class GooglePlacesView extends StatefulWidget {
  const GooglePlacesView({super.key});

  @override
  State<GooglePlacesView> createState() => _GooglePlacesViewState();
}

class _GooglePlacesViewState extends State<GooglePlacesView> {
  late final places.FlutterGooglePlacesSdk _places;
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  PolylinePoints polylinePoints = PolylinePoints();

  places.Place? origin; //starting location
  places.Place? destination; //end location
  places.LatLng? originLatLng; //starting coordinates
  places.LatLng? destinationLatLng; //end coordinates
  String? _predictLastText; // Last text used for prediction
  String fieldType = ""; // Origin or destination
  final List<String> _countries = ['au']; // Preset countries
  List<places.AutocompletePrediction>? _predictions; // Predictions
  bool _predicting = false; // Predicting state
  bool _fetchingPlace = false; // Fetching place state
  dynamic _fetchingPlaceErr; // Fetching place error
  dynamic _predictErr; // Prediction error

  // Place fields to fetch when a prediction is clicked
  final List<places.PlaceField> _placeFields = [
    places.PlaceField.Address,
    places.PlaceField.Location,
    // PlaceField.AddressComponents,
    // PlaceField.BusinessStatus,
    // PlaceField.Id,
    // PlaceField.Location,
    // PlaceField.Name,
    // PlaceField.OpeningHours,
    // PlaceField.PhoneNumber,
    // PlaceField.PhotoMetadatas,
    // PlaceField.PlusCode,
    // PlaceField.PriceLevel,
    // PlaceField.Rating,
    // PlaceField.Types,
    // PlaceField.UserRatingsTotal,
    // PlaceField.UTCOffset,
    // PlaceField.Viewport,
    // PlaceField.WebsiteUri,
  ];

  @override
  void initState() {
    super.initState();

    const googleApiKey = Constants.googleApiKey;
    const initialLocale = Constants.initialLocale;

    // Initialize Google Places API
    _places =
        places.FlutterGooglePlacesSdk(googleApiKey, locale: initialLocale);
    _places.isInitialized().then((value) {
      debugPrint('Places Initialised: $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    final predictionsWidgets = _buildPredictionWidgets();

    return Center(
      child: Column(
        children: [
          ...predictionsWidgets,
        ],
      ),
    );
  }

  List<Widget> _buildPredictionWidgets() {
    return [
      Container(
        color: Colors.white,
        child: Column(
          children: [
            TextFormField(
              controller: originController,
              onChanged: (value) => _onPredictTextChanged(value, "start"),
              decoration:
                  const InputDecoration(label: Text("Enter a start location")),
            ),
            TextFormField(
              controller: destinationController,
              onChanged: (value) => _onPredictTextChanged(value, "destination"),
              decoration: const InputDecoration(
                label: Text("Enter a destination"),
              ),
            ),
          ],
        ),
      ),
      Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: (_predictions ?? [])
              .map(_buildPredictionItem)
              .toList(growable: false),
        ),
      ),
      const TransportMode(),
      const Image(
        image: places.FlutterGooglePlacesSdk.ASSET_POWERED_BY_GOOGLE_ON_WHITE,
      ),
      _buildErrorWidget(_fetchingPlaceErr),
      _buildErrorWidget(_predictErr),
    ];
  }

  Widget _buildPredictionItem(places.AutocompletePrediction item) {
    return InkWell(
      onTap: () => _onItemClicked(item),
      child: Column(children: [
        Text(item.fullText),
        const Divider(thickness: 2),
      ]),
    );
  }

  Widget _buildErrorWidget(dynamic err) {
    final theme = Theme.of(context);
    final errorText = err == null ? '' : err.toString();
    return Text(errorText,
        style: theme.textTheme.bodySmall
            ?.copyWith(color: theme.colorScheme.error));
  }

  //Save the last text input and the field type
  void _onPredictTextChanged(String value, String field) async {
    print("text changed: $value");
    _predictLastText = value;
    fieldType = field;

    _predict();
  }

  //Predict the last text input
  void _predict() async {
    if (_predicting) {
      return;
    }

    final hasContent = _predictLastText?.isNotEmpty ?? false;

    setState(() {
      _predicting = hasContent;
      _predictErr = null;
    });

    if (!hasContent) {
      return;
    }

    try {
      final result = await _places.findAutocompletePredictions(
        _predictLastText!,
        countries: _countries,
        newSessionToken: false,
      );

      setState(() {
        _predictions = result.predictions;
        _predicting = false;
      });
    } catch (err) {
      setState(() {
        _predictErr = err;
        _predicting = false;
      });
    }
    print("Predictions: $_predictions");
  }

  //When a predicted item is clicked, fetch the place details
  void _onItemClicked(places.AutocompletePrediction item) async {
    print("item: ${item.fullText}");

    if (_fetchingPlace) {
      return; // Fetching in progress
    }

    try {
      final result =
          await _places.fetchPlace(item.placeId, fields: _placeFields);

      if (fieldType == "start") {
        originController.text = item.fullText;

        setState(() {
          origin = result.place;
          _fetchingPlace = false;
          originLatLng = origin?.latLng;
          _addOriginMarker(LatLng(originLatLng!.lat, originLatLng!.lng));
          _predictions = [];
        });
      } else if (fieldType == "destination") {
        destinationController.text = item.fullText;
        setState(() {
          destination = result.place;
          _fetchingPlace = false;
          destinationLatLng = destination?.latLng;
          _addDestinationMarker(
              LatLng(destinationLatLng!.lat, destinationLatLng!.lng));
          _predictions = [];
        });
        _showModalBottomSheet();
      }

      print("start: $origin");
      print("destination: $destination");
    } catch (err) {
      setState(() {
        _fetchingPlaceErr = err;
        _fetchingPlace = false;
      });
    }
  }

  void _addOriginMarker(LatLng originLatLng) {
    print("addOriginMarker reached!!! $originLatLng");

    LatLng position = originLatLng;
    final markerModel = Provider.of<MarkerModel>(context, listen: false);
    markerModel.addMarker(LatLng(position.latitude, position.longitude));

    final coordinatesModel =
        Provider.of<CoordinatesModel>(context, listen: false);
    coordinatesModel
        .saveCoordinates(LatLng(position.latitude, position.longitude));
  }

  void _addDestinationMarker(LatLng destinationLatLng) {
    print("addDestinationMarker reached!!! $destinationLatLng");
    LatLng position = destinationLatLng;

    final markerModel = Provider.of<MarkerModel>(context, listen: false);
    markerModel.addMarker(
      LatLng(position.latitude, position.longitude),
    );

    final coordinatesModel =
        Provider.of<CoordinatesModel>(context, listen: false);
    coordinatesModel.saveCoordinates(
      LatLng(position.latitude, position.longitude),
    );

    final polylineModel = Provider.of<PolylineModel>(context, listen: false);
    polylineModel.getPolyline(coordinatesModel.coordinates);
  }

  void _showModalBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return const CarSettings();
      },
    );
  }
}
