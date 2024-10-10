import 'dart:html';
import 'dart:typed_data';
import 'package:archive/archive.dart';


class WebZipExtractor {
  static const List<int> zipSignature = [0x50, 0x4B, 0x03, 0x04];

  Future<Map<String, Uint8List>> extractZip(File file) async {
    final reader = FileReader();
    reader.readAsArrayBuffer(file);

    await reader.onLoad.first;

    final bytes = Uint8List.fromList(reader.result as List<int>);

    final zipStart = findZipStart(bytes);
    if (zipStart == -1) {
      throw Exception('ZIP signature not found');
    }

    final archive = ZipDecoder().decodeBytes(bytes.sublist(zipStart));

    final extractedFiles = <String, Uint8List>{};

    for (final file in archive) {
      if (file.isFile) {
        final filename = file.name;
        final data = file.content as List<int>;
        extractedFiles[filename] = Uint8List.fromList(data);
      }
    }

    return extractedFiles;
  }

  int findZipStart(Uint8List bytes) {
    for (var i = 0; i < bytes.length - 4; i++) {
      if (bytes[i] == zipSignature[0] &&
          bytes[i + 1] == zipSignature[1] &&
          bytes[i + 2] == zipSignature[2] &&
          bytes[i + 3] == zipSignature[3]) {
        return i;
      }
    }
    return -1;
  }
}

