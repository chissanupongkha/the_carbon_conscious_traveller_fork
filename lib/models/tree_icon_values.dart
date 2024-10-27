enum TreeIconType {
  defaultOneLeafC02Gram,
  defaultFourLeavesC02Gram,
  defaultTreeBranchC02Gram,
  defaultTreeCo2Gram,
}

extension TreeIconTypeExtension on TreeIconType {
  double get value {
    switch (this) {
      case TreeIconType.defaultOneLeafC02Gram:
        return 100;
      case TreeIconType.defaultFourLeavesC02Gram:
        return 1000;
      case TreeIconType.defaultTreeBranchC02Gram:
        return 5000;
      case TreeIconType.defaultTreeCo2Gram:
        return 29000;
      default:
        return 0.0;
    }
  }
}

extension TreeIconName on TreeIconType {
  String get name {
    switch (this) {
      case TreeIconType.defaultOneLeafC02Gram:
        return "leaf2.png";
      case TreeIconType.defaultFourLeavesC02Gram:
        return "four_leaves1.png";
      case TreeIconType.defaultTreeBranchC02Gram:
        return "tree_branch3.png";
      case TreeIconType.defaultTreeCo2Gram:
        return "tree2.png";
      default:
        return "";
    }
  }
}
