// import 'dart:ui';

// import 'package:artorius/components/feed_post.dart';
// import 'package:artorius/components/text_box.dart';
// import 'package:artorius/helper/helper_method.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {

//   // get the user email
//   final currentUser = FirebaseAuth.instance.currentUser;
//   // all users
//   final usersCollection = FirebaseFirestore.instance.collection("Users");

//   Future<void> editField (String field) async {
//     String newValue = "";
//     await showDialog(context: context, builder:(context) => AlertDialog(
//       backgroundColor: Theme.of(context).colorScheme.primary,
//       title: Text("Edit Your $field", style: const TextStyle(color: Colors.white),),
//       content: TextField(
//         autofocus: true,
//         decoration: InputDecoration(
//           hintText: "Enter your $field",
//           hintStyle: TextStyle(color: Colors.grey),
//         ),
//         onChanged: (value) {
//           newValue = value;
//         },
//       ),
//       actions: [
//         // cancel button
//         TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel", style: TextStyle(color: Colors.red),)),
//         // save button
//         TextButton(onPressed: () => Navigator.of(context).pop(newValue), child: Text("Update", style: TextStyle(color: Colors.green),))
//       ],
//     ),);

//     if (newValue.trim().length > 0) {
//       await usersCollection.doc(currentUser!.email).update({field : newValue});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor:Theme.of(context).colorScheme.surface,
//       appBar: AppBar(
//         title: Text("P R O F I L E", ),
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream:FirebaseFirestore.instance.collection("Users").doc(currentUser!.email).snapshots(), 
//         builder:(context, snapshot) {
//           // get user data
//           if (snapshot.hasData) {
//             final userData = snapshot.data!.data() as Map<String, dynamic>;
//             return ListView(
//         children: [
//           // profile picture
//           const SizedBox(height: 50,),
//           Icon(Icons.person, size: 84,),

//           const SizedBox(height: 10,),

//           // user email
//           Text(currentUser!.email!, textAlign: TextAlign.center,),

//           const SizedBox(height: 50,),
//           //// userdetails
//           Padding(padding: const EdgeInsets.symmetric(vertical: 20),child: Text("B I O", textAlign: TextAlign.center,),),
          
//             MyTextBox(text: userData['username'], sectionName: "username", onPressed:() => editField("username"),),
//             MyTextBox(text: userData['bio'], sectionName: "biography", onPressed:() => editField("bio"),),
//             MyTextBox(text: userData['interests'], sectionName: "Interests", onPressed: () => editField("interests")),
//             // user posts
          
//           const SizedBox(height: 50,),

//           Padding(padding: const EdgeInsets.symmetric(vertical: 20),child: Text("P O S T S", textAlign: TextAlign.center,),),

//           Expanded(
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance.collection("User Post's").orderBy("TimeStamp", descending: true).snapshots(), 
//               builder:(context, snapshot) {
//                 if (snapshot.hasData ) {
//                   return ListView.builder(itemCount: snapshot.data!.docs.length, itemBuilder:(context, index) {
//                     // get the message
//                     final post  = snapshot.data!.docs[index];
//                     if (post['UserEmail'] == currentUser!.email) {
//                     return FeedPost(
//                       title: post["Title"], 
//                       description : post['Description'],
//                       topic : List<String>.from(post['Topic'] ?? []),
//                       user: post['UserEmail'], 
//                       time: formatDate2(post['TimeStamp']), 
//                       likes: List<String>.from(post['Likes'] ?? []), 
//                       postID: post.id, 
//                       imageUrl: post['ImageUrl']??"", 
//                       latitude: post['Latitude'], 
//                       longitude: post['Longitude'], 
//                       address: post['Address']
//                       );
//                     }
//                   },);
//                 }
//                 else if (snapshot.hasError) {
//                   return Center(child: Text("Error${snapshot.hasError}"),);
//                 }
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               },
//             )
//           ),

//         ],
//         );
//           }
//           else if (snapshot.hasError) {
//             return Center(child: Text('Error${snapshot.error}'),);
//           }
//           return const Center(child: CircularProgressIndicator(),);
//         },
//       ),

//     );
//   }
// }

import 'package:artorius/components/feed_post.dart';
import 'package:artorius/components/feed_post_2.dart';
import 'package:artorius/components/text_box.dart';
import 'package:artorius/helper/helper_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  // Edit field method for profile
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Edit Your $field", style: const TextStyle(color: Colors.white)),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Enter your $field",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
          // save button
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: Text("Update", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );

    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(currentUser!.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("P R O F I L E"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser!.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                // Profile picture
                const SizedBox(height: 50),
                Icon(Icons.person, size: 84),

                const SizedBox(height: 10),

                // User email
                Text(currentUser!.email!, textAlign: TextAlign.center),

                const SizedBox(height: 50),

                // User details
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text("B I O", textAlign: TextAlign.center)),
                MyTextBox(
                  text: userData['username'],
                  sectionName: "username",
                  onPressed: () => editField("username"),
                ),
                MyTextBox(
                  text: userData['bio'],
                  sectionName: "biography",
                  onPressed: () => editField("bio"),
                ),
                MyTextBox(
                  text: userData['interests'],
                  sectionName: "Interests",
                  onPressed: () => editField("interests"),
                ),

                const SizedBox(height: 50),

                // User posts heading
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text("P O S T S", textAlign: TextAlign.center)),

                // Posts section
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("User Post's")
                      .orderBy("TimeStamp", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasData) {
                      final posts = snapshot.data!.docs.where((post) =>
                          post['UserEmail'] == currentUser!.email).toList();

                      if (posts.isEmpty) {
                        return const Center(
                            child: Text("No posts yet!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return FeedPost2(
                            title: post["Title"],
                            description: post['Description'],
                            topic: List<String>.from(post['Topic'] ?? []),
                            user: post['UserEmail'],
                            time: formatDate2(post['TimeStamp']),
                            likes: List<String>.from(post['Likes'] ?? []),
                            postID: post.id,
                            imageUrl: post['ImageUrl'] ?? "",
                            latitude: post['Latitude'],
                            longitude: post['Longitude'],
                            address: post['Address'],
                            both: "yes",
                          );
                        },
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    return const Center(child: Text("No posts found."));
                  },
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
