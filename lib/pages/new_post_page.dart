import 'dart:io';

import 'package:artorius/helper/helper_method.dart';
import 'package:artorius/pages/home_page.dart';
import 'package:artorius/pages/map_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final  topicController = TextEditingController();
  String? _address = "";
  String? _selectedImage;
  LatLng _currentLocation = LatLng(0.0, 0.0);
  final currentUser = FirebaseAuth.instance.currentUser!;
  XFile? _image;
  bool _isLoading = false; 


  @override
  void initState () {
    super.initState();
    // _getCurrentLocation();
  }

  Future<void> _getCurrentLocation () async {
    bool serviceEnabled;
    LocationPermission permission;

    // check if user has enabled location services
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(context: context, builder:(context) => AlertDialog(
        title: Text("Location Service Disabled"),
        content: Text("Please enable your location service to add coordinates"),
        actions: [
          TextButton(onPressed: () {
            Geolocator.openAppSettings();
            Navigator.pop(context);
          }, child: Text("Enable Location", style: TextStyle(color: Colors.green),)),
          TextButton(onPressed: () => 
          Navigator.pop, 
            child: Text("Cancel", style: TextStyle(color: Colors.red),)),
        ],
      ),);
      return;
    }
    permission = await Geolocator.checkPermission(); 
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // If permission is denied permanently, show an error and return
        showDialog(context: context, builder:(context) => AlertDialog(
        title: Text("Location Permission Debied"),
        content: Text("Please enable your location service to add coordinates"),
        actions: [
          TextButton(onPressed: () => 
          Navigator.pop, 
            child: Text("Cancel", style: TextStyle(color: Colors.red),)),
        ],
      ),);
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

  }

  void pickLocation () async {
    final result = await Navigator.push(context, MaterialPageRoute(builder:(context) => MapScreen(initialLocation : _currentLocation),),);
    if (result != null) {
      double latitude = result['latitude'];
      double longitude = result['longitude'];
      setState(() {
        _address = result['address'];
        _currentLocation = LatLng(latitude, longitude);
      });
    }
  }

   Future<String> uploadImageToCloudinary(File imageFile) async {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;
    final apiKey = dotenv.env['CLOUDINARY_API_KEY']!;
    final apiSecret = dotenv.env['CLOUDINARY_API_SECRET']!;
    final cloudinary = Cloudinary.signedConfig(
      cloudName: cloudName,
      apiKey: apiKey,
      apiSecret: apiSecret,
    );

    final response = await cloudinary.upload(
      file : imageFile.path,
      resourceType: CloudinaryResourceType.image,
    );

    if (response.isSuccessful) {
      return response.secureUrl!;
    } else {
      throw Exception('Image upload failed');
    }
  }

  // Creating a post method
  void _post() async {
  if (titleController.text.isNotEmpty &&
      descriptionController.text.isNotEmpty &&
      topicController.text.isNotEmpty) {

        setState(() {
          _isLoading = true;
        });

        String? imageUrl;

    // Extracting topics as an array
    List<String> topics = topicController.text
        .split(RegExp(r'[, ]+'))
        .where((element) => element.isNotEmpty) 
        .toList();

    try {
      if(_image != null) {
        imageUrl = await uploadImageToCloudinary(File(_image!.path));
      }
      await FirebaseFirestore.instance.collection("User Post's").add({
        'UserEmail': FirebaseAuth.instance.currentUser!.email,
        'Title': titleController.text,
        'Description': descriptionController.text,
        'Topic': topics,
        'TimeStamp': Timestamp.now(),
        // 'TimeStamp' : formatDate2(Timestamp.now()),
        'Likes': [],
        'ImageUrl': imageUrl ?? "",
        'Address': _address ?? "",
        'Latitude' : _currentLocation.latitude,
        'Longitude' : _currentLocation.longitude,
      });

      setState(() {
        _isLoading = false;
      });

      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => HomePage())
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Could not create post."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.red),),
            ),
          ],
        ),
      );
    }
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Missing Fields"),
        content: const Text("All fields must be filled."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

  Future<void> pickImage () async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage!=null) {
    setState(() {
      _image = pickedImage;
      _selectedImage = pickedImage.path;
    });
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a Post"),
      ),
      body: 
      _isLoading ? 
      Center(child: CircularProgressIndicator(),) :
      ListView(
        children: [
          Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter the title"),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: const OutlineInputBorder(),
                suffixIcon: Icon(
                  Icons.text_fields,
                  // color: titleController.text.isNotEmpty ? Colors.blue : Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("Enter the description"),
            TextField(
              controller: descriptionController,
              maxLines: 7,
              decoration: InputDecoration(
                hintText: "Description",
                border: const OutlineInputBorder(),
                suffixIcon: Icon(
                  Icons.description,
                  // color: descriptionController.text.isNotEmpty ? Colors.blue : Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("Enter the tags"),
            TextField(
              controller: topicController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "eg : Hackathon, Coding ...",
                border: const OutlineInputBorder(),
                suffixIcon: Icon(
                  Icons.tag,
                  // color: descriptionController.text.isNotEmpty ? Colors.blue : Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Select the venue"),
                    IconButton(
                      icon: Icon(
                        Icons.map,
                        size: 32,
                        color: _address != "" ? Colors.green : Colors.grey,
                      ),
                      onPressed:() { 
                        _getCurrentLocation();
                        pickLocation(); 
                        },
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
               Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Select the Image"),
                    IconButton(
                      icon: Icon(
                        Icons.image_search,
                        size: 32,
                        color: _image != null ? Colors.green : Colors.grey,
                      ),
                      onPressed:() => pickImage(),
                    ),
                  ],
                ), 
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _post, 
                child: const Text(
                  "Post",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          ],
        ),
      ),
        ],
      ),
    );
  }
}
