import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import '../getX/zip_controller.dart';
import 'dart:convert';
import 'package:archive/archive.dart';  // archiveパッケージを使ってZIPを作成

class Result extends StatelessWidget {
  const Result({super.key});

  void _downloadFile(Uint8List fileData, String fileName) {
    final blob = html.Blob([fileData]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  // ZIP全体をダウンロードする
  void _downloadZip(Uint8List zipData, String fileName) {
    final blob = html.Blob([zipData]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  // フォルダ内の全てのファイルを一つのZIPファイルにまとめてダウンロード
  void _downloadFolderAsZip(Map<String, dynamic> folderData, String folderName) {
    final zip = Archive();

    // フォルダ内のファイルを再帰的に追加
    _addFolderToZip(folderData, '', zip);

    // ZIPファイルを作成
    final encoder = ZipEncoder();
    final zipData = encoder.encode(zip);
    _downloadZip(Uint8List.fromList(zipData!), "$folderName.zip");  // フォルダ名でZIPを作成
  }

  // フォルダ内の全ファイルをZIPに追加
  void _addFolderToZip(Map<String, dynamic> folderData, String parentPath, Archive zip) {
    folderData.forEach((key, value) {
      final currentPath = parentPath.isEmpty ? key : '$parentPath/$key';

      if (value is Map<String, dynamic>) {
        // サブフォルダの場合、再帰的に呼び出す
        _addFolderToZip(value, currentPath, zip);
      } else {
        final zipC = Get.find<ZipController>();
        final fileEntry = zipC.zipFiles[key];
        if (fileEntry != null) {
          zip.addFile(ArchiveFile.noCompress(currentPath, fileEntry.length, fileEntry));
        }
      }
    });
  }

  void _previewFile(BuildContext context, String fileName, Uint8List fileData) {
    if (fileName.endsWith('.txt') ||
        fileName.endsWith('.md') ||
        fileName.endsWith('.py') ||
        fileName.endsWith('.dart') ||
        fileName.endsWith('.java') ||
        fileName.endsWith('.ts') ||
        fileName.endsWith('.js')) {
      try {
        final content = utf8.decode(fileData);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(fileName),
            content: SingleChildScrollView(child: Text(content)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to decode the file.")),
        );
      }
    } else if (fileName.endsWith('.png') ||
        fileName.endsWith('.jpeg') ||
        fileName.endsWith('.jpg') ||
        fileName.endsWith('.gif') ||
        fileName.endsWith('.webp')) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(fileName),
          content: SingleChildScrollView(
            child: Image.memory(fileData),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("File preview not supported")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final ZipController zipC = Get.put(ZipController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('ZipExtractor Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(() {
                    if (zipC.zip.value.isEmpty) {
                      return const Center(
                        child: Text(
                          'No ZIP file loaded',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    } else {
                      final extractedFiles = zipC.zipFiles;
                      final treeData = _buildTreeData(extractedFiles.keys.toList());

                      return ListView(
                        children: _buildTree(treeData),
                      );
                    }
                  }),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => ElevatedButton.icon(
              icon: const Icon(Icons.download, color: Colors.white),
              label: const Text("Download All"),
              onPressed: zipC.zip.value.isEmpty
                  ? null
                  : () {
                _downloadZip(zipC.getZip(), "extracted_files.zip");
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue.shade700,
                padding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 24),
                textStyle: const TextStyle(fontSize: 16),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _buildTreeData(List<String> paths) {
    final tree = <String, dynamic>{};

    for (final path in paths) {
      List<String> parts = path.split('/');
      Map<String, dynamic> current = tree;

      for (int i = 0; i < parts.length; i++) {
        final part = parts[i];
        if (i == parts.length - 1) {
          current[part] = null;
        } else {
          current = current.putIfAbsent(part, () => <String, dynamic>{});
        }
      }
    }

    return tree;
  }

  List<Widget> _buildTree(Map<String, dynamic> tree, [int level = 0]) {
    final widgets = <Widget>[];

    tree.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        widgets.add(
          Padding(
            padding: EdgeInsets.only(left: 16.0 * level),
            child: GestureDetector(
              onLongPress: () {
                // フォルダを長押しでダウンロード
                _downloadFolderAsZip(value, key);  // フォルダ名でZIPを作成
              },
              child: ExpansionTile(
                leading: const Icon(Icons.folder, color: Colors.amber),
                title: Text(
                  key,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0 - level,
                  ),
                ),
                children: _buildTree(value, level + 1),
              ),
            ),
          ),
        );
      } else {
        widgets.add(
          Padding(
            padding: EdgeInsets.only(left: 16.0 * (level + 1)),
            child: ListTile(
              leading: const Icon(Icons.insert_drive_file, color: Colors.grey),
              title: Text(
                key,
                style: const TextStyle(fontSize: 14),
              ),
              onTap: () {
                final zipC = Get.find<ZipController>();
                final entry = zipC.zipFiles.entries
                    .firstWhere(
                      (entry) => entry.key.endsWith(key),
                  orElse: () => MapEntry('', Uint8List(0)), // デフォルト値
                );

                if (entry.key.isNotEmpty) {
                  _previewFile(Get.context!, key, entry.value);
                } else {
                  ScaffoldMessenger.of(Get.context!).showSnackBar(
                    SnackBar(content: Text('File not found: $key')),
                  );
                }
              },
              trailing: IconButton(
                icon: const Icon(Icons.download, color: Colors.blue),
                onPressed: () {
                  final zipC = Get.find<ZipController>();
                  final entry = zipC.zipFiles.entries
                      .firstWhere(
                        (entry) => entry.key.endsWith(key),
                    orElse: () => MapEntry('', Uint8List(0)), // デフォルト値
                  );

                  if (entry.key.isNotEmpty) {
                    _downloadFile(entry.value, key);
                  } else {
                    ScaffoldMessenger.of(Get.context!).showSnackBar(
                      SnackBar(content: Text('File not found: $key')),
                    );
                  }
                },
              ),
            ),
          ),
        );
      }
    });

    return widgets;
  }
}
