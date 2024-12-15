import 'package:flutter/material.dart';
import 'package:sitemarker/core/data_types/size_config.dart';
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';
import 'package:sitemarker/ui/pages/page_details.dart';

class SitemarkerSearchDelegate extends SearchDelegate {
  List<SmRecord> records;
  List<String> recordNames;

  SitemarkerSearchDelegate({
    super.searchFieldLabel,
    super.searchFieldStyle,
    super.searchFieldDecorationTheme,
    super.keyboardType,
    super.textInputAction,
    required this.records,
    required this.recordNames,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Padding(
        padding: EdgeInsets.all(12),
        child: IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear),
        ),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    SizeConfig().initSizes(context);
    List<SmRecord> matchQuery = [];
    for (SmRecord rec in records) {
      if (rec.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(rec);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return Padding(
          padding: EdgeInsets.all(12),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PageDetails(
                    record: result,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(),
              ),
              height: SizeConfig.blockSizeVertical * 10,
              padding: EdgeInsets.all(15),
              child: Center(
                child: Text(
                  result.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    SizeConfig().initSizes(context);
    List<SmRecord> matchQuery = [];
    for (SmRecord rec in records) {
      if (rec.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(rec);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return Padding(
          padding: EdgeInsets.all(12),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PageDetails(
                    record: result,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(),
              ),
              height: SizeConfig.blockSizeVertical * 10,
              padding: EdgeInsets.all(15),
              child: Center(
                child: Text(result.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        );
      },
    );
  }
}
