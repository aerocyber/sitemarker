import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sitemarker/core/data_helper.dart';
import 'package:sitemarker/core/data_types/settings/sitemarker_theme.dart';
import 'dart:io';
import 'package:sitemarker/core/data_types/size_config.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';
import 'package:sitemarker/core/db/smdb_provider.dart';
import 'package:sitemarker/core/settings_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class PageSettings extends StatefulWidget {
  const PageSettings({super.key});
  final bmcUrl = 'https://buymeacoffee.com/aerocyber';
  final ghSpUrl = 'https://github.com/sponsors/aerocyber';

  @override
  State<PageSettings> createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings>
    with SingleTickerProviderStateMixin {
  final TextEditingController _DropDownThemeModeController =
      TextEditingController();

  late SitemarkerTheme theme;
  String version = '...'; // TODO: Update version

  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isCheckingForUpdate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPackageInfo();

    _animationController = AnimationController(
      vsync: this, // 'this' refers to SingleTickerProviderStateMixin
      duration: const Duration(seconds: 1), // Duration of one full spin
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController
        .dispose(); // Dispose the controller to prevent memory leaks
    super.dispose();
  }

  Future<void> _checkForUpdates() async {
    setState(() {
      _isCheckingForUpdate = true;
    });
    _animationController.repeat(); // Start spinning indefinitely

    Uri url = Uri.parse(
        'https://api.github.com/repos/aerocyber/sitemarker/releases/latest');
    try {
      http.Response r = await http.get(url);
      if (r.statusCode == 200) {
        Map<dynamic, dynamic> data = json.decode(r.body);
        if (version.compareTo(data["tag_name"]) == -1 &&
            data['prerelease'] == false) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Update Available"),
                content: const Text(
                  "A new version of Sitemarker is available.",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      launchUrl(Uri.parse(data["html_url"]));
                    },
                    child: const Text("Visit release page"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          }
        } else {
          if (!kReleaseMode) {
            // print('Latest version is already installed'); // Use print for debug
            // print(data["tag_name"]); // Use print for debug
          }
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("No updates available"),
                content: const Text(
                  "Congrats! You are already using the latest version of Sitemarker.",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          }
        }
      }
    } catch (e) {
      // print('Error checking for updates: $e'); // Use print for debug
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Failed to check for updates. Please try again later.')),
        );
      }
    } finally {
      _animationController.stop(); // Stop spinning
      setState(() {
        _isCheckingForUpdate = false;
      });
    }
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version.split('-')[0];
    });
  }

  handleDropdown(SitemarkerTheme? selection) {
    if (selection == null) {
      _DropDownThemeModeController.text = theme.name;
      selection = theme;
    }
    theme = selection;
    String themeMode = 'system';
    switch (theme) {
      case SitemarkerTheme.lightTheme:
        themeMode = 'light';
        break;
      case SitemarkerTheme.darkTheme:
        themeMode = 'dark';
        break;
      default:
        themeMode = 'system';
    }

    setState(() {
      Provider.of<SMSettingsProvider>(context, listen: false)
          .changeThemeMode(themeMode);
    });
  }

  /// Shows a confirmation dialog for soft deleting all records.
  /// Returns true if the user confirms, false otherwise.
  Future<bool?> confirmSoftDeleteAll(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Soft Delete All'),
          content: const Text(
            'Are you sure you want to soft delete ALL records? '
            'Soft deleted records can be restored later from the trash.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // User canceled
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade700, // A warning color
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // User confirmed
              },
              child: const Text('Soft Delete All'),
            ),
          ],
        );
      },
    );
  }

  /// Shows a confirmation dialog for permanently deleting all records.
  /// Returns true if the user confirms, false otherwise.
  Future<bool?> confirmPermanentDeleteAll(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible:
          false, // User must choose an option, cannot tap outside
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm PERMANENTLY Delete All'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WARNING: This action is irreversible!',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              SizedBox(height: 10),
              Text(
                'Are you absolutely sure you want to PERMANENTLY delete ALL records? '
                'All data will be lost and cannot be recovered.',
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // User canceled
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red, // Strong warning color for permanent delete
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // User confirmed
              },
              child: const Text('PERMANENTLY Delete All'),
            ),
          ],
        );
      },
    );
  }

  /// Shows a confirmation dialog for restoring all records from trash.
  /// Returns true if the user confirms, false otherwise.
  Future<bool?> confirmRestoreAllFromTrash(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Restore All Records'),
          content: const Text(
            'Are you sure you want to restore ALL records from the trash? '
            'They will become visible in your main records list again.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // User canceled
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context)
                    .primaryColor, // Use primary color or a suitable "positive" color
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // User confirmed
              },
              child: const Text('Restore All'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //? TODO: implement build
    SizeConfig().initSizes(context);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 700,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 32.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Text('Theme'),
                          const SizedBox(height: 10, width: 10),
                          DropdownMenu<SitemarkerTheme>(
                            enableSearch: true,
                            initialSelection: getInitialValueThemeMode(),
                            onSelected: handleDropdown,
                            dropdownMenuEntries: SitemarkerTheme.values
                                .map<DropdownMenuEntry<SitemarkerTheme>>((theme) {
                              return DropdownMenuEntry(
                                value: theme,
                                label: theme.themeName,
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Divider(
                    color: Theme.of(context).disabledColor,
                    thickness: 3,
                    height: 20,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer<SmdbProvider>(builder: (context, value, child) {
                        return Column(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                String? fpath = await FilePicker.platform.saveFile(
                                  dialogTitle: 'Save as',
                                  fileName: 'sitemarker.omio',
                                  type: FileType.custom,
                                  allowedExtensions: ['omio'],
                                );
                                if (fpath == null) {
                                  // Show error dialog and return
                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Error'),
                                        content: const Text('File path is null'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return;
                                }
                                File file = File(fpath);
                                file.writeAsStringSync(
                                    DataHelper.convertToOmio(
                                        value.getAllUndeletedRecords()),
                                    mode: FileMode.write);
                                if (context.mounted) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Success'),
                                      content:
                                          const Text('File exported successfully'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              style: ButtonStyle(
                                shape:
                                    WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.upload),
                                  Text("Export records as omio file")
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // Performs soft delete on all records
                                final bool? confirmed =
                                    await confirmSoftDeleteAll(context);
                                if (confirmed == null || !confirmed) {
                                  return; // User canceled
                                }
                                List<SmRecord> records =
                                    value.getAllUndeletedRecords();
                                for (int i = 0; i < records.length; i++) {
                                  value.softDeleteRecord(records[i]);
                                }
                              },
                              style: ButtonStyle(
                                shape:
                                    WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.clear),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Clear all records")
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // Performs soft delete on all records
                                final bool? confirmed =
                                    await confirmRestoreAllFromTrash(context);
                                if (confirmed == null || !confirmed) {
                                  return; // User canceled
                                }
                                List<SmRecord> records =
                                    value.getAllDeletedRecords();
                                for (int i = 0; i < records.length; i++) {
                                  value.toggleDeleteRecord(records[i]);
                                }
                              },
                              style: ButtonStyle(
                                shape:
                                    WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.restore),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Restore all records in trash")
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // Performs soft delete on all records
                                final bool? confirmed =
                                    await confirmPermanentDeleteAll(context);
                                if (confirmed == null || !confirmed) {
                                  return; // User canceled
                                }
                                List<SmRecord> records = value.getAllRecords();
                                for (int i = 0; i < records.length; i++) {
                                  value.deleteRecordPermanently(records[i]);
                                }
                              },
                              style: ButtonStyle(
                                shape:
                                    WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.delete_forever),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Permanently delete all records")
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: Theme.of(context).disabledColor,
                    thickness: 3,
                    height: 20,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                          ),
                        ),
                        child: const Row(
                          children: <Widget>[
                            Icon(Icons.info),
                            SizedBox(height: 10, width: 10),
                            Text('About Sitemarker')
                          ],
                        ),
                        onPressed: () {
                          showAboutDialog(
                            context: context,
                            applicationIcon: Image.asset(
                              'assets/io.github.aerocyber.sitemarker.png',
                              width: 64,
                              height: 64,
                            ),
                            applicationLegalese:
                                '\u{a9} 2023-present Aero\nLicensed under the terms of Apache-2.0 License',
                            applicationName: 'Sitemarker',
                            applicationVersion: version,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Support the project'),
                              content: Text(
                                  'If you like Sitemarker, consider supporting the project by buying me a coffee or sponsoring me on GitHub.'),
                              actions: [
                                ElevatedButton(
                                    onPressed: () async {
                                      if (await canLaunchUrl(
                                          Uri.parse(widget.bmcUrl))) {
                                        await launchUrl(Uri.parse(widget.bmcUrl));
                                      } else {
                                        throw 'Could not launch ${widget.bmcUrl}';
                                      }
                                    },
                                    child: const Text('Buy me a coffee')),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (await canLaunchUrl(
                                        Uri.parse(widget.ghSpUrl))) {
                                      await launchUrl(Uri.parse(widget.ghSpUrl));
                                    } else {
                                      throw 'Could not launch ${widget.ghSpUrl}';
                                    }
                                  },
                                  child: const Text('GitHub Sponsor'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Row(
                          children: <Widget>[
                            Icon(Icons.coffee),
                            SizedBox(height: 10, width: 10),
                            Text('Support the project'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sitemarker $version',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      RotationTransition(
                        turns: _animation,
                        child: IconButton(
                          onPressed: _isCheckingForUpdate ? null : _checkForUpdates,
                          icon: const Icon(Icons.refresh),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (Platform.isAndroid) _adBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _adBox() {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.blockSizeVertical * 10,
        ),
        Container(), // TODO: Replace with the ad banner
      ],
    );
  }

  SitemarkerTheme getInitialValueThemeMode() {
    String defaultTheme =
        Provider.of<SMSettingsProvider>(context, listen: false)
            .getCurrentThemeMode();
    switch (defaultTheme) {
      case 'light':
        return SitemarkerTheme.lightTheme;
      case 'dark':
        return SitemarkerTheme.darkTheme;
      default:
        return SitemarkerTheme.systemTheme;
    }
  }
}
