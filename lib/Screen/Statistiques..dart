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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context),
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Shoping express'),
      ),
      body: Column(
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
                      await FirebaseFirestore.instance
                          .collection('Stats')
                          .where('time',
                              isGreaterThanOrEqualTo:
                                  dateTime!.startDate!.millisecondsSinceEpoch)
                          .where('time',
                              isLessThanOrEqualTo:
                                  dateTime!.endDate!.millisecondsSinceEpoch)
                          .get()
                          .then((value) {
                        // ignore: avoid_print
                        print(value.docs.length);
                        for (var element in value.docs) {
                          Stat tempStat = Stat.fromJson(element.data());
                          stat?.enLivraison = tempStat.enLivraison;
                        }
                      });
                    }
                  },
                  controller: dateController,
                  maxDate: DateTime.now(),
                  minDate: DateTime(2021),
                  monthViewSettings:
                      const DateRangePickerMonthViewSettings(firstDayOfWeek: 7),
                  view: DateRangePickerView.month,
                )),
          ),
        ],
      ),
    );
  }
}
