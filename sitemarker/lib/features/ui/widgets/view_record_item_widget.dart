import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sitemarker/core/data/data_model.dart';
import 'package:sitemarker/features/ui/pages/view_record_detail_page.dart';
import 'package:toastification/toastification.dart';

class ViewRecordItemWidget extends StatelessWidget {
  const ViewRecordItemWidget({super.key, required this.record});

  final DBDataModel record;

  @override
  Widget build(BuildContext context) {
    String domainUrl =
        record.url.split('//')[record.url.split('//').length - 1];
    String domain = domainUrl.split('/')[0];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewRecordDetailPage(
                record: record,
              ),
            ),
          );
        },
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Text(
            domain.characters.first.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
        title: Center(
          child: Text(
            record.name,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        subtitle: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: record.url));
                if (context.mounted) {
                  toastification.show(
                    context: context,
                    type: ToastificationType.success,
                    style: ToastificationStyle.flatColored,
                    title: const Text("Copied successfully"),
                    description:
                        const Text("The URL is now in your clipboard!"),
                    alignment: Alignment.bottomCenter,
                    autoCloseDuration: const Duration(seconds: 4),
                    animationBuilder: (
                      context,
                      animation,
                      alignment,
                      child,
                    ) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: lowModeShadow,
                    dragToClose: true,
                    applyBlurEffect: true,
                  );
                }
              },
              child: Text(
                record.url,
              ),
            ),
            Text(
              record.tags.split(',').join(' '),
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            )
          ],
        ),
      ),
    );
  }
}
