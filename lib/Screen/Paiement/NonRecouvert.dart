// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_livreur/Config.dart';
import 'package:express_livreur/Model/Order.dart';
import 'package:express_livreur/Model/Paiement.dart';
import 'package:express_livreur/Screen/Order/OrderInfo.dart';
import 'package:express_livreur/Widget/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class NonRecouvert extends StatelessWidget {
  const NonRecouvert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Non-Recouvert')
            .doc('1')
            .get(),
        builder: (context, snpashot) {
          if (snpashot.hasData) {
            Paiement paiement = Paiement.fromJson(
                snpashot.data!.data() as Map<String, dynamic>);
            return Scaffold(
                floatingActionButton: FloatingActionButton.extended(
                    onPressed: () async {
                      if (paiement.benefice != null) {
                        print(paiement.dateDebut);
                        await FirebaseFirestore.instance
                            .collection('Recouvert')
                            .add(paiement.toJson());

                        // await FirebaseFirestore.instance
                        //     .collection('Non-Recouvert')
                        //     .doc('1')
                        //     .set({
                        //   'DateDebut': DateTime.now().millisecondsSinceEpoch,
                        //   'payer': false
                        // });
                      } else {
                        Get.snackbar('Error', "Y'a rien à payer",
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent);
                      }
                    },
                    label: const Text('PAYER')),
                drawer: drawer(context),
                backgroundColor: Colors.grey.shade200,
                appBar: AppBar(
                  title: const Text('Non recouverts'),
                ),
                body: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 70,
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Config.primaryColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        'A payer :  ${paiement.benefice ?? 0}  DA',
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Text(
                      'Liste des Colis:',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Config.primaryColor),
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            await FirebaseFirestore.instance
                                .collection('Orders')
                                .doc(paiement.commandes![index].toString())
                                .get()
                                .then((value) {
                              Order data = Order.fromJson(value.data()!);
                              Get.to(() => OrderInfo(
                                    order: data,
                                  ));
                            });
                          },
                          child: Container(
                            height: 60,
                            margin: const EdgeInsets.all(12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                                'Colis n°${index + 1} : ${paiement.commandes![index]}',
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                textAlign: TextAlign.left),
                          ),
                        );
                      },
                      itemCount: paiement.commandes?.length ?? 0,
                    ))
                  ],
                ));
          } else {
            return Scaffold(
              backgroundColor: Colors.grey.shade200,
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
