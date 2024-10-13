const List<String> carSizes = [
  "Small car",
  "Medium car",
  "Large car",
  "Mini",
  "Supermini",
  "Lower medium",
  "Upper medium",
  "Executive",
  "Luxury",
  "Sports",
  "Dual purpose 4X4",
  "MPV"
];

const List<String> carFuelTypes = [
  "Diesel",
  "Petrol",
  "Hybrid",
  "CNG",
  "LPG",
  "Plug-in Hybrid Electric Vehicle",
  "Battery Electric Vehicle"
];

const List<List<double>> carValuesMatrix = [
  [
    0.139306448880537,
    0.140798534228188,
    0.101498857718121,
    0.0,
    0.0,
    0.0540229932885906,
    0.0482282859060403
  ],
  [
    0.167156448880537,
    0.178188534228188,
    0.109038436241611,
    0.156604197315436,
    0.176070597315436,
    0.0850073342281879,
    0.0526663489932886
  ],
  [
    0.208586448880537,
    0.272238534228188,
    0.1524358,
    0.238454197315436,
    0.269140597315436,
    0.101584382550336,
    0.05737
  ],
  [
    0.107746448880537,
    0.130298534228188,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0443381932885906
  ],
  [
    0.132146448880537,
    0.141688534228188,
    0.0,
    0.0,
    0.0,
    0.0540229932885906,
    0.0490671785234899
  ],
  [
    0.143456448880537,
    0.164728534228188,
    0.0,
    0.0,
    0.0,
    0.0831183489932886,
    0.0525663489932886
  ],
  [
    0.160496448880537,
    0.192108534228188,
    0.0,
    0.0,
    0.0,
    0.0868662268456376,
    0.0547703154362416
  ],
  [
    0.173096448880537,
    0.212318534228188,
    0.0,
    0.0,
    0.0,
    0.0888617973154363,
    0.0500662563758389
  ],
  [
    0.211196448880537,
    0.318088534228188,
    0.0,
    0.0,
    0.0,
    0.115139275167785,
    0.0583732120805369
  ],
  [
    0.169436448880537,
    0.237158534228188,
    0.0,
    0.0,
    0.0,
    0.0996696416107383,
    0.0834804456375839
  ],
  [
    0.201946448880537,
    0.204048534228188,
    0.0,
    0.0,
    0.0,
    0.103275582550336,
    0.0610424751677852
  ],
  [
    0.176596448880537,
    0.184258534228188,
    0.0,
    0.0,
    0.0,
    0.0990220751677852,
    0.0793324751677852
  ]
];

// const List<String> motorcycleSizes = ["Small", "Medium", "Large"];
// const Map<String, double> motorcycleValueMap = {
//   "Small": 0.0831851865771812,
//   "Medium": 0.10107835704698,
//   "Large": 0.13251915704698
// };

//Set up MotorcycleSize class
enum MotorcycleSize {
  small,
  medium,
  large,
  label,
}

extension MotorcycleSizeExtension on MotorcycleSize {
  String get name {
    switch (this) {
      case MotorcycleSize.small:
        return "Small";
      case MotorcycleSize.medium:
        return "Medium";
      case MotorcycleSize.large:
        return "Large";
      default:
        return "Size";
    }
  }
}

extension MotorcycleValues on MotorcycleSize {
  double get value {
    switch (this) {
      case MotorcycleSize.small:
        return 0.0831851865771812;
      case MotorcycleSize.medium:
        return 0.10107835704698;
      case MotorcycleSize.large:
        return 0.13251915704698;
      default:
        return 0.0;
    }
  }
}

// final List<MotorcycleSize> motorcycleSizes = [
//   MotorcycleSize.small,
//   MotorcycleSize.medium,
//   MotorcycleSize.large,
//   MotorcycleSize.label,
// ];

// final Map<String, double> motorcycleValueMap = {
//   "Small": 0.0831851865771812,
//   "Medium": 0.10107835704698,
//   "Large": 0.13251915704698
// };

const List<String> busTypes = ["Average local bus", "Coach", "Trolleybus"];
const Map<String, double> busValueMap = {
  "Average local bus": 0.102150394630872,
  "Coach": 0.0271814013422819,
  "Trolleybus": 0.00699
};

const List<String> railTypes = [
  "National rail",
  "Light rail and tram",
  "London Underground"
];
const Map<String, double> railValueMap = {
  "National rail": 0.0354629637583893,
  "Light rail and tram": 0.028603267114094,
  "London Underground": 0.027802067114094
};

const List<String> ferryTypes = [
  "Foot passenger",
  "Car passenger",
  "Average (all passenger)"
];
const Map<String, double> ferryValueMap = {
  "Foot passenger": 0.0187108139597315,
  "Car passenger": 0.129328875436242,
  "Average (all passenger)": 0.112698080805369
};

// CO2e kg/km per passenger
const double cableCarValue = 0.0269;
const double trolleybusValue = 0.00699;

double getPublicFactor(String vehicleTypeString) {
  try {
    switch (vehicleTypeString) {
      case 'BUS':
        return busValueMap["Average local bus"]!;
      case 'INTERCITY_BUS':
        return busValueMap["Coach"]!;
      case 'HEAVY_RAIL':
      case 'HIGH_SPEED_TRAIN':
      case 'LONG_DISTANCE_TRAIN':
        return railValueMap["National rail"]!;
      case 'COMMUTER_TRAIN':
      case 'METRO_RAIL':
      case 'MONORAIL':
      case 'RAIL':
      case 'TRAM':
        return railValueMap["Light rail and tram"]!;
      case 'SUBWAY':
        return railValueMap["London Underground"]!;
      case 'FERRY':
        return ferryValueMap["Foot passenger"]!;
      case 'TROLLEYBUS':
        return trolleybusValue;
      case 'CABLE_CAR':
        return cableCarValue;
      default:
        return 0.0;
    }
  } catch (e) {
    return 0.0;
  }
}
