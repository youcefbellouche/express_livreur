// ignore_for_file: file_names

// ignore_for_file: invalid_use_of_protected_member

import 'package:express_livreur/Model/Order.dart';
import 'package:flutter/material.dart';

import 'package:get/state_manager.dart';

import '../ApiFirebase.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();

  RxList<Order> data = <Order>[].obs;
  APIFirebase apiFirebase = APIFirebase();

  RxBool loadingProduct = true.obs;
  RxBool loadingPag = false.obs;
  int page = 1;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    fetchData(null);
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      loadingPag.value = true;

      // refetchData();
    }
  }

  fetchData(String? status) async {
    data.value = await apiFirebase.getOrders(status: status);
    loadingProduct.value = false;
    page++;
    update();
  }
}
