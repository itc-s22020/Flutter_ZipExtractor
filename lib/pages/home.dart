import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zip_extractor/getX/file_controller.dart';
import 'package:zip_extractor/components/file_pick.dart';
import 'package:zip_extractor/getX/navigation.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    FileController fileC = Get.put(FileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('File Extractor'),
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
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (fileC.file.value.isEmpty)
                          const Text(
                            'Please select a file',
                            style: TextStyle(fontSize: 18),
                          ),
                        if (fileC.file.value.isNotEmpty)
                          Text(
                            fileC.name.value,
                            style: const TextStyle(fontSize: 18),
                          ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.file_upload, color: Colors.white),
                          label: const Text("Select File"),
                          onPressed: () async {
                            await filePick();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue.shade700,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => ElevatedButton.icon(
              icon: const Icon(Icons.navigate_next, color: Colors.white),
              label: const Text("Next Page"),
              onPressed: fileC.file.value.isEmpty ? null : toResultPage,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange.shade600,
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
}
