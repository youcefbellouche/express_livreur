// ignore_for_file: file_names

import 'package:express_livreur/Screen/Order/Home.dart';
import 'package:express_livreur/Screen/Statistiques..dart';
import 'package:get/get.dart';

final List<GetPage> routes = [
  GetPage(
    name: '/',
    page: () => const Home(),
  ),
  GetPage(
    name: '/Stats',
    page: () => const Statistiques(),
  ),
];
