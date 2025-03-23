import 'package:artorius/components/button.dart';
import 'package:artorius/components/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  // keeps track of smth
  bool isLoading = false;

  // sign the user up ykwim`
  void signUp () async {
    setState(() {
      isLoading = true;
    });
    showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator.adaptive(),));

    if(passwordTextController.text != confirmPasswordTextController.text) {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);displayMessage("Passwords Don't Match");return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailTextController.text, password: passwordTextController.text);
      // after creating user, create a new document in cloud firesotre called users
      if (userCredential.user != null ) await FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set({'username' : emailTextController.text.split("@")[0], 'bio' : 'empty bio...', 'interests' : 'empty interests...'});
      // if (context.mounted) Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    }
    on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      // pop loading circle
      Navigator.pop(context);
      // show error to user
      displayMessage(e.code);
    }
  }

  void displayMessage (String alertMessage) {
    showDialog(context: context, builder:(context) => AlertDialog(
      icon: Icon(Icons.error, color: Colors.red,),
      title: Text(alertMessage,style: TextStyle(color: Colors.red),),
    ),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              
                  // logo
                  Icon(Icons.theater_comedy_outlined, size: 120),
              
                  const SizedBox(height: 50),
              
                  // welcome back message
                  Text("Pray, let us craft a ledger for thee"),
              
                  const SizedBox(height: 50),
            
            
                  // email text field
                  MyTextField(controller: emailTextController, hintText: "Enter thy emailID", obscureText: false),
            
                  const SizedBox(height: 10,),
              
                  // password textfield
                  MyTextField(controller: passwordTextController, hintText: "Enter thy password", obscureText: true),
            
            
                  const SizedBox(height: 10,),
            
                  MyTextField(controller: confirmPasswordTextController, hintText: "Confirm thy password", obscureText: true),
            
            
                  const SizedBox(height: 25,),
              
                  // sign-in button
                  MyButton(onTap: signUp, text: "S I G N - U P"),
              
                  const SizedBox(height: 25,),
            
            
                  // goto register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Hast thou an account? "),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text("Enter here.", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),)
                      )
                    ],
                  ),
            
                  const SizedBox(height: 50,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}