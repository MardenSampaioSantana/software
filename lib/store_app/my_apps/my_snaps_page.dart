/*
 * Copyright (C) 2022 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapd/snapd.dart';
import 'package:software/snapx.dart';
import 'package:software/store_app/common/animated_scroll_view_item.dart';
import 'package:software/store_app/common/constants.dart';
import 'package:software/store_app/common/snap_page.dart';
import 'package:software/store_app/my_apps/my_apps_model.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class MySnapsPage extends StatefulWidget {
  const MySnapsPage({Key? key}) : super(key: key);
  @override
  State<MySnapsPage> createState() => _MySnapsPageState();
}

class _MySnapsPageState extends State<MySnapsPage> {
  @override
  void initState() {
    context.read<MyAppsModel>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MyAppsModel>();
    return Navigator(
      pages: [
        MaterialPage(
          child: model.localSnaps.isNotEmpty
              ? _MySnapsGrid(snaps: model.localSnaps)
              : const SizedBox(),
        ),
        if (model.selectedSnap != null)
          MaterialPage(
            key: ObjectKey(model.selectedSnap),
            child: SnapPage.create(
              context: context,
              huskSnapName: model.selectedSnap!.name,
              onPop: () => model.selectedSnap = null,
            ),
          )
      ],
      onPopPage: (route, result) => route.didPop(result),
    );
  }
}

class _MySnapsGrid extends StatefulWidget {
  // ignore: unused_element
  const _MySnapsGrid({super.key, required this.snaps});

  final List<Snap> snaps;

  @override
  State<_MySnapsGrid> createState() => __MySnapsGridState();
}

class __MySnapsGridState extends State<_MySnapsGrid> {
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MyAppsModel>();
    return GridView.builder(
      controller: _controller,
      padding: const EdgeInsets.all(20.0),
      gridDelegate: kGridDelegate,
      shrinkWrap: true,
      itemCount: widget.snaps.length,
      itemBuilder: (context, index) {
        final snap = widget.snaps.elementAt(index);
        return AnimatedScrollViewItem(
          child: YaruBanner(
            name: snap.name,
            summary: snap.summary,
            url: snap.iconUrl,
            fallbackIconData: YaruIcons.package_snap,
            onTap: () => model.selectedSnap = snap,
          ),
        );
      },
    );
  }
}
