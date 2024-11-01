import 'package:flutter/material.dart';
import 'package:google_directions_api/google_directions_api.dart';

class TransitSteps extends StatelessWidget {
  const TransitSteps({super.key, required this.steps});

  final List<dynamic> steps;
  //final int stepsIdx;

  Color parseColor(String? colorString, Color defaultColor) {
    if (colorString != null) {
      return Color(int.parse(colorString.replaceAll('#', '0xff')));
    }
    return defaultColor;
  }

  Widget _buildStepIcon(dynamic step) {
    if (step.transit?.line?.vehicle?.icon == null &&
        step.travelMode == TravelMode.walking) {
      return const Icon(Icons.directions_walk);
    } else if (step.transit?.line?.vehicle?.localIcon != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Image.network(
                  "https:${step.transit?.line?.vehicle?.localIcon}",
                  width: 25),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: parseColor(step.transit?.line?.color, Colors.white),
              ),
              child: Text(
                "${step.transit?.line?.shortName}",
                style: TextStyle(
                    color: step.transit?.line?.textColor != null
                        ? parseColor(
                            step.transit?.line?.textColor, Colors.black)
                        : Colors.black,
                    backgroundColor: parseColor(
                      step.transit?.line?.color,
                      Colors.white,
                    )),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Image.network("https:${step.transit?.line?.vehicle?.icon}",
                  width: 25),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: parseColor(step.transit?.line?.color, Colors.white),
              ),
              child: Text(
                "${step.transit?.line?.shortName}",
                style: TextStyle(
                  color: step.transit?.line?.textColor != null
                      ? parseColor(step.transit?.line?.textColor, Colors.black)
                      : Colors.black,
                  backgroundColor:
                      parseColor(step.transit?.line?.color, Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stepIcons = [];
    for (var step in steps) {
      stepIcons.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Display arrow divider between steps
              if (steps.indexOf(step) != 0 &&
                  steps.indexOf(step) != steps.length)
                const Icon(Icons.arrow_forward_ios, size: 15),
              _buildStepIcon(step),
            ],
          ),
        ),
      );
    }
    return Wrap(
      children: [
        ...stepIcons,
      ],
    );
  }
}
