// ignore_for_file: file_names

import 'package:express_livreur/Screen/Stat/Statistiques..dart';
import 'package:get/get.dart';

import 'Screen/Order/Home.dart';
import 'Screen/Paiement/NonRecouvert.dart';
import 'Screen/Paiement/Recouvert.dart';

final List<GetPage> routes = [
  GetPage(
    name: '/',
    page: () => const Home(),
  ),
  GetPage(
    name: '/Stats',
    page: () => const Statistiques(),
  ),
  GetPage(
    name: '/NonRecouvert',
    page: () => const NonRecouvert(),
  ),
  GetPage(
    name: '/Recouvert',
    page: () => const Recouvert(),
  ),
];
