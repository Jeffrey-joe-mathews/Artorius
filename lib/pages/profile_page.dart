import 'package:artorius/components/text_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  // get the user email
  final currentUser = FirebaseAuth.instance.currentUser;

  void editField (String field) async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("P R O F I L E", style:TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream:FirebaseFirestore.instance.collection("Users").doc(currentUser!.email).snapshots(), 
        builder:(context, snapshot) {
          // get user data
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
        children: [
          // profile picture
          const SizedBox(height: 50,),
          Icon(Icons.person, size: 84,),

          const SizedBox(height: 10,),

          // user email
          Text(currentUser!.email!, textAlign: TextAlign.center,style: TextStyle(color: Colors.grey.shade700),),

          const SizedBox(height: 50,),
          //// userdetails
          Padding(padding: const EdgeInsets.symmetric(vertical: 20),child: Text("B I O", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade700),),),
          
            MyTextBox(text: "Jeffrey Joe Mathews", sectionName: "username", onPressed:() => editField("username"),),
            MyTextBox(text: "Empty Bio", sectionName: "biography", onPressed:() => editField("bio"),),
            MyTextBox(text: "Archery", sectionName: "Interests", onPressed: () => editField("interests")),
            // user posts
          
          const SizedBox(height: 50,),

          Padding(padding: const EdgeInsets.symmetric(vertical: 20),child: Text("P O S T S", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade700),),),

        ],
        );
          }
          else if (snapshot.hasError) {
            return Center(child: Text('Error${snapshot.error}'),);
          }
          return const Center(child: CircularProgressIndicator(),);
        },
      ),
      // body: ListView(
      //   children: [
      //     // profile picture
      //     const SizedBox(height: 50,),
      //     Icon(Icons.person, size: 84,),

      //     const SizedBox(height: 10,),

      //     // user email
      //     Text(currentUser!.email!, textAlign: TextAlign.center,style: TextStyle(color: Colors.grey.shade700),),

      //     const SizedBox(height: 50,),
      //     //// userdetails
      //     Padding(padding: const EdgeInsets.symmetric(vertical: 20),child: Text("B I O", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade700),),),
          
      //       MyTextBox(text: "Jeffrey Joe Mathews", sectionName: "username", onPressed:() => editField("username"),),
      //       MyTextBox(text: "Empty Bio", sectionName: "biography", onPressed:() => editField("bio"),),
      //       MyTextBox(text: "Archery", sectionName: "Interests", onPressed: () => editField("interests"))
      //       // user posts
          
      //     const SizedBox(height: 50,),

      //     Padding(padding: const EdgeInsets.symmetric(vertical: 20),child: Text("P O S T S", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade700),),),

      //   ],
      // ),
    );
  }
}