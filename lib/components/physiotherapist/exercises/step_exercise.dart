import 'dart:math' as math;

import 'package:flutter/material.dart';

class StepExercise extends StatelessWidget {
  final int indexStep;
  final String titleStep;
  final String subtitleStep;
  const StepExercise({
    super.key,
    required this.indexStep,
    required this.subtitleStep,
    required this.titleStep,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                indexStep.toString(),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily:
                        Theme.of(context).textTheme.labelLarge?.fontFamily,
                    color: Theme.of(context).colorScheme.primary),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationZ(math.pi / -2),
                  child: SizedBox(
                    child: Icon(
                      Icons.circle_outlined,
                      size: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationZ(math.pi / -2),
                  child: SizedBox(
                    child: Icon(
                      Icons.linear_scale_sharp,
                      size: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      title: Text(
        titleStep,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          fontFamily: Theme.of(context).textTheme.titleSmall?.fontFamily,
        ),
      ),
      subtitle: Text(
        subtitleStep,
        style: Theme.of(context).textTheme.labelMedium,
        textAlign: TextAlign.justify,
      ),
    );
  }
}
