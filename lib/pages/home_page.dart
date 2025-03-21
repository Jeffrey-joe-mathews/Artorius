import 'package:artorius/components/feed_post.dart';
import 'package:artorius/components/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // user instance
  final currentUser = FirebaseAuth.instance.currentUser!;

  // text controller
  final textController = TextEditingController();

  void signOut () {
    FirebaseAuth.instance.signOut();
  }

  void postMessage () {
    // only post if there exists something in the text field
    if (textController.text.isNotEmpty) {
      // store in firebase
      FirebaseFirestore.instance.collection("User Post's").add({
        'UserEmail' : currentUser.email,
        'Message' : textController.text,
        'TimeStamp' : Timestamp.now(),
      });
    }
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade900,
        title: Text("A R T O R I U S", style: TextStyle(color: Colors.white),),
        actions: [
          // sign Out Button
          IconButton(onPressed: signOut, icon: Icon(Icons.logout),color: Colors.white,)
        ],
      ),
      body: Center(
        child: Column(
          children: [
          // feed
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("User Post's").orderBy("TimeStamp", descending: false).snapshots(), 
              builder:(context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(itemCount: snapshot.data!.docs.length, itemBuilder:(context, index) {
                    // get the message
                    final post  = snapshot.data!.docs[index];
                    return FeedPost(message: post["Message"], user: post['UserEmail'], time: "12 am");
                  },);
                }
                else if (snapshot.hasError) {
                  return Center(child: Text("Error${snapshot.hasError}"),);
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          ),
        
          // user message
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                // text field
                Expanded(child: MyTextField(controller: textController, hintText: "Post A Message", obscureText: false)),
                IconButton(onPressed: postMessage, icon: Icon(Icons.send)),
              ],
            ),
          ),
        
          // logged in as?
          Text("Logged in as : ${currentUser.email!}", style: TextStyle(color: Colors.grey),),
          const SizedBox(height: 25,),
        
          ],
        
        
        ),
      ),
    );
  }
}