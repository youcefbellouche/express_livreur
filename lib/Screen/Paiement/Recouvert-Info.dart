// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_livreur/Model/Order.dart';
import 'package:express_livreur/Model/Paiement.dart';
import 'package:express_livreur/Screen/Order/OrderInfo.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../Config.dart';

class RecouvertInfo extends StatelessWidget {
  const RecouvertInfo({Key? key, required this.paiement}) : super(key: key);
  final Paiement paiement;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: const Text('Recouvert'),
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
            Container(
              height: 60,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Text(
                    'Date de paiement : ',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  Text(
                    DateTime.fromMillisecondsSinceEpoch(
                      paiement.dateFin!,
                    ).toString(),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
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
  }
}
