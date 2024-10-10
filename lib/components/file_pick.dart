import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'dart:typed_data';

import 'package:zip_extractor/getX/file_controller.dart';


Future<void> filePick() async {
  FileController c = Get.put(FileController());

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    withData: true,
  );

  if (result != null) {
    c.setFile(result.files.first.bytes ?? Uint8List(0));
  } else {
    return;
  }
}