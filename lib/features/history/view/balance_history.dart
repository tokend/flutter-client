import 'dart:developer';

import 'package:dart_sdk/api/base/model/data_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/di/providers/repository_provider.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';
import 'package:flutter_template/features/history/model/balance_change.dart';
import 'package:flutter_template/features/history/storage/balance_changes_repository.dart';
import 'package:flutter_template/features/history/view/balance_change_item.dart';
import 'package:get/get.dart';

class BalanceHistory extends StatelessWidget {
  BalanceRecord balanceRecord;

  BalanceHistory(this.balanceRecord);

  @override
  Widget build(BuildContext context) {
    RepositoryProvider repositoryProvider = Get.find();
    BalanceChangesRepository balanceChangesRepo =
        repositoryProvider.balanceChanges(balanceRecord.id);
    var stream = balanceChangesRepo.update().asStream();
    if (balanceChangesRepo.streamController.isBlank != true) {
      stream = balanceChangesRepo.loadMore().asStream();
    }

    return StreamBuilder<DataPage<BalanceChange>>(
        stream: stream,
        builder: (context, AsyncSnapshot<DataPage<BalanceChange>> snapshot) {
          if (snapshot.hasData &&
              snapshot.data?.items.isEmpty == true &&
              snapshot.connectionState != ConnectionState.waiting) {
            return Center(
                child: Text(
              'empty_history'.tr,
              style: TextStyle(fontSize: 17.0),
            ));
          } else if (snapshot.connectionState != ConnectionState.waiting &&
              snapshot.hasData) {
            var controller = ScrollController();
            controller.addListener(() {
              if (controller.position.atEdge) {
                if (controller.position.pixels == 0) {
                  // You're at the top.
                } else {
                  // You're at the bottom.
                  print('Scrolling reached the bottom');
                  stream = balanceChangesRepo.loadMore().asStream();
                }
              }
            });
            return Container(
              color: context.colorTheme.background,
              child: RefreshIndicator(
                onRefresh: () {
                  return balanceChangesRepo.update();
                },
                child: Stack(
                  children: [
                    ListView.separated(
                        controller: controller,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(height: 2),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Builder(
                              builder: (BuildContext context) =>
                                  BalanceChangeItem(
                                      snapshot.data!.items[index]));
                        }),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            log(snapshot.error.toString());
            log(snapshot.stackTrace.toString());
            return Text(
                snapshot.error.toString()); // TODO display error correctly
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
