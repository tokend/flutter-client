import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/di/providers/repository_provider.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';
import 'package:flutter_template/features/balances/storage/balances_repository.dart';
import 'package:flutter_template/features/balances/view/balance_item.dart';
import 'package:flutter_template/features/send/view/send_bottom_dialog.dart';
import 'package:flutter_template/utils/view/default_bottom_dialog.dart';
import 'package:flutter_template/utils/view/default_button_state.dart';
import 'package:get/get.dart';
import 'package:lazy_evaluation/lazy_evaluation.dart';

class BalancesScreen extends StatefulWidget {
  bool isMovementsScreen;

  BalancesScreen(this.isMovementsScreen);

  @override
  State<BalancesScreen> createState() => _BalancesScreenState();
}

class _BalancesScreenState extends State<BalancesScreen> {
  RepositoryProvider repositoryProvider = Get.find();
  Lazy<BalancesRepository>? balanceRepo;

  @override
  Widget build(BuildContext context) {
    balanceRepo = repositoryProvider.balances;
    var stream;

    void subscribeToBalances() async {
      await balanceRepo?.value.getItems();
    }

    if (balanceRepo?.value.isNeverUpdated == true) {
      subscribeToBalances();
      balanceRepo?.value.isNeverUpdated = false;
    }
    stream = balanceRepo?.value.streamController.stream;

    return StreamBuilder<List<BalanceRecord>>(
        initialData: [],
        stream: stream,
        builder: (context, AsyncSnapshot<List<BalanceRecord>> snapshot) {
          if (snapshot.data?.isEmpty == true &&
              snapshot.connectionState != ConnectionState.waiting) {
            return Center(
                child: Text(
              'empty_balances_list'.tr,
              style: TextStyle(fontSize: 17.0),
            ));
          } else if (snapshot.connectionState != ConnectionState.waiting &&
              snapshot.hasData) {
            return Container(
              color: context.colorTheme.background,
              child: RefreshIndicator(
                onRefresh: () {
                  return balanceRepo!.value.update();
                },
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
                              builder: (BuildContext context) => BalanceItem(
                                  snapshot.data![index],
                                  this.widget.isMovementsScreen));
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
                                builder: (context) => DefaultBottomDialog(
                                      SendScaffold(
                                        snapshot.data!,
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.9,
                                    ));
                          },
                          defaultState: true,
                        ),
                      ),
                    )
                  ],
                ),
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

  @override
  void dispose() {
    balanceRepo?.value.streamController.close();
    super.dispose();
  }
}
