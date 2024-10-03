import 'package:flutter/material.dart';

class Flying extends StatefulWidget {
  const Flying({super.key});

  @override
  State<Flying> createState() => _FlyingState();
}

class _FlyingState extends State<Flying> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Place holder for flight settings"),
        ],
      ),
    );
  }
}
