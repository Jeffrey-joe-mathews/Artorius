import 'package:artorius/components/button.dart';
import 'package:artorius/components/text_field.dart';
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
                MyButton(onTap: (){}, text: "S I G N - U P"),
            
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