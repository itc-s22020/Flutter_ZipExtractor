import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import '../getX/file_controller.dart';
import '../getX/zip_controller.dart';
import '../components/web_zip_extractor.dart';

Future<void> filePick() async {
  // FileControllerのインスタンスを取得
  FileController fileController = Get.put(FileController());

  // FilePickerを使用してファイルを選択
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    withData: true,
  );

  if (result != null) {
    print("zipOK!");
    print(result.files.length);

    // 選択されたファイルデータをFileControllerに保存
    Uint8List? zipData = result.files.first.bytes;
    String fileName = result.files.first.name;

    if (zipData != null) {
      // FileControllerにZIPファイルを保存
      fileController.setFile(zipData);
      fileController.setName(fileName);

      // 解凍処理
      try {
        // WebZipExtractorを使ってZIPを解凍
        final webZipExtractor = WebZipExtractor();
        final extractedFiles = await webZipExtractor.extractZip(zipData);

        // 解凍したファイルをZipControllerに保存
        ZipController zipController = Get.put(ZipController());
        zipController.setZipFiles(extractedFiles);

        print("解凍したファイル数: ${extractedFiles.length}");
      } catch (e) {
        print("解凍エラー: $e");
      }
    }
  } else {
    print("ファイルが選択されませんでした");
  }
}
