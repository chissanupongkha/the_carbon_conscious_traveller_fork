import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:the_carbon_conscious_traveller/constants.dart';
import 'dart:core';

class GooglePlacesView extends StatefulWidget {
  const GooglePlacesView({super.key});

  @override
  State<GooglePlacesView> createState() => _GooglePlacesViewState();
}

class _GooglePlacesViewState extends State<GooglePlacesView> {
  late final FlutterGooglePlacesSdk _places;
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  Place? origin; //starting location
  Place? destination; //end location
  String? _predictLastText; // Last text used for prediction
  String fieldType = ""; // Origin or destination
  final List<String> _countries = ['au']; // Preset countries
  List<AutocompletePrediction>? _predictions; // Predictions
  bool _predicting = false; // Predicting state
  bool _fetchingPlace = false; // Fetching place state
  dynamic _fetchingPlaceErr; // Fetching place error
  dynamic _predictErr; // Prediction error

  // Place fields to fetch when a prediction is clicked
  final List<PlaceField> _placeFields = [
    PlaceField.Address,
    PlaceField.AddressComponents,
    PlaceField.BusinessStatus,
    PlaceField.Id,
    PlaceField.Location,
    PlaceField.Name,
    PlaceField.OpeningHours,
    PlaceField.PhoneNumber,
    PlaceField.PhotoMetadatas,
    PlaceField.PlusCode,
    PlaceField.PriceLevel,
    PlaceField.Rating,
    PlaceField.Types,
    PlaceField.UserRatingsTotal,
    PlaceField.UTCOffset,
    PlaceField.Viewport,
    PlaceField.WebsiteUri,
  ];

  @override
  void initState() {
    super.initState();

    const googleApiKey = Constants.googleApiKey;
    const initialLocale = Constants.initialLocale;

    // Initialize Google Places API
    _places = FlutterGooglePlacesSdk(googleApiKey, locale: initialLocale);
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
          ElevatedButton(
            onPressed: () async {
              _predict();
            },
            child: Text('Predict and print to console'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPredictionWidgets() {
    return [
      // --
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
      Column(
        mainAxisSize: MainAxisSize.min,
        children: (_predictions ?? [])
            .map(_buildPredictionItem)
            .toList(growable: false),
      ),
      const Image(
        image: FlutterGooglePlacesSdk.ASSET_POWERED_BY_GOOGLE_ON_WHITE,
      ),
    ];
  }

  Widget _buildPredictionItem(AutocompletePrediction item) {
    return InkWell(
      onTap: () => _onItemClicked(item),
      child: Column(children: [
        Text(item.fullText),
        const Divider(thickness: 2),
      ]),
    );
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
  void _onItemClicked(AutocompletePrediction item) async {
    print("item: ${item.fullText}");

    try {
      final result =
          await _places.fetchPlace(item.placeId, fields: _placeFields);

      if (fieldType == "start") {
        originController.text = item.fullText;

        setState(() {
          origin = result.place;
          _fetchingPlace = false;
        });
      } else if (fieldType == "destination") {
        destinationController.text = item.fullText;
        setState(() {
          destination = result.place;
          _fetchingPlace = false;
        });
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
}
