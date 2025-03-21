import 'package:artorius/components/button.dart';
import 'package:artorius/components/text_field.dart';
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

  // sign the user up ykwim
  void signUp () async {
    // show circly thung
    showDialog(context: context, builder:(context) => const Center(child: CircularProgressIndicator.adaptive(),),);

    // making sure the passwords match
    try {
      if(passwordTextController.text == confirmPasswordTextController.text) {

        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailTextController.text, password: passwordTextController.text);
      }
      else {
        Navigator.pop(context);
        // show error message to the user
        displayMessage("Passwords Don't Match");
        return;
      }
      if(context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch(e) {
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
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
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
    );
  }
}