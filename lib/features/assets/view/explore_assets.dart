import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/assets/model/asset_record.dart';
import 'package:flutter_template/features/assets/storage/assets_repository.dart';
import 'package:flutter_template/features/assets/view/asset_item.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';
import 'package:flutter_template/features/balances/storage/balances_repository.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class ExploreAssets extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExploreAssetsScreenState();
  }
}

class _ExploreAssetsScreenState extends State<ExploreAssets> {
  @override
  Widget build(BuildContext context) {
    AssetsRepository assetsRepo = widget.repositoryProvider.assets;
    BalancesRepository balanceRepo = widget.repositoryProvider.balances;

    var assetsWithBalance;
    var streamController;

    void subscribeToAssets() async {
      await assetsRepo.getItems();
      assetsRepo.isNeverUpdated = false;
    }

    void subscribeToBalances() async {
      await balanceRepo.getItems();
      balanceRepo.isNeverUpdated = false;
    }

    if (assetsRepo.isNeverUpdated) {
      subscribeToAssets();
    }

    if (balanceRepo.isNeverUpdated) {
      subscribeToBalances();
    }

    streamController = assetsRepo.streamSubject;
    assetsWithBalance = balanceRepo.streamSubject;

    return StreamBuilder(
      builder: (context, AsyncSnapshot<List<BalanceRecord>> snapshot) {
        if (snapshot.data?.isEmpty == true &&
            balanceRepo.isNeverUpdated == false &&
            snapshot.connectionState != ConnectionState.waiting) {
          return SingleChildScrollView(
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
          );
        } else if (snapshot.connectionState != ConnectionState.waiting &&
            snapshot.hasData) {
          balanceRepo.isNeverUpdated = false;

          return StreamBuilder<List<AssetRecord>>(
              initialData: [],
              stream: streamController.stream,
              builder: (context, AsyncSnapshot<List<AssetRecord>> snapshot) {
                if (snapshot.data?.isEmpty == true &&
                    assetsRepo.isNeverUpdated == false &&
                    snapshot.connectionState != ConnectionState.waiting) {
                  return RefreshIndicator(
                    onRefresh: () {
                      return assetsRepo.update();
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        child: Center(
                          child: Text(
                            'empty_assets_list'.tr,
                            style: TextStyle(fontSize: 17.0),
                          ),
                        ),
                        height: MediaQuery.of(context).size.height,
                      ),
                    ),
                  );
                } else if (snapshot.connectionState !=
                        ConnectionState.waiting &&
                    snapshot.hasData) {
                  assetsRepo.isNeverUpdated = false;

                  return Container(
                    color: context.colorTheme.background,
                    child: RefreshIndicator(
                      onRefresh: () {
                        return assetsRepo.update();
                      },
                      child: Stack(
                        children: [
                          ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    Divider(height: 2),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              var relatedBalance;
                              assetsWithBalance.value.forEach((b) {
                                if (b.asset.code ==
                                    snapshot.data![index].code) {
                                  relatedBalance = b;
                                }
                              });
                              return Builder(
                                  builder: (BuildContext context) => AssetItem(
                                        snapshot.data![index],
                                        relatedBalance: relatedBalance,
                                      ));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  log(snapshot.stackTrace.toString());
                  return Text(snapshot.error
                      .toString()); // TODO display error correctly
                }
                return Container(
                    color: context.colorTheme.background,
                    child: Center(child: CircularProgressIndicator()));
              });
        } else if (snapshot.hasError) {
          log(snapshot.stackTrace.toString());
          return Text(
              snapshot.error.toString()); // TODO display error correctly
        }
        return Container(
            color: context.colorTheme.background,
            child: Center(child: CircularProgressIndicator()));
      },
      stream: assetsWithBalance.stream,
    );
  }
}
