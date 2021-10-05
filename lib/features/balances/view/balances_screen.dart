import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/config/providers/url_config_provider.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';
import 'package:flutter_template/features/balances/storage/balances_repository.dart';
import 'package:flutter_template/features/balances/view/balance_item.dart';
import 'package:flutter_template/features/send/view/send_bottom_dialog.dart';
import 'package:flutter_template/logic/session.dart';
import 'package:flutter_template/utils/view/default_button_state.dart';
import 'package:get/get.dart';

class BalancesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ApiProvider apiProvider = Get.find();
    Session session = Get.find();
    UrlConfigProvider urlConfigProvider = Get.find();
    var balanceRepo = BalancesRepository(
        apiProvider, session.walletInfoProvider, urlConfigProvider);
    return StreamBuilder<List<BalanceRecord>>(
        stream: balanceRepo.getItems().asStream(),
        builder: (context, AsyncSnapshot<List<BalanceRecord>> snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: context.colorTheme.background,
              child: Stack(
                children: [
                  ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(height: 2),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Builder(
                            builder: (BuildContext context) =>
                                BalanceItem(snapshot.data![index]));
                      }),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 24.0, right: 24.0, bottom: 24.0),
                      child: DefaultButton(
                        colorTheme: context.colorTheme,
                        text: 'action_send'.tr,
                        onPressed: () {
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12.0),
                                ),
                              ),
                              context: context,
                              builder: (BuildContext context) {
                                return SendScaffold();
                              });
                        },
                        defaultState: true,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            log(snapshot.stackTrace.toString());
            return Text(
                snapshot.error.toString()); // TODO display error correctly
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
