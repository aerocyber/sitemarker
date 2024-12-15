import 'package:sitemarker/core/data_types/userdata/sm_record.dart';
import 'package:flutter/material.dart';
import 'package:sitemarker/core/data_types/size_config.dart';

class PageDetails extends StatelessWidget {
  final SmRecord record;
  const PageDetails({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    SizeConfig().initSizes(context);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 10,
            floating: false,
            leading: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: SizeConfig.blockSizeVertical * 3,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  size: SizeConfig.blockSizeVertical * 3,
                ),
                onPressed: () {
                  // TODO: Implement the editing stuff
                },
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: Icon(
                  Icons.open_in_new,
                  size: SizeConfig.blockSizeVertical * 3,
                ),
                onPressed: () {
                  // TODO: Implement the opening in new tab stuff
                },
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: Icon(
                  Icons.copy,
                  size: SizeConfig.blockSizeVertical * 3,
                ),
                onPressed: () {
                  // TODO: Implement the copy to clipboard stuff
                },
              ),
              const SizedBox(width: 20),
            ],
          ),

          SizedBox(height: 20,),
          Container(
            height: SizeConfig.blockSizeVertical * 10,
            width: SizeConfig.blockSizeHorizontal * 10,
          ),
        ],
      ),
    );
  }
}
