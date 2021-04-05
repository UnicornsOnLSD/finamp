import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/JellyfinModels.dart';
import '../../services/AudioServiceHelper.dart';
import '../AlbumImage.dart';
import '../printDuration.dart';
import 'DownloadedIndicator.dart';
import 'AlbumScreenContentFlexibleSpaceBar.dart';

class AlbumScreenContent extends StatelessWidget {
  const AlbumScreenContent({
    Key key,
    @required this.parent,
    @required this.children,
  }) : super(key: key);

  final BaseItemDto parent;
  final List<BaseItemDto> children;
  @override
  Widget build(BuildContext context) {
    AudioServiceHelper audioServiceHelper =
        GetIt.instance<AudioServiceHelper>();

    return Scrollbar(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(parent.name),
            // 181 is the total height of the widget we use as a FlexibleSpaceBar.
            // We add the toolbar height since the widget should appear below the appbar.
            // expandedHeight: kToolbarHeight +
            //     (MediaQuery.of(context).size.width / (360 / 168)),
            expandedHeight: kToolbarHeight + 181,
            pinned: true,
            flexibleSpace: AlbumScreenContentFlexibleSpaceBar(
              album: parent,
              items: children,
            ),
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              final BaseItemDto item = children[index];
              return ListTile(
                leading: AlbumImage(
                  itemId: item.parentId,
                ),
                title: Text(item.name),
                subtitle: Text(printDuration(
                  Duration(microseconds: (item.runTimeTicks ~/ 10)),
                )),
                trailing: DownloadedIndicator(item: item),
                onTap: () async {
                  audioServiceHelper.replaceQueueWithItem(
                    itemList: children,
                    startAtIndex: index,
                  );
                },
              );
            }, childCount: children.length),
          ),
        ],
      ),
    );
  }
}
