import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:sitemarker/core/data_helper.dart';
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';
import 'package:sitemarker/core/db/smdb_provider.dart';
import 'package:sitemarker/ui/components/card_view.dart';

class SitemarkerPageViewOmio extends StatefulWidget {
  const SitemarkerPageViewOmio({super.key});

  @override
  State<SitemarkerPageViewOmio> createState() => _SitemarkerPageViewOmioState();
}

class _SitemarkerPageViewOmioState extends State<SitemarkerPageViewOmio> {
  File? fpath;
  bool isImporting = false; // True if we are importing, false if viewing
  bool _isLoading = false; // To show a loading indicator during file processing

  // Data to display based on whether we are importing or viewing
  List<SmRecord> _recordsToDisplay = [];
  int _successImportCount = 0;
  String _statusMessage = ''; // To display general messages

  // Unified function to process the selected file based on mode
  Future<void> _processFile(
      File file, bool importMode, SmdbProvider smdbProvider) async {
    setState(() {
      _isLoading = true; // Show loading indicator
      fpath = file; // Store the file path
      isImporting = importMode; // Set the mode (import or view)
      _recordsToDisplay = []; // Clear previous data
      _successImportCount = 0;
      _statusMessage = 'Processing file...'; // Initial message
    });

    try {
      final String fileContent = await file.readAsString();
      _recordsToDisplay = DataHelper.fromOmio(fileContent);

      if (importMode) {
        // Perform the import operation
        await smdbProvider.importFromOmioFile(file); // Pass the File object

        setState(() {
          _successImportCount = smdbProvider.successImport;
          _recordsToDisplay =
              smdbProvider.importDups; // Duplicates are the records to display
          _statusMessage = "Import complete.";
          _isLoading = false;
        });
      } else {
        // Just viewing the file, data is already in _recordsToDisplay
        setState(() {
          _statusMessage = "File loaded.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = "Error processing file: $e";
        _recordsToDisplay = []; // Clear records on error
      });
      print('Error: $e');
      // Optionally show a SnackBar or AlertDialog for the user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing file: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // If a file is selected (fpath != null) and not currently loading,
    // display the import/view results.
    if (fpath != null && !_isLoading) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Sitemarker"),
            elevation: 10,
          ),
          body: CustomScrollView(
            // Use CustomScrollView for full scrollability
            slivers: [
              SliverToBoxAdapter(
                // For non-scrollable content above the list
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // Add some padding
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isImporting) ...[
                        // Content specific to importing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check),
                            const SizedBox(width: 10),
                            Text(
                                "Imported $_successImportCount records successfully."),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons
                                .info_outline), // Changed icon for duplicates
                            const SizedBox(width: 10),
                            Text(
                                "${_recordsToDisplay.length} duplicate records found."), // _recordsToDisplay now holds duplicates
                          ],
                        ),
                        const SizedBox(height: 25),
                      ] else ...[
                        // Content specific to viewing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check),
                            const SizedBox(width: 10),
                            Text(
                                "Found ${_recordsToDisplay.length} records in the file."),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons
                                .folder_open), // Changed icon for file location
                            const SizedBox(width: 10),
                            Text(
                                "File location: ${fpath!.absolute.path}"), // Display the file path
                          ],
                        ),
                        const SizedBox(height: 25),
                      ],
                      Divider(
                        height: 20,
                        thickness: 3,
                        color: Theme.of(context).disabledColor,
                      ),
                      const SizedBox(
                          height: 10), // Space before the list starts
                      if (_recordsToDisplay
                          .isEmpty) // Message if no records to display
                        Text(
                          isImporting
                              ? "All records imported successfully, no duplicates found."
                              : "The selected file is empty or contains no valid records.",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      // The actual list is below this point
                    ],
                  ),
                ),
              ),
              // Only show SliverList if there are records to display
              if (_recordsToDisplay.isNotEmpty)
                SliverList(
                  // For the scrollable list of duplicates/viewed records
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 5.0),
                        child:
                            CardBookmarkView(record: _recordsToDisplay[index]),
                      );
                    },
                    childCount: _recordsToDisplay.length,
                  ),
                ),
              // If there are no records, SliverFillRemaining is not needed as the
              // message is already in SliverToBoxAdapter. Removed to simplify.
            ],
          ),
        ),
      );
    } else if (_isLoading) {
      // Show a loading screen/indicator while processing the file
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Sitemarker"),
            elevation: 10,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(_statusMessage),
              ],
            ),
          ),
        ),
      );
    } else {
      // Initial state: no file picked, show buttons
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Sitemarker"),
            elevation: 10,
          ),
          body: Center(
            child: Consumer<SmdbProvider>(
              builder: (context, value, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            minimumSize:
                                const WidgetStatePropertyAll(Size(100, 50)),
                            shape:
                                WidgetStatePropertyAll<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['omio'],
                            );
                            if (result != null) {
                              await _processFile(
                                File(result.files.single.path!),
                                true,
                                value,
                              ); // true for import mode
                            }
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.file_download,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Import from Omio File",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            minimumSize:
                                const WidgetStatePropertyAll(Size(100, 50)),
                            shape:
                                WidgetStatePropertyAll<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['omio'],
                            );
                            if (result != null) {
                              await _processFile(
                                File(result.files.single.path!),
                                false,
                                value,
                              ); // false for view mode
                            }
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Icons.file_present,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "View Omio File",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    }
  }
}
