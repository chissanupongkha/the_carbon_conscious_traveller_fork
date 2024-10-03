import 'package:flutter/material.dart';

class Transit extends StatefulWidget {
  const Transit({super.key});

  @override
  State<Transit> createState() => _TransitState();
}

class _TransitState extends State<Transit> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Place holder for transit data"),
        ],
      ),
    );
  }
}
