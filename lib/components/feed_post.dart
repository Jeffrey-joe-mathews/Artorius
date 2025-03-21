import 'package:flutter/material.dart';

class FeedPost extends StatelessWidget {
  final String message;
  final String user;
  final String time;
  const FeedPost({super.key, required this.message, required this.user, required this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text(user),
            Text(message),
          ],
        ),

      ],
    );
  }
}