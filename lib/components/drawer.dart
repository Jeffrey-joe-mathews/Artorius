import 'package:artorius/components/my_list_item.dart';
import 'package:artorius/pages/profile_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? signOut;
  final void Function()? profile;
  const MyDrawer({super.key, required this.profile, required this.signOut});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade900,
      child: 
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  // logo
              DrawerHeader(child: Icon(Icons.theater_comedy_outlined, color: Colors.white,size: 80,),),

              // homepage button
              // MyListItem(navItem: "H O M E", icon: Icons.home)
              MyListItem(navItem: "H O M E", icon: Icons.home, onTap: () => Navigator.pop(context),),

              // profile page button
              MyListItem(navItem: "P R O F I L E", icon: Icons.person, onTap: profile,),
                ],
              ),           
              // logout
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: MyListItem(navItem: "L O G O U T", icon: Icons.logout, onTap : signOut, ),
              )
              
            ],
          )
    );
  }
}