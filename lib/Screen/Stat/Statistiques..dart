// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_livreur/Model/Stat.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:express_livreur/Widget/Drawer.dart';
import 'package:flutter/material.dart';

class Statistiques extends StatefulWidget {
  const Statistiques({Key? key}) : super(key: key);

  @override
  State<Statistiques> createState() => _StatistiquesState();
}

class _StatistiquesState extends State<Statistiques> {
  PickerDateRange? dateTime;
  DateRangePickerController dateController = DateRangePickerController();
  Stat? stat;
  int livrer = 0;
  int enLivraison = 0;
  int annuler = 0;
  double total = 0;
  double coutLivraison = 0;
  double coutAnnuler = 0;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context),
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Shoping express'),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    margin: const EdgeInsets.all(12),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SfDateRangePicker(
                          selectionMode: DateRangePickerSelectionMode.range,
                          onSelectionChanged:
                              (DateRangePickerSelectionChangedArgs args) async {
                            setState(() {
                              dateTime = PickerDateRange(
                                  args.value.startDate, args.value.endDate);
                            });
                            if (dateTime!.startDate != null &&
                                dateTime!.endDate != null) {
                              setState(() {
                                loading = true;
                              });
                              await FirebaseFirestore.instance
                                  .collection('Stats')
                                  .where('time',
                                      isGreaterThanOrEqualTo: dateTime!
                                          .startDate!.millisecondsSinceEpoch)
                                  .where('time',
                                      isLessThanOrEqualTo: dateTime!
                                              .endDate!.millisecondsSinceEpoch +
                                          86399999)
                                  .get()
                                  .then((value) {
                                // ignore: avoid_print
                                livrer = 0;
                                enLivraison = 0;
                                annuler = 0;
                                total = 0.0;
                                coutAnnuler = 0.0;
                                coutLivraison = 0.0;
                                for (var element in value.docs) {
                                  Stat tempStat = Stat.fromJson(element.data());
                                  if (tempStat.livrer != null) {
                                    livrer += tempStat.livrer!;
                                  }
                                  if (tempStat.enLivraison != null) {
                                    enLivraison += tempStat.enLivraison!;
                                  }
                                  if (tempStat.annuler != null) {
                                    annuler += tempStat.annuler!;
                                  }
                                  if (tempStat.total != null) {
                                    total += tempStat.total!;
                                  }
                                  if (tempStat.coutLivraison != null) {
                                    coutLivraison += tempStat.coutLivraison!;
                                  }
                                  if (tempStat.coutAnnuler != null) {
                                    coutAnnuler += tempStat.coutAnnuler!;
                                  }
                                }
                                dateTime = null;
                                setState(() {
                                  livrer = livrer;
                                  enLivraison = enLivraison;
                                  annuler = annuler;
                                  total = total;
                                  loading = false;
                                });
                              });
                            }
                          },
                          controller: dateController,
                          maxDate: DateTime.now(),
                          minDate: DateTime(2021),
                          monthViewSettings:
                              const DateRangePickerMonthViewSettings(
                                  firstDayOfWeek: 7),
                          view: DateRangePickerView.month,
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 3),
                        color: Colors.blue,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(13),
                        )),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(5),
                    child: Text(
                      "Livrer  : $livrer",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 3),
                        color: Colors.blue,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(13),
                        )),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(5),
                    child: Text("Annuler  : $annuler",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 3),
                        color: Colors.blue,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(13),
                        )),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(5),
                    child: Text("En livraison  : $enLivraison",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 3),
                        color: Colors.blue,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(13),
                        )),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(5),
                    child: Text("Total  : $total",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 3),
                        color: Colors.blue,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(13),
                        )),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(5),
                    child: Text("Cout livraison  : $coutLivraison",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 3),
                        color: Colors.blue,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(13),
                        )),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(5),
                    child: Text("cout Retour  : $coutAnnuler",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
            ),
    );
  }
}
