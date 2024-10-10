import 'dart:typed_data';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class FileController extends GetxController{
  final Rx<Uint8List> file = Uint8List(0).obs;
  final Rx<String> name = "".obs;

  void setFile(Uint8List newData) => file.value = newData;
  void setName(String newName) => name.value = newName;
  Uint8List getFile() => file.value;
  String getName() => name.value;
}