import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:zip_extractor/pages/home.dart';
import 'package:zip_extractor/pages/result.dart';

void toHomePage() => Get.offAll(() => const Home(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300));
void toResultPage() => Get.to(() => const Result(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300));