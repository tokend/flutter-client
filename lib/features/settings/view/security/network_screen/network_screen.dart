import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/system_info/model/system_info_record.dart';
import 'package:flutter_template/features/system_info/storage/system_info_repository.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class PassphraseScreen extends BaseStatelessWidget {
  @override
  Widget build(BuildContext context) {
    var networkStreamController;

    SystemInfoRepository systemInfoRepository = repositoryProvider.systemInfo;
    void subscribeToNetworkData() async {
      if (systemInfoRepository.isNeverUpdated == true) {
        await systemInfoRepository.getItem();
        systemInfoRepository.isNeverUpdated = false;
      }
    }

    subscribeToNetworkData();
    networkStreamController = systemInfoRepository.streamSubject;
    return StreamBuilder<SystemInfoRecord>(
        stream: networkStreamController
            ?.stream,
        builder: (context, AsyncSnapshot<SystemInfoRecord> snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting &&
              snapshot.hasData &&
              snapshot.data != null) {
            return Scaffold(
                backgroundColor: context.colorTheme.background,
                appBar: AppBar(
                  backgroundColor: context.colorTheme.background,
                  iconTheme: IconThemeData(color: context.colorTheme.accent),
                  title: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'network_passphrase'.tr,
                      style: TextStyle(
                          color: context.colorTheme.primaryText,
                          fontSize: 17.0),
                    ),
                  ),
                  elevation: 0,
                ),
                body: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 40.0),
                        ),
                        Text(
                          'network_passphrase_description'.tr,
                          style: TextStyle(
                              color: context.colorTheme.grayText,
                              fontSize: 12.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                        ),
                        Container(
                          color: context.colorTheme.primaryLight,
                          child: ListTile(
                            title: Text(
                              '${snapshot.data!.passphrase}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: context.colorTheme.primary,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700),
                            ),
                            trailing: Icon(CustomIcons.copy),
                            onLongPress: () {
                              Clipboard.setData(ClipboardData(
                                  text: snapshot.data!.passphrase));
                              toastManager.showShortToast('data_copied'.tr);
                            },
                          ),
                        )
                      ]),
                ));
          }

          return Container(
              color: context.colorTheme.background,
              child: Center(child: CircularProgressIndicator()));
        });
  }
}
