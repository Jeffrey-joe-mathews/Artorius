import 'package:flutter/material.dart';

class LeadPage2 extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postID;
  final List<String> likes;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final String? address;
  final void Function(String) addComment;
  final void Function()? toggleLike;
  final void Function()? showCommentDialog;

  const LeadPage2({
    super.key,
    required this.message,
    required this.user,
    required this.time,
    required this.postID,
    required this.likes,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.addComment,
    required this.toggleLike,
    required this.showCommentDialog,

  });

  @override
  State<LeadPage2> createState() => _LeadPage2State();
}

class _LeadPage2State extends State<LeadPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Details"),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Event Message
              Text(
                widget.message,
              ),
              const SizedBox(height: 10),
              // User Info
              Text(
                'Posted by: ${widget.user}',
                style: TextStyle(fontSize: 14,),
              ),
              Text(
                'Date: ${widget.time}',
                style: TextStyle(fontSize: 14,),
              ),
              const SizedBox(height: 20),
              // Image (if available)
              if (widget.imageUrl != null)
                Image.network(
                  widget.imageUrl!,
                  // fit: BoxFit.cover,
                  // width: double.infinity,
                  // height: 300,
                ),
              const SizedBox(height: 20),
              // Address (if available)
              if (widget.address != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.pin_drop, color: Colors.blue, size: 32,),
                    Expanded(
                      child: Text(
                        widget.address!,
                        style: TextStyle(color: Colors.blue),
                        overflow: TextOverflow.ellipsis, // Ensure it doesn't overflow
                        maxLines: 7, // Allow for two lines of text max
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              // Likes Section
              Row(
                children: [
                  Icon(Icons.favorite, color: Colors.grey),
                  Text('${widget.likes.length} Likes', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 20),
              // Enroll Button
              ElevatedButton(
                onPressed: () {
                  // Handle Enroll action here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("You are now enrolled in the event!")),
                  );
                },
                child: Text("Enroll in Event"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
