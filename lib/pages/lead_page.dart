import 'package:artorius/components/comment_button.dart';
import 'package:artorius/components/comments.dart';
import 'package:artorius/components/like_button.dart';
import 'package:artorius/helper/helper_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadPage extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postID;
  final List<String> likes;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final String? address;
  final bool isLiked;
  final void Function()? toggleLike;
  const LeadPage({
    super.key,
    required this.message,
    required this.user,
    required this.time,
    required this.postID,
    required this.likes,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.isLiked,
    required this.toggleLike,
  });

  @override
  State<LeadPage> createState() => _LeadPageState();
}

class _LeadPageState extends State<LeadPage> {


    void openGoogleMaps() async {
    if(widget.latitude!=null && widget.longitude!=null) {
      final url = Uri.parse('https://www.google.com/maps?q=${widget.latitude},${widget.longitude}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        showDialog(context: context, builder:(context) => AlertDialog(
      title: Text("Could not launch google maps"),
      actions: [
        TextButton(onPressed: () { Navigator.pop(context);}, child: Text("Cancel", style: TextStyle(color: Colors.red),)),
      ],
    ),);
      }
    }
    else {
     showDialog(context: context, builder:(context) => AlertDialog(
      title: Text("Invalid Co-ordinates"),
      actions: [
        TextButton(onPressed: () { Navigator.pop(context); }, child: Text("Cancel", style: TextStyle(color: Colors.red),)),
      ],
    ),); 
    }
  }                               

    // checking if current user has liked
    // bool isLiked = false;

    // creating an instance of current user
    final currentUser = FirebaseAuth.instance.currentUser;

    // cresting a textfield controller for the comment
    final commentController = TextEditingController();

    // add a comment
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.message,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 7,
                ),

                // SizedBox(
                //     width: MediaQuery.of(context).size.width * 0.65,
                //     child: SingleChildScrollView(
                //       physics: NeverScrollableScrollPhysics(),
                //       padding: EdgeInsets.zero,
                //       child: 
                //       MarkdownBody(
                //         data : widget.message,
                //         softLineBreak: true,
                //         shrinkWrap: true,
                //         fitContent: true,
                //         styleSheet: MarkdownStyleSheet(
                //           h1: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                //           h2: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                //           p: TextStyle(fontSize: 16),
                //         ),
                        
                //         ),
                    
                //       // without markdown :
                //       // Text(
                //       //     widget.message.replaceAll(RegExp(r'(\*\*|__|\*|_)'), ''), // Remove Markdown formatting
                //       //     maxLines: 3,
                //       //     overflow: TextOverflow.ellipsis,
                //       //     style: TextStyle(fontSize: 16),
                //       //   ),
                    
                    
                //     ),
                //   ),

                const SizedBox(height: 10,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: const Divider(thickness: 2,),
                ),

                const SizedBox(height: 10,),

                Text(
                  'Posted By : ${widget.user}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  ),

                const SizedBox(height: 10,),

                Text(
                  "Date : ${widget.time}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                
                const SizedBox(height: 7,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: const Divider(thickness: 2,),
                ),

                const SizedBox(height: 7,),

                Icon(Icons.image, size: 64,),

                (widget.imageUrl != null) 
                ?
                Image.network(widget.imageUrl!)
                :
                Text("No Image Provided"),

                // display event details

                // display address
                if (widget.address != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on_outlined, size: 64,),
                      const SizedBox(height: 10,),
                      GestureDetector(
                        onTap: openGoogleMaps,
                        child: Expanded(
                          child: Text(
                            widget.address!,
                            style: TextStyle(color: Colors.blue),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 7,
                            )
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 10,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: const Divider(thickness: 2,),
                ),

                const SizedBox(height: 10,),

                  Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [ 
              // Like Button and Count
              Column(
                children: [
                  LikeButton(isLiked: widget.isLiked, onTap: widget.toggleLike),
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

          const SizedBox(height: 20,),

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
          ),
        ),
      ),
    );
  }
}