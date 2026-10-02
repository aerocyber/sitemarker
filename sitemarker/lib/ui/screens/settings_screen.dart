import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [_buildRecycleBinRedirect(context)],
    );
  }

  Widget _buildRecycleBinRedirect(BuildContext context) => _buildCard(
    context,
    Theme.of(context).colorScheme.onPrimary,
    Icon(Icons.recycling),
    'Recycle Bin',
    null,
    null,
    null,
    () => context.push('/trash'),
  );

  Widget _buildCard(
    BuildContext context,
    Color? cardColor,
    Icon leadingIcon,
    String title,
    String? subtitle,
    Color? titleColor,
    Color? subtitleColor,
    VoidCallback ontapAction,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      elevation: 0, // M3 flat style
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Softer, modern corners
      ),
      clipBehavior: Clip.antiAlias,

      child: ListTile(
        onTap: ontapAction,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 4.0,
        ),
        leading: leadingIcon,
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w500, color: titleColor),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: subtitleColor),
              )
            : null,
      ),
    );
  }
}
