import 'package:flutter/material.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
        ),
        padding: const EdgeInsets.all(10.0),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white, // Optionally set icon color
        ),
      ),
    );
  }
}
