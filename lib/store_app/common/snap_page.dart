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
import 'package:software/l10n/l10n.dart';
import 'package:software/services/app_change_service.dart';
import 'package:software/store_app/common/app_data.dart';
import 'package:software/store_app/common/app_icon.dart';
import 'package:software/store_app/common/app_page.dart';
import 'package:software/store_app/common/border_container.dart';
import 'package:software/store_app/common/snap_connections_settings.dart';
import 'package:software/store_app/common/snap_controls.dart';
import 'package:software/store_app/common/snap_model.dart';
import 'package:ubuntu_service/ubuntu_service.dart';
import 'package:yaru_icons/yaru_icons.dart';

class SnapPage extends StatefulWidget {
  const SnapPage({super.key, required this.onPop});

  final VoidCallback onPop;

  static Widget create({
    required BuildContext context,
    required String huskSnapName,
    required final VoidCallback onPop,
  }) =>
      ChangeNotifierProvider<SnapModel>(
        create: (_) => SnapModel(
          doneString: context.l10n.done,
          getService<SnapdClient>(),
          getService<AppChangeService>(),
          huskSnapName: huskSnapName,
        ),
        child: SnapPage(onPop: onPop),
      );

  @override
  State<SnapPage> createState() => _SnapPageState();
}

class _SnapPageState extends State<SnapPage> {
  @override
  void initState() {
    context.read<SnapModel>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SnapModel>();

    final appData = AppData(
      confinementName: model.confinement != null ? model.confinement!.name : '',
      installDate: model.installDate,
      installDateIsoNorm: model.installDateIsoNorm,
      license: model.license ?? '',
      strict: model.strict,
      verified: model.verified,
      publisherName: model.publisher?.displayName ?? '',
      website: model.storeUrl ?? '',
      summary: model.summary ?? '',
      title: model.title ?? '',
      version: model.selectableChannels[model.channelToBeInstalled]?.version ??
          model.version,
      screenShotUrls: model.screenshotUrls ?? [],
      description: model.description ?? '',
      versionChanged:
          model.selectableChannels[model.channelToBeInstalled]?.version !=
              model.version,
    );

    return AppPage(
      appData: appData,
      onPop: widget.onPop,
      permissionContainer: model.snapIsInstalled && model.strict
          ? BorderContainer(
              child: SnapConnectionsSettings(connections: model.connections),
            )
          : const SizedBox(),
      controls: const SnapControls(),
      icon: AppIcon(
        iconUrl: model.iconUrl,
        fallBackIconData: YaruIcons.snapcraft,
        width: 150,
      ),
    );
  }
}
