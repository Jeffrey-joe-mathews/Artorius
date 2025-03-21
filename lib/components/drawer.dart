import 'package:artorius/components/my_list_tile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {

  final void Function()? onProfileTap;
  final void Function()? onLogoutTap;

  const MyDrawer({super.key, required this.onLogoutTap, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // header
              DrawerHeader(child: Icon(Icons.theater_comedy_outlined, color: Colors.white, size: 70,),),
          
              // home list tile
              MyListTile(text: "H O M E", icon: Icons.home, onTap:() => Navigator.pop(context) ,),
          
              // profile list tile
              MyListTile(text: "P R O F I L E", icon: Icons.person, onTap: onProfileTap),
          
              // logout list tile 
              MyListTile(text: "L O G O U T", icon: Icons.logout, onTap: onLogoutTap),
            ],
          ),
        ],
      ),
    );
  }
}