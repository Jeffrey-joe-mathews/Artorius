import 'package:artorius/components/drawer.dart';
import 'package:artorius/components/feed_post.dart';
import 'package:artorius/components/text_field.dart';
import 'package:artorius/helper/helper_method.dart';
import 'package:artorius/pages/map_screen.dart';
import 'package:artorius/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // user instance
  final currentUser = FirebaseAuth.instance.currentUser!;

  // text controller
  final textController = TextEditingController();

  // image from system
  XFile? _image;

  // Location CO-ordinates
  LatLng _currentLocation = LatLng(0.0, 0.0);

  // storing the address corresponding to the latitude
  String? _address = "";

  // get current location when the app loads
  @override
  void initState () {
    super.initState();
    _getCurrentLocation();
  }

  // get current Location
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

  void signOut () {
    FirebaseAuth.instance.signOut();
  }

  void postMessage() async {
  if (textController.text.isNotEmpty || _image != null) {
    // If there's a message or an image
    String? imageUrl;

    try {
      if (_image != null) {
        // Upload image to Cloudinary and get the image URL
        imageUrl = await uploadImageToCloudinary(File(_image!.path));

        // Store the message and image URL in Firestore
        await FirebaseFirestore.instance.collection("User Post's").add({
          'UserEmail': FirebaseAuth.instance.currentUser!.email,
          'Message': textController.text,
          'TimeStamp': Timestamp.now(),
          'Likes': [],
          'ImageUrl': imageUrl ?? "", // Save the image URL if exists
          'Latitude' : _currentLocation.latitude,
          'Longitude' : _currentLocation.longitude,
          'Address' : _address,
        });
      } else {
        // No image, just store the message
        await FirebaseFirestore.instance.collection("User Post's").add({
          'UserEmail': FirebaseAuth.instance.currentUser!.email,
          'Message': textController.text,
          'TimeStamp': Timestamp.now(),
          'Likes': [],
          'ImageUrl': "", // No image, store an empty string
          'Latitude' : _currentLocation.latitude,
          'Longitude' : _currentLocation.longitude,
          'Address' : _address,
        });
      }
      
      // Clear the text and reset image after posting
      textController.clear();
      setState(() {
        _image = null; // Reset the selected image after posting
      });
    } catch (e) {
      showDialog(context: context, builder:(context) => AlertDialog(
      title: Text("Event could not be posted"),
      content: Text("Sorry for the inconvenience..."),
      actions: [
        TextButton(onPressed: () { Navigator.pop(context);}, child: Text("Cancel", style: TextStyle(color: Colors.red),)),
      ],
    ),);
    }
  }
}


  // navigate to profile page
  void goToProfilePage () {
    // pop menu drawer
    Navigator.pop(context);
    Future.delayed(Duration(milliseconds: 300),  () {Navigator.push(context, MaterialPageRoute(builder:(context) => ProfilePage(),));});

  }

  // get the image from camera or local storage
  Future<void> pickImage () async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    }); 
  }

   Future<String> uploadImageToCloudinary(File imageFile) async {
    // Use the Cloudinary package to upload the image and get the URL
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      
      appBar: AppBar(
        // leading: IconButton(onPressed:() => Scaffold.of(context).openDrawer(), icon: Icon(Icons.menu)),
        elevation: 0,
        title: Center(child: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Text("A R T O R I U S", ),
        )),
        // actions: [
        //   // sign Out Button
        //   IconButton(onPressed: signOut, icon: Icon(Icons.logout),color: Colors.white,)
        // ],

      ),
      // drawer: MyDrawer(onLogoutTap: signOut, onProfileTap: goToProfilePage),
      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       ListTile(title: Text("H O M E", style: TextStyle(color: Colors.white),),),
      //       ListTile(title: Text("P R O F I L E", style: TextStyle(color: Colors.white),),)
      //     ],
      //   ),
      // ),
      drawer: MyDrawer(profile: goToProfilePage, signOut: signOut),
      body: Center(
        child: Column(
          children: [
          // feed
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("User Post's").orderBy("TimeStamp", descending: false).snapshots(), 
              builder:(context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(itemCount: snapshot.data!.docs.length, itemBuilder:(context, index) {
                    // get the message
                    final post  = snapshot.data!.docs[index];
                    return FeedPost(message: post["Message"], user: post['UserEmail'], time: formatDate2(post['TimeStamp']), likes: List<String>.from(post['Likes'] ?? []), postID: post.id, imageUrl: post['ImageUrl']??"", latitude: post['Latitude'], longitude: post['Longitude'], address: post['Address']);
                  },);
                }
                else if (snapshot.hasError) {
                  return Center(child: Text("Error${snapshot.hasError}"),);
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          ),
        
          // user message
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                // text field
                Expanded(child: MyTextField(controller: textController, hintText: "Post A Message", obscureText: false, maxLines: null,)),
                IconButton(onPressed: pickLocation, icon: Icon(Icons.map)),
                IconButton(onPressed: pickImage ,icon: Icon(Icons.attachment)),
                IconButton(onPressed: postMessage, icon: Icon(Icons.send)),
              ],
            ),
          ),
        
          // logged in as?
          // const SizedBox(height: 15,),
        
          ],
        
        
        ),
      ),
    );
  }
}
