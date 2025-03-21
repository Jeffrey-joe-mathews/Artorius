import 'package:flutter/material.dart';

class FeedPost extends StatelessWidget {
  final String message;
  final String user;
  final String time;
  const FeedPost({super.key, required this.message, required this.user, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)
      ),
      margin: EdgeInsets.symmetric(horizontal: 26, vertical: 12.5),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user, style: TextStyle(color: Colors.grey.shade400),),
              const SizedBox(height: 8,),
              Text(message),
            ],
          ),
      
        ],
      ),
    );
  }
}