import 'package:flutter/material.dart';
import 'package:sitemarker/model.dart';
import 'package:sitemarker/objectbox.g.dart';

class ViewPage extends StatelessWidget {
  const ViewPage({super.key, required this.ob});

  final Box<SitemarkerInternalRecord> ob;

  @override
  Widget build(BuildContext context) {
    List<SitemarkerInternalRecord> smr = ob.getAll();
    if (smr.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("View Records"),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: ob.count(),
            itemBuilder: (context, position) {
              return Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.network(
                              "https://icons.duckduckgo.com/ip3/${smr[position].validUrl}.ico"),
                          Container(
                            width: 15,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 5,
                              ),
                              Text(
                                smr[position].name,
                              ),
                              Container(
                                height: 5,
                              ),
                              Text(
                                smr[position].validUrl,
                              ),
                              Container(
                                height: 5,
                              ),
                              Text(
                                smr[position].tagString,
                              ),
                              Container(
                                height: 5,
                              ),
                            ],
                          )),
                          Container(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text("View Records"),
          ),
          body: const Center(
            child: Text('No records to show.'),
          ));
    }
  }
}
