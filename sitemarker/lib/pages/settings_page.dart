import 'dart:convert' show json;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl, LaunchMode;
import 'package:pub_semver/pub_semver.dart';

import 'package:sitemarker/components/bouncy_button.dart';
import 'package:sitemarker/core/data_types/settings/sitemarker_theme.dart';
import 'package:sitemarker/core/providers/settings_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  String version = '0.0.0';
  late AnimationController _animationController;
  bool _isCheckingForUpdate = false;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      // Strips build numbers or flavor tags for clean SemVer parsing
      version = info.version.split('-')[0];
    });
  }

  Future<void> _checkForUpdates() async {
    setState(() => _isCheckingForUpdate = true);
    _animationController.repeat();

    try {
      final current = Version.parse(version);
      final url = Uri.parse(
          'https://api.github.com/repos/aerocyber/sitemarker/releases/latest');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Clean the tag (e.g., "v1.0.2" -> "1.0.2")
        String tagName =
            data["tag_name"].toString().replaceAll(RegExp(r'[^\d.]'), '');
        final latest = Version.parse(tagName);

        if (!mounted) return;

        if (latest > current && data['prerelease'] == false) {
          _showUpdateDialog(data["html_url"], tagName);
        } else {
          _showNoUpdateDialog();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not reach update server.')),
        );
      }
    } finally {
      if (mounted) {
        _animationController.reset();
        setState(() => _isCheckingForUpdate = false);
      }
    }
  }

  void _showUpdateDialog(String url, String newVersion) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Available"),
        content: Text(
            "Version $newVersion is now available. Would you like to download it?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Later")),
          ElevatedButton(
            onPressed: () =>
                launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
            child: const Text("Download"),
          ),
        ],
      ),
    );
  }

  void _showNoUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Up to date"),
        content: const Text(
            "You are already using the latest version of Sitemarker."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  _buildThemeDropdown(settings),
                  _buildSectionDivider(),

                  _buildActionButton(
                    label: "Move all records to Trash",
                    icon: Icons.delete_outline,
                    color: Theme.of(context).colorScheme.tertiary,
                    containerColor:
                        Theme.of(context).colorScheme.tertiaryContainer,
                    onPressed: () => debugPrint("Trash all..."),
                  ),

                  _buildActionButton(
                    label: "Delete all records from Trash",
                    icon: Icons.delete_forever,
                    color: Theme.of(context).colorScheme.error,
                    containerColor:
                        Theme.of(context).colorScheme.errorContainer,
                    onPressed: () => debugPrint("Purge all..."),
                  ),

                  _buildActionButton(
                    label: "Restore all Records from Trash",
                    icon: Icons.restore,
                    color: Theme.of(context).colorScheme.primary,
                    containerColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    onPressed: () => debugPrint("Restore all..."),
                  ),

                  _buildSectionDivider(),

                  _buildActionButton(
                    label: "Export all records to .omio file",
                    icon: Icons.upload_file,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    containerColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    onPressed: () => debugPrint("Exporting..."),
                  ),

                  const SizedBox(height: 20),
                  _buildAboutDialogAndPage(),

                  const SizedBox(height: 40),

                  // Version Footer
                  Opacity(
                    opacity: 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sitemarker v$version',
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(width: 8),
                        RotationTransition(
                          turns: _animationController,
                          child: IconButton(
                            iconSize: 18,
                            onPressed:
                                _isCheckingForUpdate ? null : _checkForUpdates,
                            icon: const Icon(Icons.refresh),
                            tooltip: "Check for updates",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required Color containerColor,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: BouncyButton(
        onPressed: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeDropdown(SettingsProvider p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          const Text("Theme",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Spacer(),
          DropdownMenu<SitemarkerTheme>(
            initialSelection: SitemarkerTheme.values.firstWhere(
              (t) => t.themeValue == p.themeModeValue,
              orElse: () => SitemarkerTheme.systemTheme,
            ),
            onSelected: (value) {
              if (value != null) p.changeThemeMode(value);
            },
            dropdownMenuEntries: SitemarkerTheme.values.map((theme) {
              return DropdownMenuEntry(value: theme, label: theme.themeName);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutDialogAndPage() {
    return Padding(
      // Fixed the constructor name here
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // double.infinity makes it fill the ConstrainedBox width
          minimumSize: const Size(double.infinity, 60.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onPressed: () {
          showAboutDialog(
            context: context,
            applicationIcon: Image.asset(
              'assets/io.github.aerocyber.sitemarker.png',
              width: 72,
              height: 72,
              // Error handling for missing assets
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.bookmark, size: 72),
            ),
            applicationLegalese:
                '\u{a9} 2023-present Aero\nLicensed under the terms of Apache-2.0 License',
            applicationName: 'Sitemarker',
            applicationVersion: version,
          );
        },
        child: const Row(
          children: [
            Icon(Icons.info, size: 27),
            SizedBox(width: 20),
            Text('About Sitemarker')
          ],
        ),
      ),
    );
  }

  Widget _buildSectionDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
      child: Divider(),
    );
  }
}
