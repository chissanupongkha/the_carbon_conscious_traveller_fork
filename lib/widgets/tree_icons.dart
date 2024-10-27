import 'package:flutter/material.dart';

class TreeIcons extends StatelessWidget {
  const TreeIcons({super.key, required this.treeIconName});

  final List treeIconName;

  @override
  Widget build(BuildContext context) {
    print('tree icons treeIconName $treeIconName');
    return Row(
      children: [
        for (String treeIcon in treeIconName)
          Image.asset(
            'assets/icons/$treeIcon',
            width: 40,
            height: 40,
          ),
      ],
    );
  }
}
