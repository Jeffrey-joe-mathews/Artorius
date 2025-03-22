import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Comments extends StatelessWidget {
  final String comment;
  final String user;
  final String time;
  const Comments({super.key, required this.comment, required this.time, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // user comment
          Text(comment),
          // user name and timestamp
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(user, style: TextStyle(fontSize: 12, color: Colors.black45),),
              Text("  "),
              Text(time, style: TextStyle(fontSize: 12, color: Colors.black45),),
            ],
          ),
        ],
      ),
    );
  }
}