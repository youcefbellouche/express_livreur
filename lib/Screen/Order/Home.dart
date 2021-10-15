// ignore_for_file: file_names

import 'package:express_livreur/Controller/HomeController.dart';
import 'package:express_livreur/Widget/Drawer.dart';
import 'package:express_livreur/Widget/OrderCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (c) => Scaffold(
              drawer: drawer(),
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                title: const Text('Shoping express'),
              ),
              body: Container(
                padding: const EdgeInsets.only(bottom: 12),
                child: c.loadingProduct.value
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: EdgeInsets.only(
                            top: AppBar().preferredSize.height * 2),
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
                                        // controller: _searchQuery,
                                        decoration: InputDecoration(
                                          hintStyle:
                                              TextStyle(color: Colors.black),
                                          prefixIcon: Icon(Icons.search),
                                          hintText: "N° de Commande".tr,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: BorderSide.none),
                                          fillColor: Color(0xffe6e6ec),
                                          filled: true,
                                        ),
                                        onChanged: (value) {
                                          if (value.isNotEmpty) {
                                            // orderId = value;
                                          }
                                        },
                                      ),
                                    ),
                                    // PopupMenuButton(
                                    //     onSelected: (dynamic sortBy) {
                                    //       c.setSelected(sortBy);
                                    //     },
                                    //     icon: Icon(Icons.tune),
                                    //     itemBuilder: (BuildContext context) {
                                    //       return _sortByOptions.map((item) {
                                    //         return PopupMenuItem(
                                    //             value: item.value,
                                    //             child: Container(
                                    //                 child: Text(item.text)));
                                    //       }).toList();
                                    //     })
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                    controller: c.scrollController,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: c.data.length,
                                    itemBuilder: (context, index) {
                                      return OrderCard(
                                        data: c.data[index],
                                      );
                                    }),
                              ),
                              c.loadingPag.value
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
              ),
            ));
  }
}
