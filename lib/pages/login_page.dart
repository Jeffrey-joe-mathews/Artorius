import 'package:artorius/components/button.dart';
import 'package:artorius/components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // text editing controller
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  // sign user in
  void signIn () async {

    // loading circle
    showDialog(context: context, builder:(context) => const Center(child: CircularProgressIndicator.adaptive(),),);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailTextController.text, password: passwordTextController.text); 
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // print(e.code);
      displayMessage(e.code);
    }
  }

  void displayMessage (String alertMessage) {
    showDialog(context: context, builder: (context) => AlertDialog(
      icon: Icon(Icons.error),
      title: Text(alertMessage, style: TextStyle(color: Colors.red),),
    ));
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
                  Text("Well met, Thou has sorely been missed"),
              
                  const SizedBox(height: 50),
            
            
                  // email text field
                  MyTextField(controller: emailTextController, hintText: "Enter your emailID", obscureText: false, maxLines: 1,),
            
                  const SizedBox(height: 10,),
              
                  // password textfield
                  MyTextField(controller: passwordTextController, hintText: "Enter your password", obscureText: true, maxLines: 1),
            
                  const SizedBox(height: 25,),
              
                  // sign-in button
                  MyButton(onTap: signIn, text: "L O G I N"),
              
                  const SizedBox(height: 25,),
            
            
                  // goto register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Wilt thou not be a member? "),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text("Enlist thyself.", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),)
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