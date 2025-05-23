import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class SitemarkerPageViewOmio extends StatefulWidget {
  const SitemarkerPageViewOmio({super.key});

  @override
  State<SitemarkerPageViewOmio> createState() => _SitemarkerPageViewOmioState();
}

class _SitemarkerPageViewOmioState extends State<SitemarkerPageViewOmio> {
  late File? fpath;
  late bool isImporting = false;
  late bool isViewing = false;
  @override
  Widget build(BuildContext context) {
    if (fpath != null) {}
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Sitemarker"),
        elevation: 10,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['omio'],
                );
                if (result != null) {
                  setState(() {
                    isImporting = true;
                    fpath = File(result.files.single.path!);
                  });
                }
              },
              child: const Text("Import Omio"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['omio'],
                );
                if (result != null) {
                  setState(() {
                    isViewing = true;
                    fpath = File(result.files.single.path!);
                  });
                }
              },
              child: const Text("View Omio"),
            ),
          ],
        ),
      ),
    ));
  }
}
