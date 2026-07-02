import 'package:flutter/material.dart';

class CheckInProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const CheckInProgressBar({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the encouragement message based on currentStep
    String message = '';
    if (currentStep == 1) {
      message = 'Magsisimula na tayo';
    } else if (currentStep == 2) {
      message = 'Kalahati na';
    } else if (currentStep == 3) {
      message = 'Halos tapos na';
    }

    final double progress = (currentStep / totalSteps).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Hakbang $currentStep ng $totalSteps',
              style: const TextStyle(
                fontFamily: 'Nunito Sans',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3E4947),
              ),
            ),
            Text(
              message,
              style: const TextStyle(
                fontFamily: 'Nunito Sans',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF005C55),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF005C55),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
