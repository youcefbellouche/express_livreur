// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

Drawer drawer(context) {
  return Drawer(
    child: ListView(
      children: [
        // const DrawerHeader(child: Text('Options')),
        DrawerItem(title: 'Acceuil', func: () => Get.offNamed('/')),
        DrawerItem(
          title: 'Statistiques',
          func: () {
            Get.offNamed('Stats');
          },
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
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: ListTile(
          tileColor: Colors.grey[100],
          title: Text(
            title,
            style: const TextStyle(fontSize: 25),
          ),
          onTap: func),
    );
  }
}
