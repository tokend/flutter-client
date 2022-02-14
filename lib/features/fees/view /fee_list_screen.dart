import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/fees/model/fee_record.dart';
import 'package:flutter_template/features/fees/storage/fees_repository.dart';
import 'package:flutter_template/features/fees/view%20/fee_list_item.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class FeeListScreen extends BaseStatelessWidget {
  @override
  Widget build(BuildContext context) {
    FeesRepository feesRepo = repositoryProvider.feeRepository;
    var streamController;

    void subscribeToFees() async {
      await feesRepo.update();
    }

    if (feesRepo.isNeverUpdated == true) {
      subscribeToFees();
    }

    streamController = feesRepo.streamSubject;

    return StreamBuilder<List<FeeRecord>>(
        initialData: [],
        stream: streamController.stream,
        builder: (context, AsyncSnapshot<List<FeeRecord>> snapshot) {
          if (snapshot.data?.isEmpty == true &&
              feesRepo.isNeverUpdated == false &&
              snapshot.connectionState != ConnectionState.waiting) {
            return RefreshIndicator(
              onRefresh: () => feesRepo.update(),
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
            feesRepo.isNeverUpdated = false;

            return Container(
              color: context.colorTheme.background,
              child: RefreshIndicator(
                onRefresh: () {
                  return feesRepo.update();
                },
                child: ListView.separated(
                    physics: AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(height: 2),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Builder(
                          builder: (BuildContext context) =>
                              FeeListItem(snapshot.data![index]));
                    }),
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
