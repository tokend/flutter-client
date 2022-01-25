import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/sales/model/sale_record.dart';
import 'package:flutter_template/features/sales/storage%20/sales_repository.dart';
import 'package:flutter_template/features/sales/view/list/sales_list_item.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class SalesListScreen extends BaseStatefulWidget {
  @override
  State<SalesListScreen> createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  @override
  Widget build(BuildContext context) {
    SalesRepository salesRepository = widget.repositoryProvider.salesRepository;
    var streamController;

    Future<void> subscribeToSales() async {
      await salesRepository.update();
      salesRepository.isNeverUpdated = false;
    }

    if (salesRepository.isNeverUpdated) {
      subscribeToSales();
    }

    streamController = salesRepository.streamController;

    return StreamBuilder<List<SaleRecord>>(
        stream: streamController.stream,
        builder: (context, AsyncSnapshot<List<SaleRecord>> snapshot) {
          if (snapshot.data?.isEmpty == true &&
              salesRepository.isNeverUpdated == false &&
              snapshot.connectionState != ConnectionState.waiting) {
            return RefreshIndicator(
              onRefresh: () {
                return salesRepository.update();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  child: Center(
                    child: Text(
                      'empty_sales_list'.tr,
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height,
                ),
              ),
            );
          } else if (snapshot.connectionState != ConnectionState.waiting &&
              snapshot.hasData) {
            return Container(
              color: context.colorTheme.background,
              child: RefreshIndicator(
                onRefresh: () {
                  return salesRepository.update();
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10.0),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Builder(
                                builder: (BuildContext context) =>
                                    SaleListItem(snapshot.data![index]));
                          }),
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
