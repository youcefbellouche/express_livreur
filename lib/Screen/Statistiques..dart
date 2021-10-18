// ignore: file_names
import 'package:express_livreur/Widget/Drawer.dart';
import 'package:flutter/material.dart';

class Statistiques extends StatelessWidget {
  const Statistiques({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: drawer(context),
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text('Shoping express'),
        ),
        body: Container());
  }
}
