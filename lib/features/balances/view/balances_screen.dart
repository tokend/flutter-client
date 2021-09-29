import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/config/providers/url_config_provider.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/assets/model/asset_record.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';
import 'package:flutter_template/features/balances/storage/balances_repository.dart';
import 'package:flutter_template/features/balances/view/balance_item.dart';
import 'package:flutter_template/logic/session.dart';
import 'package:flutter_template/utils/view/default_button_state.dart';
import 'package:get/get.dart';

final List<BalanceRecord> listOfBalances = [
  BalanceRecord(
      '1',
      AssetRecord(
          'UAH', 'Hryvnia', 6, 'https://picsum.photos/250?image=9', '1'),
      5),
  BalanceRecord(
      '2',
      AssetRecord(
          'BTC', 'Bitcoin', 6, 'https://picsum.photos/250?image=9', '1'),
      5),
  BalanceRecord(
      '3',
      AssetRecord(
          'ETH', 'Ethereum', 6, 'https://picsum.photos/250?image=9', '1'),
      5),
];

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
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Builder(
                            builder: (BuildContext context) =>
                                BalanceItem(snapshot.data![index]));
                      }),

                  Positioned(
                    bottom: 24.0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 24.0,  right: 24.0),
                      child: DefaultButton(
                        colorTheme: context.colorTheme,
                        text: 'action_send'.tr,
                        onPressed: () {}, //TODO
                      ),
                    ),
                  )
                  //TODO: Send button
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
