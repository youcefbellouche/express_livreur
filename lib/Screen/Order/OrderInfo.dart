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
                            await _makePhoneCall(
                                "tel:${widget.order.user!.phone}");
                          },
                          label: 'Numero de telephone',
                          read: true,
                          textInputType: TextInputType.phone,
                          value: widget.order.user!.phone,
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
                          label: 'Status',
                          read: true,
                          value: widget.order.status,
                          onChanged: (input) {
                            widget.order.status = input;
                          },
                        ),
                        CustomField(
                          label: 'Produit',
                          read: true,
                          value: widget.order.product!.name,
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
                          value: widget.order.note,
                        ),
                        CustomField(
                          label: 'Total a ramasser',
                          read: false,
                          value: widget.order.totalRammaser,
                        ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Column(
                          children: [
                            CustomField(
                              label: 'Couleur',
                              read: false,
                              value: widget.order.variable![index]['color'],
                            ),
                            CustomField(
                              label: 'qte',
                              read: false,
                              value: widget.order.variable![index]['qte']
                                  .toString(),
                            ),
                          ],
                        );
                      },
                      childCount: widget.order.variable!.length,
                    ),
                  ),
                  widget.order.status == 'en attente' ||
                          widget.order.status == 'en livraison'
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
                                    bool liv =
                                        widget.order.status == 'en attente'
                                            ? false
                                            : true;
                                    setState(() {
                                      loading = true;

                                      widget.order.status = "annuler";
                                    });
                                    await apiFirebase.updateOrder(
                                        status: widget.order.status!,
                                        id: widget.order.id.toString());
                                    liv
                                        ? annulerStockafterLivraison()
                                        : annulerStockafterAttente();

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
                      : SliverToBoxAdapter(child: Container())
                ],
              ),
            ),
    );
  }

  Future valideOrder() async {
    await apiFirebase.updateOrder(
      status: widget.order.status!,
      id: widget.order.id.toString(),
    );
    if (widget.order.status == 'en livraison') {
      await livraisonStock();
    }
    if (widget.order.status == 'livré') {
      await liverStock();
    }
  }

  Future liverStock() async {
    Map<String, dynamic> data = {
      'enLivraison': FieldValue.increment(
          -1 * int.parse(widget.order.product!.quantity.toString())),
      'qte': FieldValue.increment(
          -1 * int.parse(widget.order.product!.quantity.toString())),
    };
    Map<String, dynamic> temp = {};
    if (widget.order.variable != null) {
      for (var element in widget.order.variable!) {
        data.addAll({
          'enLivraison-${element['color']}':
              FieldValue.increment(-1 * num.parse(element['qte'].toString())),
          'Livrer-${element['color']}':
              FieldValue.increment(num.parse(element['qte'].toString())),
        });
        temp.addAll({
          element['color']:
              FieldValue.increment(-1 * num.parse(element['qte'].toString())),
        });
      }
      data.addAll({'couleur': temp});
    }
    FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.order.product!.id.toString())
        .set(
          data,
          SetOptions(merge: true),
        );
  }

  Future annulerStockafterLivraison() async {
    Map<String, dynamic> data = {
      'annuler': FieldValue.increment(
          int.parse(widget.order.product!.quantity.toString())),
      'enLivraison': FieldValue.increment(
          -1 * int.parse(widget.order.product!.quantity.toString())),
    };
    if (widget.order.variable != null) {
      for (var element in widget.order.variable!) {
        data.addAll({
          'enLivraison-${element['color']}':
              FieldValue.increment(-1 * num.parse(element['qte'].toString())),
          'Annuler-${element['color']}':
              FieldValue.increment(num.parse(element['qte'].toString())),
        });
      }
    }
    FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.order.product!.id.toString())
        .set(
          data,
          SetOptions(merge: true),
        );
  }

  Future annulerStockafterAttente() async {
    Map<String, dynamic> data = {
      'annuler': FieldValue.increment(
          int.parse(widget.order.product!.quantity.toString())),
      'encours': FieldValue.increment(
          -1 * int.parse(widget.order.product!.quantity.toString())),
    };
    if (widget.order.variable != null) {
      for (var element in widget.order.variable!) {
        data.addAll({
          'Annuler-${element['color']}':
              FieldValue.increment(num.parse(element['qte'].toString())),
        });
      }
    }
    FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.order.product!.id.toString())
        .set(
          data,
          SetOptions(merge: true),
        );
  }

  Future livraisonStock() async {
    Map<String, dynamic> data = {
      'encours': FieldValue.increment(
          -1 * int.parse(widget.order.product!.quantity.toString())),
      'enLivraison': FieldValue.increment(
          int.parse(widget.order.product!.quantity.toString())),
    };
    if (widget.order.variable != null) {
      for (var element in widget.order.variable!) {
        data.addAll({
          'enLivraison-${element['color']}':
              FieldValue.increment(num.parse(element['qte'].toString())),
        });
      }
    }
    FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.order.product!.id.toString())
        .set(
          data,
          SetOptions(merge: true),
        );
  }
}
