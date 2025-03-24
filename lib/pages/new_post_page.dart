import 'package:flutter/material.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? selectedAddress;
  String? selectedImage;

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: const Text("Create a Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
                suffixIcon: Icon(
                  Icons.text_fields,
                  color: titleController.text.isNotEmpty ? Colors.blue : Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
                suffixIcon: Icon(
                  Icons.description,
                  color: descriptionController.text.isNotEmpty ? Colors.blue : Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.map,
                    color: selectedAddress != null ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () {
                    // Add logic for selecting an address
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.image,
                    color: selectedImage != null ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () {
                    // Add logic for selecting an image
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add post submission logic
                },
                child: const Text("Post"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}