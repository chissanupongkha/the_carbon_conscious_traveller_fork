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

  String? _predictLastText; // Last text used for prediction
  String fieldType = ""; // Origin or destination
  final List<String> _countries = ['au']; // Preset countries
  List<AutocompletePrediction>? _predictions; // Predictions
  bool _predicting = false; // Predicting state
  dynamic _predictErr; // Prediction error

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
      const Image(
        image: FlutterGooglePlacesSdk.ASSET_POWERED_BY_GOOGLE_ON_WHITE,
      ),
    ];
  }

  //Save the last text input and the field type
  void _onPredictTextChanged(String value, String field) async {
    print("text changed: $value");
    _predictLastText = value;
    fieldType = field;
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
}
