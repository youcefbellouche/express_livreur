// ignore_for_file: file_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:express_livreur/Model/Order.dart';

class APIFirebase {
  Future sendMessage(
    token,
    String message,
  ) async {
    await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAA9w_Eel4:APA91bEOeKeAJll-D3J1vFLc1KPVt_lm7bol5AJdhNso985winCUj7eQxstEgyrUdvCQZimSj-ZrBAxE8m4ljBEc5vZbl6rLr_OxLF0QL2lMTGHGN6gionoDKucXaIzc9hO6jXgnosNw',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            "title": 'Express Shopping',
            "body": message,
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token
        },
      ),
    );
  }

  Future annuler(DateTime time, double coutAnnuler) async {
    await FirebaseFirestore.instance
        .collection('Stats')
        .doc('${time.year}-${time.month}-${time.day}')
        .set({
      "annuler": FieldValue.increment(1),
      'time': DateTime(time.year, time.month, time.day).millisecondsSinceEpoch,
      'coutAnnuler': FieldValue.increment(coutAnnuler),
    }, SetOptions(merge: true));
  }

  Future livrer(DateTime time, double total, double coutLivraison) async {
    await FirebaseFirestore.instance
        .collection('Stats')
        .doc('${time.year}-${time.month}-${time.day}')
        .set({
      "livrer": FieldValue.increment(1),
      "total": FieldValue.increment(total),
      'coutLivraison': FieldValue.increment(coutLivraison),
      'time': DateTime(time.year, time.month, time.day).millisecondsSinceEpoch
    }, SetOptions(merge: true));
  }

  Future enLivraison(
    DateTime time,
  ) async {
    await FirebaseFirestore.instance
        .collection('Stats')
        .doc('${time.year}-${time.month}-${time.day}')
        .set({
      "en livraison": FieldValue.increment(1),
      'time': DateTime(time.year, time.month, time.day).millisecondsSinceEpoch,
    }, SetOptions(merge: true));
  }

  Future<List<Order>> getOrdersById({int? id}) async {
    List<Order> data = [];

    try {
      await FirebaseFirestore.instance
          .collection('Orders')
          .where("id", isEqualTo: id)
          .get()
          .then((value) {
        for (var element in value.docs) {
          data.add(Order.fromJson(element.data()));
        }
      });
    } on DioError catch (e) {
      // ignore: avoid_print
      print("youcef ${e.message}");
    }

    return data;
  }

  Future<List<Order>> getOrders({String? status, DateTime? time}) async {
    List<Order> data = [];
    try {
      if (status != null && status != "all") {
        if (time != null) {
          await FirebaseFirestore.instance
              .collection('Orders')
              .where("status", isEqualTo: status.toLowerCase())
              .where('time', isEqualTo: time.millisecondsSinceEpoch)
              .get()
              .then((value) {
            for (var element in value.docs) {
              data.add(Order.fromJson(element.data()));
            }
          });
        } else {
          await FirebaseFirestore.instance
              .collection('Orders')
              .where("status", isEqualTo: status.toLowerCase())
              .get()
              .then((value) {
            for (var element in value.docs) {
              data.add(Order.fromJson(element.data()));
            }
          });
        }
      } else {
        if (time != null) {
          await FirebaseFirestore.instance
              .collection('Orders')
              .where('time', isEqualTo: time.millisecondsSinceEpoch)
              .get()
              .then((value) {
            for (var element in value.docs) {
              data.add(Order.fromJson(element.data()));
            }
          });
        } else {
          await FirebaseFirestore.instance
              .collection('Orders')
              .get()
              .then((value) {
            for (var element in value.docs) {
              data.add(Order.fromJson(element.data()));
            }
          });
        }
      }
    } on DioError catch (e) {
      // ignore: avoid_print
      print("youcef ${e.message}");
    }
    return data;
  }

  Future updateOrder(
      {required String status,
      required String id,
      double? total,
      double? coutLivraison,
      double? coutAnnuler}) async {
    try {
      if (status == 'en livraison') {
        await FirebaseFirestore.instance.collection('Orders').doc(id).update({
          "status": status,
          'dateEnlivraison': DateTime.now().millisecondsSinceEpoch
        });
        await enLivraison(
          DateTime.now(),
        );
      }
      if (status == 'livré') {
        await FirebaseFirestore.instance.collection('Orders').doc(id).update({
          "status": status,
          'coutLivraison': coutLivraison,
          'dateLivrer': DateTime.now().millisecondsSinceEpoch
        });
        await livrer(DateTime.now(), total!, coutLivraison!);
      }
      if (status == 'annuler') {
        await FirebaseFirestore.instance.collection('Orders').doc(id).update({
          "status": status,
          'coutAnnuler': coutAnnuler,
          'dateAnnuler': DateTime.now().millisecondsSinceEpoch
        });
        await annuler(DateTime.now(), coutAnnuler!);
      }
    } on DioError catch (e) {
      // ignore: avoid_print
      print(e.message);
    }
  }
}
