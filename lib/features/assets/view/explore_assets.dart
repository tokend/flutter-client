import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/assets/model/asset_record.dart';
import 'package:flutter_template/features/assets/storage/assets_repository.dart';
import 'package:flutter_template/features/assets/view/asset_item.dart';
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

    var assetsWithBalance = balanceRepo.streamSubject.value;
    log(assetsWithBalance.length.toString());
    var streamController;

    void subscribeToAssets() async {
      await assetsRepo.getItems();
    }

    if (assetsRepo.isNeverUpdated == true) {
      subscribeToAssets();
    }

    streamController = assetsRepo.streamSubject;

    return StreamBuilder<List<AssetRecord>>(
        initialData: [],
        stream: streamController.stream,
        builder: (context, AsyncSnapshot<List<AssetRecord>> snapshot) {
          if (snapshot.data?.isEmpty == true &&
              assetsRepo.isNeverUpdated == false &&
              snapshot.connectionState != ConnectionState.waiting) {
            return Container(
              color: context.colorTheme.background,
              child: Center(
                  child: Text(
                'empty_balances_list'.tr,
                style: TextStyle(fontSize: 17.0),
              )),
            );
          } else if (snapshot.connectionState != ConnectionState.waiting &&
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
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(height: 2),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        var relatedBalance;
                        assetsWithBalance.forEach((b) {
                          if (b.asset.code == snapshot.data![index].code) {
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
            return Text(
                snapshot.error.toString()); // TODO display error correctly
          }
          return Container(
              color: context.colorTheme.background,
              child: Center(child: CircularProgressIndicator()));
        });
  }
}
