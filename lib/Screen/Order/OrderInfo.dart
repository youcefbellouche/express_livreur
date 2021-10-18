// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_livreur/ApiFirebase.dart';
import 'package:express_livreur/Model/Order.dart';
import 'package:express_livreur/Widget/Button.dart';
import 'package:express_livreur/Widget/Field.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class OrderInfo extends StatefulWidget {
  OrderInfo({Key? key, required this.order}) : super(key: key);

  Order order;

  @override
  State<OrderInfo> createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  final APIFirebase apiFirebase = APIFirebase();

  bool loading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController totalRController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shoping express'),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: formKey,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        CustomField(
                          label: 'Nom Complet',
                          read: true,
                          value: widget.order.user!.firstName,
                        ),
                        CustomField(
                          onTap: () async {
                            print("test");
                            await _makePhoneCall(
                                "tel:${widget.order.user!.phone}");
                          },
                          label: 'Numero de telephone',
                          read: true,
                          textInputType: TextInputType.phone,
                          value: widget.order.user!.phone,
                        ),
                        CustomField(
                          label: 'Status',
                          read: true,
                          value: widget.order.status,
                          onChanged: (input) {
                            widget.order.status = input;
                          },
                        ),
                        CustomField(
                          label: 'Wilaya',
                          read: true,
                          value: widget.order.user!.state,
                        ),
                        CustomField(
                          label: 'Cité',
                          read: true,
                          value: widget.order.user!.city,
                        ),
                        CustomField(
                          label: 'Adresse',
                          read: true,
                          value: widget.order.user!.address,
                        ),
                        CustomField(
                          label: 'Produit',
                          read: true,
                          value: widget.order.product!.name,
                        ),
                        CustomField(
                          label: 'Prix du produit',
                          read: true,
                          value: widget.order.product!.priceU.toString(),
                        ),
                        CustomField(
                          label: 'Quantité',
                          read: false,
                          onChanged: (input) {
                            widget.order.product!.quantity = int.parse(input);
                          },
                          value: widget.order.product!.quantity.toString(),
                        ),
                        CustomField(
                          label: 'Note',
                          read: false,
                          onChanged: (input) {
                            widget.order.note = input;
                          },
                        ),
                        CustomField(
                          label: 'Total a ramasser',
                          read: false,
                          textInputType: TextInputType.number,
                          validator: (input) {
                            if (input!.isEmpty) {
                              return "Donner le total a rammaser";
                            }

                            return null;
                          },
                          controller: totalRController,
                        ),
                      ],
                    ),
                  ),
                  (widget.order.status == 'en attente' ||
                          widget.order.status == 'en livraison')
                      ? SliverPadding(
                          padding: const EdgeInsets.only(bottom: 24),
                          sliver: SliverToBoxAdapter(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Abutton(
                                  size: const Size(150, 50),
                                  onpressed: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    // await apiFirebase.updateOrder(
                                    //     statut: 'annuler',
                                    //     id: widget.order.id.toString());

                                    setState(() {
                                      loading = false;
                                    });
                                  },
                                  child: const Text('Annuler'),
                                  colors: Colors.redAccent,
                                ),
                                Abutton(
                                  size: const Size(150, 50),
                                  onpressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      setState(() {
                                        loading = true;
                                        widget.order.totalRammaser =
                                            totalRController.value.text;
                                        widget.order.note =
                                            noteController.value.text;
                                        widget.order.status == "en attente"
                                            ? widget.order.status =
                                                'en livraison'
                                            : widget.order.status = 'livré';
                                      });

                                      await valideOrder();

                                      setState(() {
                                        loading = false;
                                      });
                                    }
                                  },
                                  child: widget.order.status == "en attente"
                                      ? const Text('En livraison')
                                      : const Text('Livré'),
                                  colors: Colors.green,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
    );
  }

  Future valideOrder() async {
    await apiFirebase.updateOrder(
        status: widget.order.status!, id: widget.order.id.toString());
  }
}
