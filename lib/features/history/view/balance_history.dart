import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';
import 'package:flutter_template/features/history/model/balance_change.dart';
import 'package:flutter_template/features/history/storage/balance_changes_repository.dart';
import 'package:flutter_template/features/history/view/balance_change_item.dart';
import 'package:get/get.dart';

class BalanceHistory extends BaseStatefulWidget {
  BalanceRecord balanceRecord;

  BalanceHistory(this.balanceRecord);

  @override
  State<BalanceHistory> createState() => _BalanceHistoryState();
}

class _BalanceHistoryState extends State<BalanceHistory> {
  late BalanceChangesRepository balanceChangesRepo;

  @override
  Widget build(BuildContext context) {
    balanceChangesRepo =
        widget.repositoryProvider.balanceChanges(widget.balanceRecord.id);
    void subscribeToBalanceChanges() async {
      await balanceChangesRepo.update();
      balanceChangesRepo.isNeverUpdated = false;
    }

    var loading = false;
    /*if (balanceChangesRepo.isNeverUpdated == true) {
      subscribeToBalanceChanges();
      balanceChangesRepo.isNeverUpdated = false;
    }*/ //TODO
    subscribeToBalanceChanges();

    var stream = balanceChangesRepo.streamController.stream;

    return StreamBuilder<List<BalanceChange>>(
        stream: stream,
        builder: (context, AsyncSnapshot<List<BalanceChange>> snapshot) {
          if (snapshot.hasData &&
              snapshot.data?.isEmpty == true &&
              snapshot.connectionState != ConnectionState.waiting) {
            return Container(
              color: context.colorTheme.background,
              child: Center(
                  child: Text(
                'empty_history'.tr,
                style: TextStyle(fontSize: 17.0),
              )),
            );
          } else if (snapshot.connectionState != ConnectionState.waiting &&
              snapshot.hasData) {
            var controller = ScrollController();
            controller.addListener(() async {
              if (controller.position.atEdge) {
                if (controller.position.pixels == 0) {
                  // You're at the top.
                } else {
                  // You're at the bottom.
                  print('Scrolling reached the bottom');
                  loading = true;
                  if ((await balanceChangesRepo.loadMore()) == false) {
                    loading = false;
                  }
                }
              } else {
                loading = false;
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
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Builder(
                              builder: (BuildContext context) =>
                                  BalanceChangeItem(snapshot.data![index]));
                        }),
                    Visibility(
                      visible: loading,
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: CircularProgressIndicator(),
                      ),
                    ),
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
          return Container(
              color: context.colorTheme.background,
              child: Center(child: CircularProgressIndicator()));
        });
  }

  @override
  void dispose() {
    balanceChangesRepo.streamController.close();
    super.dispose();
  }
}
