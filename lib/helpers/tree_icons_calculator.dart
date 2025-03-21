import 'dart:math';
import 'package:the_carbon_conscious_traveller/data/tree_icon_values.dart';

List<String> upDateTreeIcons(List<int> emissionValues, index) {
  if (emissionValues.length <= 1) {
    return [];
  }

  int maxEmission = emissionValues.reduce(max);
  int baseTreeIconValue = TreeIconType.defaultOneLeafC02Gram.value.toInt();
  List<String> treeIconName = [];

  if (emissionValues.isEmpty) {
    return [];
  }
  var dividend = maxEmission - emissionValues[index];

  // Show nothing for no reduction in emissions
  if (dividend == 0.0 || dividend < 0.0) {
    return [];
  }

  if (dividend < baseTreeIconValue) {
    treeIconName.add(TreeIconType.defaultOneLeafC02Gram.name);
    //continue;
  }

  List<TreeIconType> iconValues = TreeIconType.values;
  iconValues = iconValues.reversed
      .toList(); // for some reason the Android version has the icons in reverse order

  int count;
  for (int j = 0; j < TreeIconType.values.length; j++) {
    count = (dividend ~/
        iconValues[j].value.floor()); // ~/ is more efficient than /
    if (count >= 1) {
      String imageRes;
      switch (j) {
        case 0:
          imageRes = TreeIconType.defaultTreeCo2Gram.name;
          break;
        case 1:
          imageRes = TreeIconType.defaultTreeBranchC02Gram.name;
          break;
        case 2:
          imageRes = TreeIconType.defaultFourLeavesC02Gram.name;
          break;
        case 3:
          imageRes = TreeIconType.defaultOneLeafC02Gram.name;
          break;
        default:
          throw StateError("emissionIconValues add more checks");
      }
      for (int k = 0; k < count; k++) {
        treeIconName.add(imageRes);
      }
    }
    dividend %= iconValues[j].value.toInt();
  }
  return treeIconName;
}
