import 'package:artorius/components/button.dart';
import 'package:artorius/components/text_field.dart';
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
                Text("Well met, Thou has sorely been missed"),
            
                const SizedBox(height: 50),


                // email text field
                MyTextField(controller: emailTextController, hintText: "Enter your emailID", obscureText: false),

                const SizedBox(height: 10,),
            
                // password textfield
                MyTextField(controller: passwordTextController, hintText: "Enter your password", obscureText: true),

                const SizedBox(height: 25,),
            
                // sign-in button
                MyButton(onTap: (){}, text: "L O G I N"),
            
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
    );
  }
}