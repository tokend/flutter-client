import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';
import 'package:flutter_template/features/balances/storage/balances_repository.dart';
import 'package:flutter_template/features/balances/view/balance_item.dart';
import 'package:flutter_template/features/send/view/send_bottom_dialog.dart';
import 'package:flutter_template/utils/view/default_bottom_dialog.dart';
import 'package:flutter_template/utils/view/default_button_state.dart';
import 'package:get/get.dart';

class BalancesScreen extends BaseStatefulWidget {
  bool isMovementsScreen;
  bool isMyBalancesScreen;

  BalancesScreen(this.isMovementsScreen, this.isMyBalancesScreen);

  @override
  State<BalancesScreen> createState() => _BalancesScreenState();
}

class _BalancesScreenState extends State<BalancesScreen> {
  @override
  Widget build(BuildContext context) {
    BalancesRepository balanceRepo = widget.repositoryProvider.balances;
    var streamController;

    void subscribeToBalances() async {
      await widget.repositoryProvider.activeKyc.getItem();
      widget.repositoryProvider.activeKyc.isNeverUpdated = false;
      await balanceRepo.getItems();
    }

    if (balanceRepo.isNeverUpdated == true) {
      subscribeToBalances();
    }

    streamController = balanceRepo.streamSubject;

    return StreamBuilder<List<BalanceRecord>>(
        initialData: [],
        stream: streamController.stream,
        builder: (context, AsyncSnapshot<List<BalanceRecord>> snapshot) {
          if (snapshot.data?.isEmpty == true &&
              balanceRepo.isNeverUpdated == false &&
              snapshot.connectionState != ConnectionState.waiting) {
            return RefreshIndicator(
              onRefresh: () => balanceRepo.update(),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  child: Center(
                    child: Text(
                      'empty_balances_list'.tr,
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height,
                ),
              ),
            );
          } else if (snapshot.connectionState != ConnectionState.waiting &&
              snapshot.hasData) {
            balanceRepo.isNeverUpdated = false;

            return Container(
              color: context.colorTheme.background,
              child: RefreshIndicator(
                onRefresh: () {
                  return balanceRepo.update();
                },
                child: Stack(
                  children: [
                    ListView.separated(
                        physics: AlwaysScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(height: 2),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Builder(
                              builder: (BuildContext context) => BalanceItem(
                                  snapshot.data![index],
                                  this.widget.isMovementsScreen,
                                  this.widget.isMyBalancesScreen));
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
          return Container(
              color: context.colorTheme.background,
              child: Center(child: CircularProgressIndicator()));
        });
  }
}
