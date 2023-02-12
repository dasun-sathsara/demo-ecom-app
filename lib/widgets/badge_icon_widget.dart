import 'package:flutter/material.dart';

class BadgeIcon extends StatelessWidget {
  final int value;
  final Widget child;
  const BadgeIcon({super.key, required this.value, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          child: child,
        ),
        Positioned(
            right: 4,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(3),
              constraints: const BoxConstraints(minHeight: 16, minWidth: 16),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Center(child: Text(value.toString(), style: const TextStyle(fontSize: 12, color: Colors.white))),
            ))
      ],
    );
  }
}
