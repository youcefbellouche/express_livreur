// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_livreur/Model/Paiement.dart';
import 'package:express_livreur/Screen/Paiement/Recouvert-Info.dart';
import 'package:express_livreur/Widget/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class Recouvert extends StatelessWidget {
  const Recouvert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context),
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Recouverts'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('Recouvert').get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                Paiement paiement = Paiement.fromJson(
                    snapshot.data!.docs[index].data() as Map<String, dynamic>);
                return GestureDetector(
                  onTap: () => Get.to(() => RecouvertInfo(paiement: paiement)),
                  child: Container(
                    height: 60,
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                        'Paiement n°${index + 1} : ${paiement.benefice} DA',
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlign: TextAlign.left),
                  ),
                );
              },
              itemCount: snapshot.data!.docs.length,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
