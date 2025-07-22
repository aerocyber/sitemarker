import 'package:sitemarker/core/data_types/userdata/sm_record.dart';
import 'package:flutter/material.dart';
import 'package:sitemarker/core/data_types/size_config.dart';
import 'package:sitemarker/ui/pages/page_edit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:toastification/toastification.dart';

class PageDetails extends StatefulWidget {
  final SmRecord record;
  final bool isEditable;
  const PageDetails({
    super.key,
    required this.record,
    this.isEditable = true,
  });

  @override
  State<PageDetails> createState() => _PageDetailsState();
}

class _PageDetailsState extends State<PageDetails> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().initSizes(context);

    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 25,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          if (widget.isEditable)
            IconButton(
              icon: Icon(
                Icons.edit,
                size: 22,
              ),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PageEdit(
                      record: widget.record,
                    ),
                  ),
                );
                if (context.mounted) {
                  Navigator.of(context).popUntil((r) => r.isFirst);
                }
                // TODO: Implement the editing stuff
              },
            ),
          const SizedBox(width: 20),
          IconButton(
            icon: Icon(
              Icons.open_in_new,
              size: 22,
            ),
            onPressed: () {
              launchUrl(Uri.parse(widget.record.url).scheme.isEmpty
                  ? Uri.parse('https://${widget.record.url}')
                  : Uri.parse(widget.record.url));
              toastification.show(
                icon: Icon(Icons.check),
                context: context,
                type: ToastificationType.success,
                style: ToastificationStyle.flatColored,
                title: Text("Opened in new tab!!"),
                description: Text(
                    "${widget.record.url} has been opened in a new browser tab!"),
                alignment: Alignment.bottomCenter,
                autoCloseDuration: const Duration(seconds: 3),
                animationBuilder: (
                  context,
                  animation,
                  alignment,
                  child,
                ) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: highModeShadow,
                showProgressBar: true,
                closeButtonShowType: CloseButtonShowType.onHover,
                dragToClose: true,
                applyBlurEffect: true,
              );
            },
          ),
          const SizedBox(width: 20),
          IconButton(
            icon: Icon(
              Icons.copy,
              size: 22,
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: widget.record.url));
              toastification.show(
                context: context,
                icon: Icon(Icons.check),
                type: ToastificationType.success,
                style: ToastificationStyle.flatColored,
                title: Text("Copied successfully!"),
                description:
                    Text("${widget.record.url} has been copied to clipboard!"),
                alignment: Alignment.bottomCenter,
                autoCloseDuration: const Duration(seconds: 3),
                animationBuilder: (
                  context,
                  animation,
                  alignment,
                  child,
                ) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: highModeShadow,
                showProgressBar: true,
                closeButtonShowType: CloseButtonShowType.onHover,
                dragToClose: true,
                applyBlurEffect: true,
              );
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // height: 250,
                width: 500,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Record Name",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              widget.record.name,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // height: 250,
                width: 500,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Record URL",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              widget.record.url,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // height: 250,
                width: 500,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Record Tags",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      widget.record.tags.isNotEmpty
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: <Widget>[
                                  for (int i = 0;
                                      i < widget.record.tags.split(',').length;
                                      i++)
                                    widget.record.tags
                                            .split(',')[i]
                                            .trim()
                                            .isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Chip(
                                              label: Text(
                                                widget.record.tags
                                                    .split(',')[i]
                                                    .trim(),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                ],
                              ),
                            )
                          : Text(
                              'Not tagged',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
