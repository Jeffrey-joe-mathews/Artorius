import 'package:flutter/material.dart';

class MyListItem extends StatelessWidget {
  final String navItem;
  final IconData icon;
  final void Function()? onTap;
  const MyListItem({super.key, required this.navItem, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ListTile(
        onTap: onTap,
        title: Text(navItem),
        leading: Icon(icon,),
      
      ),
    );
  }
}