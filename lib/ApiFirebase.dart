// ignore_for_file: file_names

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

import 'package:express_livreur/Model/Order.dart';

import 'config.dart';

class APIFirebase {
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

  Future<List<Order>> getOrders({String? status}) async {
    List<Order> data = [];

    try {
      if (status != null && status != "all") {
        print(status);
        await FirebaseFirestore.instance
            .collection('Orders')
            .where("status", isEqualTo: status.toLowerCase())
            .get()
            .then((value) {
          for (var element in value.docs) {
            data.add(Order.fromJson(element.data()));
          }
        });
      } else {
        print(2);
        await FirebaseFirestore.instance
            .collection('Orders')
            .get()
            .then((value) {
          for (var element in value.docs) {
            data.add(Order.fromJson(element.data()));
          }
        });
      }
    } on DioError catch (e) {
      // ignore: avoid_print
      print("youcef ${e.message}");
    }

    return data;
  }

  Future updateOrder({required String statut, required String id}) async {
    try {
      await FirebaseFirestore.instance
          .collection('Orders')
          .doc(id)
          .update({"status": statut});
    } on DioError catch (e) {
      // ignore: avoid_print
      print(e.message);
    }
  }
}
