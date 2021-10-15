// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

Drawer drawer() {
  return Drawer(
    child: ListView(
      children: [
        const DrawerHeader(child: Text('drawer')),
        DrawerItem(
          title: 'Acceuil',
          func: () => Get.offNamed('/'),
        ),
      ],
    ),
  );
}

// ignore: must_be_immutable
class DrawerItem extends StatelessWidget {
  DrawerItem({
    required this.func,
    required this.title,
    Key? key,
  }) : super(key: key);

  final String title;
  // ignore: prefer_typing_uninitialized_variables
  var func;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        tileColor: const Color(0x000ffeee),
        title: Text(
          title,
          style: const TextStyle(fontSize: 25),
        ),
        onTap: func);
  }
}
