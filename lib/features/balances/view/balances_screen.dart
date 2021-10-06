import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/di/providers/repository_provider.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';
import 'package:flutter_template/features/balances/view/balance_item.dart';
import 'package:flutter_template/features/send/view/send_bottom_dialog.dart';
import 'package:flutter_template/utils/view/default_button_state.dart';
import 'package:get/get.dart';

class BalancesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RepositoryProvider repositoryProvider = Get.find();
    var balanceRepo = repositoryProvider.balances;

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
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.9,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(12.0),
                                        topRight: const Radius.circular(12.0),
                                      ),
                                    ),
                                    child: SendScaffold(
                                        snapshot.data!,
                                        snapshot.data!
                                            .map((item) => item.asset)
                                            .toList()),
                                  ));
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
