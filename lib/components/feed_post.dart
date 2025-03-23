import 'dart:io';

import 'package:artorius/components/comment_button.dart';
import 'package:artorius/components/comments.dart';
import 'package:artorius/components/delete_button.dart';
import 'package:artorius/components/like_button.dart';
import 'package:artorius/helper/helper_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postID;
  final List<String> likes;
  final String? imageUrl; // Image URL is nullable
  final double? latitude;
  final double? longitude;
  final String? address;
  const FeedPost({super.key, required this.message, required this.user, required this.time, required this.likes, required this.postID, required this.imageUrl, required this.latitude, required this.longitude, required this.address});

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {

  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLiked = false;
  final commentController = TextEditingController();

  @override
  void initState () {
    super.initState();
    isLiked = currentUser != null && widget.likes.contains(currentUser!.email);
  }

  void toggleLike () {
    setState(() {
      isLiked = !isLiked;
      DocumentReference postRef = FirebaseFirestore.instance.collection("User Post's").doc(widget.postID);

      if (isLiked) {
        postRef.update({
          'Likes': FieldValue.arrayUnion([currentUser!.email])
        });
      } else {
        postRef.update({
          'Likes': FieldValue.arrayRemove([currentUser!.email])
        });
      }
    });
  }

  void addComment(String comment) {
    FirebaseFirestore.instance.collection("User Post's").doc(widget.postID).collection("Comments").add({
      'CommentText': comment,
      'CommentedBy': currentUser!.email,
      'CommentTime': Timestamp.now()
    });
  }

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
        TextButton(onPressed: () { Navigator.pop(context); commentController.clear(); }, child: Text("Cancel", style: TextStyle(color: Colors.red),)),
        TextButton(onPressed: () { addComment(commentController.text); commentController.clear(); Navigator.pop(context);}, child: Text("Post", style: TextStyle(color: Colors.green),)),
      ],
    ),);
  }

  void deletePost () {
    showDialog(context: context, builder:(context) => AlertDialog(
      title: const Text("Delete this Post?"),
      content: const Text("This post will be permanently deleted..."),
      actions: [
        TextButton(onPressed:() {
          Navigator.pop(context);   
        }, child: Text("Cancel",style: TextStyle(color: Colors.green),)),
        TextButton(onPressed:() async {
          Navigator.pop(context); 
          final commentDocs = await FirebaseFirestore.instance.collection("User Post's").doc(widget.postID).collection("Comments").get();
          for (var doc in commentDocs.docs) {
            await FirebaseFirestore.instance.collection("User Post's").doc(widget.postID).collection("Comments").doc(doc.id).delete();
          }
          await FirebaseFirestore.instance.collection("User Post's").doc(widget.postID).delete().then((value) => print("Post Deleted")).catchError((error) => print(error.toString()));
        } , child: Text("Delete", style: TextStyle(color: Colors.red),))
      ],
    ),);
  }

  void openGoogleMaps() async {
    if(widget.latitude!=null && widget.longitude!=null) {
      final url = Uri.parse('https://www.google.com/maps?q=${widget.latitude},${widget.longitude}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        showDialog(context: context, builder:(context) => AlertDialog(
      title: Text("Could not launch google maps"),
      actions: [
        TextButton(onPressed: () { Navigator.pop(context); commentController.clear(); }, child: Text("Cancel", style: TextStyle(color: Colors.red),)),
      ],
    ),);
      }
    }
    else {
     showDialog(context: context, builder:(context) => AlertDialog(
      title: Text("Invalid Co-ordinates"),
      actions: [
        TextButton(onPressed: () { Navigator.pop(context); commentController.clear(); }, child: Text("Cancel", style: TextStyle(color: Colors.red),)),
      ],
    ),); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12)
      ),
      margin: EdgeInsets.only(left: 26, right: 26, top: 20),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Message and user info
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
              // Delete button, only for the post owner
              if (widget.user == currentUser!.email) DeleteButton(onTap: deletePost) 
              // else LeadButton(onTap: leadPost),
            ], 
          ),
          
          // Image (display only if it exists)
          if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.network(widget.imageUrl!),
            ),

          if(widget.address != null) 
            GestureDetector(
              onTap: openGoogleMaps,
              child: Row(
                children: [
                  Icon(Icons.pin_drop),
                  Text("Address : ${"${widget.address!.substring(0, 17)}..."??"Address not Provided"}",
                    style: TextStyle(color: Colors.blue),
                  ),
                  
                  ],
                
              ),
            ),
          
          const SizedBox(height: 5,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [ 
              // Like Button and Count
              Column(
                children: [
                  LikeButton(isLiked: isLiked, onTap: toggleLike),
                  const SizedBox(height: 5),
                  Text(widget.likes.length.toString(), style: TextStyle(color: Colors.grey)),
                ],
              ), 

              // Comment Button and Count
              Column(
                children: [
                  CommentButton(onTap: showCommentDialog),
                  const SizedBox(height: 5),
                  Text("0", style: TextStyle(color: Colors.grey)),
                ],
              ), 
            ],
          ),

          const SizedBox(height: 15,),
          // Comments Stream
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("User Post's").doc(widget.postID).collection("Comments").orderBy("CommentTime", descending: true).snapshots(), 
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  final commentData = doc.data() as Map<String, dynamic>;
                  return Comments(comment: commentData['CommentText'], time: formatDate(commentData['CommentTime']), user: commentData['CommentedBy']);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
