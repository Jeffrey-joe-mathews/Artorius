import 'package:artorius/components/drawer.dart';
import 'package:artorius/components/feed_post.dart';
import 'package:artorius/components/text_field.dart';
import 'package:artorius/helper/helper_method.dart';
import 'package:artorius/pages/profile_page.dart';
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
        'Likes' : [],
      });
    }
    textController.clear();
  }

  // navigate to profile page
  void goToProfilePage () {
    // pop menu drawer
    Navigator.pop(context);
    Future.delayed(Duration(milliseconds: 300),  () {Navigator.push(context, MaterialPageRoute(builder:(context) => ProfilePage(),));});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      
      appBar: AppBar(
        // leading: IconButton(onPressed:() => Scaffold.of(context).openDrawer(), icon: Icon(Icons.menu)),
        elevation: 0,
        title: Center(child: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Text("A R T O R I U S", ),
        )),
        // actions: [
        //   // sign Out Button
        //   IconButton(onPressed: signOut, icon: Icon(Icons.logout),color: Colors.white,)
        // ],

      ),
      // drawer: MyDrawer(onLogoutTap: signOut, onProfileTap: goToProfilePage),
      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       ListTile(title: Text("H O M E", style: TextStyle(color: Colors.white),),),
      //       ListTile(title: Text("P R O F I L E", style: TextStyle(color: Colors.white),),)
      //     ],
      //   ),
      // ),
      drawer: MyDrawer(profile: goToProfilePage, signOut: signOut),
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
                    return FeedPost(message: post["Message"], user: post['UserEmail'], time: formatDate2(post['TimeStamp']), likes: List<String>.from(post['Likes'] ?? []), postID: post.id,);
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
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                // text field
                Expanded(child: MyTextField(controller: textController, hintText: "Post A Message", obscureText: false)),
                IconButton(onPressed: postMessage, icon: Icon(Icons.send)),
              ],
            ),
          ),
        
          // logged in as?
          // const SizedBox(height: 15,),
        
          ],
        
        
        ),
      ),
    );
  }
}
