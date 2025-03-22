import 'dart:io';

import 'package:artorius/components/comment_button.dart';
import 'package:artorius/components/comments.dart';
import 'package:artorius/components/like_button.dart';
import 'package:artorius/helper/helper_method.dart';
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

  final commentController = TextEditingController();

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

  // add a comment
  void addComment(String comment) {
    // write under comment collection section for this post
    FirebaseFirestore.instance.collection("User Post's").doc(widget.postID).collection("Comments").add({
      'CommentText' : comment,
      'CommentedBy' : currentUser!.email,
      'CommentTime' : Timestamp.now()
    });
  }

  // show a dialog box
  void showCommentDialog () {
    showDialog(context: context, builder:(context) => AlertDialog(
      title: Text("Add Comment"),
      content: TextField(
        controller: commentController,
        decoration: InputDecoration(
          hintText: "Write a Comment...",
        ),
      ),
      actions: [
        // cancel button
        TextButton(onPressed: () { Navigator.pop(context); commentController.clear(); }, child: Text("Cancel", style: TextStyle(color: Colors.red),)),
        // save button
        TextButton(onPressed: () { addComment(commentController.text); commentController.clear(); Navigator.pop(context);}, child: Text("Post", style: TextStyle(color: Colors.green),)),
      ],
    ),);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12)
      ),
      // margin: EdgeInsets.symmetric(horizontal: 26, vertical: 12.5),
      margin: EdgeInsets.only(left: 26, right: 26, top: 20),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 20,),
          //  feed post
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.message),
              const SizedBox(height: 8,),
              Row(
                children: [
                  Text(widget.user, style: TextStyle(fontSize: 12, ),),
                  Text(" .  "),
                  Text(widget.time, style: TextStyle(fontSize: 12, ),),
                ],
              ),
            ],
          ),

          const SizedBox(height: 5,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [ 
              // llikes
              Column(
                children: [
                  LikeButton(isLiked: isLiked, onTap: toggleLike),

                  const SizedBox(height: 5),

                  Text(widget.likes.length.toString(), style: TextStyle(color: Colors.grey),),
                ],
              ), 

              // comments
              Column(
                children: [
                  CommentButton(onTap: showCommentDialog),

                  const SizedBox(height: 5),
                  // comment count
                  Text("0", style: TextStyle(color: Colors.grey),),
                ],
              ), 

            ],
          ),
          const SizedBox(height: 15,),
          // comments under the post
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("User Post's").doc(widget.postID).collection("Comments").orderBy("CommentTime", descending: true).snapshots(), 
            builder:(context, snapshot) {
              // show loading circle if no data yet
              if (!snapshot.hasData) {
                return const Center(
                  child:CircularProgressIndicator(),
                ); 
              }
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                    // get the comment
                    final commentData = doc.data() as Map<String, dynamic>;

                    // return the comment
                    return Comments(comment: commentData['CommentText'], time: formatDate(commentData['CommentTime']), user: commentData['CommentedBy']);
                  }
                  ).toList(),
              );
          },)
        ],
      ),
    );
  }
}