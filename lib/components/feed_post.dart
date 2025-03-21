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
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[500]),
            child: const Icon(Icons.person, color: Colors.white,),
            padding: EdgeInsets.all(10),
          ),
          const SizedBox(width: 20,),
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