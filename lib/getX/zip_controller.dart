import 'dart:typed_data';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ZipController extends GetxController{
  final Rx<Uint8List> zip = Uint8List(0).obs;
  final RxMap<String, Uint8List> zipFiles = <String, Uint8List>{}.obs;

  void setZip(Uint8List newData) => zip.value = newData;
  Uint8List getZip() => zip.value;
  void setZipFiles(Map<String, Uint8List> newData) => zipFiles.assignAll(newData);
  Map<String, Uint8List> getZipFiles() => zipFiles;
}