import 'package:flutter/material.dart';

class LeadButton extends StatelessWidget {
  final void Function()? onTap;
  const LeadButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(Icons.event_available_rounded),
    );
  }
}