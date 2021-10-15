// ignore_for_file: file_names
// ignore: must_be_immutable
import 'package:express_livreur/Model/Order.dart';
import 'package:express_livreur/Screen/Order/OrderInfo.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OrderCard extends StatelessWidget {
  OrderCard({Key? key, required this.data}) : super(key: key);

  Order data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderInfo(
                      order: data,
                    )));
      },
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 3),
              color: Colors.blue,
              borderRadius: const BorderRadius.all(
                Radius.circular(13),
              )),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(12),
          height: 145,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Text(
                    'id : ',
                    style: TextStyle(fontSize: 16),
                  ),
                  SelectableText(
                    data.id.toString(),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Nom Complet : ',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: SelectableText(
                      data.user!.firstName.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Produit : ',
                    style: TextStyle(fontSize: 18),
                  ),
                  SelectableText(
                    data.product!.name.toString(),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Quantité : ',
                    style: TextStyle(fontSize: 18),
                  ),
                  SelectableText(
                    data.product!.quantity.toString(),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
