import 'package:flutter/material.dart';

class LeadPage extends StatefulWidget {
  const LeadPage({super.key});

  @override
  State<LeadPage> createState() => _LeadPageState();
}

class _LeadPageState extends State<LeadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Page"),
      ),
    );
  }
}