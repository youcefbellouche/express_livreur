// ignore_for_file: file_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_livreur/ApiFirebase.dart';
import 'package:express_livreur/Model/Filter.dart';
import 'package:express_livreur/Model/Order.dart';
import 'package:express_livreur/Widget/Drawer.dart';
import 'package:express_livreur/Widget/OrderCard.dart';
import 'package:express_livreur/FirebasePushNotif.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    FlutterAppBadger.removeBadge();

    FirabasePushNotif.initialize(onSelectedNotification)
        .then((value) => fcml());

    saveToken();
    fetchData();
  }

  void fcml() async {
    FirabasePushNotif.onMessage
        .listen(FirabasePushNotif.invokeLocalNotification);
    FirabasePushNotif.onMessageOpenedApp.listen(_pageOpen);
  }

  _pageOpen(RemoteMessage remote) {
    final Map<String, dynamic> mes = remote.data;
    onSelectedNotification(jsonEncode(mes));
  }

  Future onSelectedNotification(String? payload) async {
    // ignore: avoid_print
    print(payload);
  }

  saveToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    await FirebaseFirestore.instance
        .collection('Tokens')
        .doc("livreur")
        .update({
      "tokens": FieldValue.arrayUnion([token])
    });
  }

  TextEditingController idController = TextEditingController();

  Filter? sort;

  APIFirebase apiFirebase = APIFirebase();

  bool loading = true;

  List<Order> data = [];

  bool dateShow = false;
  int page = 1;

  fetchData({String? status, DateTime? time1, DateTime? time2}) async {
    data =
        await apiFirebase.getOrders(status: status, time1: time1, time2: time2);
    setState(() {
      loading = false;
    });
  }

  fetchDataById({String? id}) async {
    data = await apiFirebase.getOrdersById(id: double.parse(id!).toInt());
    setState(() {
      loading = false;
    });
  }

  PickerDateRange? dateTime;
  DateRangePickerController dateController = DateRangePickerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context),
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Shoping express'),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Scrollbar(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: idController,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.black),
                          prefixIcon: const Icon(Icons.search),
                          hintText: "N° de Commande",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none),
                          fillColor: const Color(0xffe6e6ec),
                          filled: true,
                        ),
                        onChanged: (value) {
                          if (value.contains(RegExp(r'[0-9]'))) {
                            fetchDataById(id: value);
                          } else {
                            idController.clear();
                          }
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            dateShow = !dateShow;
                          });
                        },
                        icon: const Icon(Icons.date_range)),
                    PopupMenuButton<Filter>(
                        onSelected: (Filter sortBy) {
                          setState(() {
                            sort = sortBy;

                            fetchData(
                                status: sort!.value,
                                time1: dateTime?.startDate,
                                time2: dateTime?.endDate);
                            idController.clear();
                          });
                        },
                        icon: const Icon(Icons.tune),
                        itemBuilder: (BuildContext context) {
                          return sortByOptions.map((item) {
                            return PopupMenuItem<Filter>(
                                value: item, child: Text(item.text));
                          }).toList();
                        })
                  ],
                ),
              ),
              dateShow
                  ? Card(
                      margin: const EdgeInsets.all(12),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SfDateRangePicker(
                            onSelectionChanged:
                                (DateRangePickerSelectionChangedArgs args) {
                              setState(() {
                                dateTime = PickerDateRange(
                                    args.value.startDate, args.value.endDate);
                              });
                              if (args.value.startDate != null &&
                                  args.value.endDate != null) {
                                setState(() {
                                  loading = true;
                                });
                                fetchData(
                                    time1: dateTime?.startDate,
                                    time2: dateTime?.endDate);
                              }
                            },
                            controller: dateController,
                            maxDate: DateTime.now(),
                            minDate: DateTime(2021),
                            selectionMode: DateRangePickerSelectionMode.range,
                            monthViewSettings:
                                const DateRangePickerMonthViewSettings(
                                    firstDayOfWeek: 7),
                            view: DateRangePickerView.month,
                          )),
                    )
                  : Container(),
              Container(
                padding: const EdgeInsets.only(bottom: 12),
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return OrderCard(
                            data: data[index],
                          );
                        }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
