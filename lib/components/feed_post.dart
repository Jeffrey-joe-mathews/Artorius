import 'package:artorius/components/like_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postID;
  final List<String> likes;
  const FeedPost({super.key, required this.message, required this.user, required this.time, required this.likes, required this.postID});

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {

  // user
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLiked = false;

  @override
  void initState () {
    super.initState();
    isLiked = currentUser!=null && widget.likes.contains(currentUser!.email);
  }

  void toggleLike () {
    setState(() {
      isLiked = !isLiked;

      //
      DocumentReference postRef = FirebaseFirestore.instance.collection("User Post's").doc(widget.postID);

      if (isLiked) {
        // if post is liked add the user field to the liked field
        postRef.update({
            'Likes' : FieldValue.arrayUnion([currentUser!.email])
          });
      }
      else { 
        // if the post id now unliked nremove the user from the liked field of the post
        postRef.update({
          'Likes' : FieldValue.arrayRemove([currentUser!.email])
        });
      }

    });
  }

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
            children: [
              LikeButton(isLiked: isLiked, onTap: toggleLike)
            ],
          ),
          // Container(
          //   decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[500]),
          //   child: const Icon(Icons.person, color: Colors.white,),
          //   padding: EdgeInsets.all(10),
          // ),
          const SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user, style: TextStyle(color: Colors.grey.shade400),),
              const SizedBox(height: 8,),
              Text(widget.message),
            ],
          ),
      
        ],
      ),
    );
  }
}