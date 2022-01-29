import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/trade%20/chart/model/asset_chart_data.dart';
import 'package:flutter_template/features/trade%20/chart/model/chart_time_period.dart';
import 'package:flutter_template/features/trade%20/chart/storage/asset_chart_repository.dart';
import 'package:flutter_template/features/trade%20/chart/view%20/chart_view.dart';
import 'package:flutter_template/features/trade%20/history/view/trade_history_list.dart';
import 'package:flutter_template/features/trade%20/history/view/trade_history_screen.dart';
import 'package:flutter_template/features/trade%20/orderbook/view/order_book_list.dart';
import 'package:flutter_template/features/trade%20/orderbook/view/order_book_screen.dart';
import 'package:flutter_template/features/trade%20/pairs/asset_pair_record.dart';
import 'package:flutter_template/features/trade%20/pairs/asset_pairs_repository.dart';
import 'package:flutter_template/features/trade%20/view/time_period_picker.dart';
import 'package:flutter_template/utils/formatters/string_formatter.dart';
import 'package:flutter_template/utils/view/drop_down_field.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class ExchangeTab extends BaseStatefulWidget {
  @override
  State<ExchangeTab> createState() => _ExchangeTabState();
}

int selectedAssetPairIndex = 0;
AssetPairRecord? selectedAssetPair;
AssetPairRecord? firstAssetPair;
ChartTimePeriod timePeriod = ChartTimePeriod.hour;
int selectedTimePeriod = 0;

var chartStreamController;
AssetChartRepository? _chartRepository;
AssetPairsRepository? _assetPairsRepository;

List<String> timePeriods = [
  describeEnum(ChartTimePeriod.hour).capitalize(),
  describeEnum(ChartTimePeriod.day).capitalize(),
  describeEnum(ChartTimePeriod.month).capitalize(),
  describeEnum(ChartTimePeriod.year).capitalize(),
];

class _ExchangeTabState extends State<ExchangeTab> {
  @override
  Widget build(BuildContext context) {
    _assetPairsRepository = widget.repositoryProvider.assetPairsRepository;

    var assetPairsStreamController;

    void subscribeToChartsData() async {
      if (_chartRepository?.isNeverUpdated == true) {
        await _chartRepository?.getItem();
        _chartRepository?.isNeverUpdated = false;
      }
    }

    void subscribeToAssetPairs() async {
      var items = await _assetPairsRepository?.getItems();
      if (selectedAssetPair == null) selectedAssetPair = items!.first;

      if (this.mounted) {
        setState(() {
          _chartRepository = widget.repositoryProvider.assetChartsRepository(
              selectedAssetPair!.base.code, selectedAssetPair!.quote.code);
          chartStreamController = _chartRepository!.streamSubject;
        });
      }

      subscribeToChartsData();
    }

    if (_assetPairsRepository?.isNeverUpdated == true) {
      subscribeToAssetPairs();
      _assetPairsRepository?.isNeverUpdated = false;
    } else {
      if (_chartRepository?.isFresh == false) {
        _chartRepository = widget.repositoryProvider.assetChartsRepository(
            selectedAssetPair!.base.code, selectedAssetPair!.quote.code);
        chartStreamController = _chartRepository!.streamSubject;
        subscribeToChartsData();
        _chartRepository?.isFresh = true;
      }
    }

    assetPairsStreamController = _assetPairsRepository?.streamSubject;
    var colorScheme = context.colorTheme;

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 16.0, top: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<List<AssetPairRecord>>(
              initialData: [],
              stream: assetPairsStreamController?.stream,
              builder: (context,
                  AsyncSnapshot<List<AssetPairRecord>> assetPairsSnapshot) {
                if (assetPairsSnapshot.data?.isEmpty == true &&
                    _chartRepository?.isNeverUpdated == false &&
                    assetPairsSnapshot.connectionState !=
                        ConnectionState.waiting) {
                  return Container(
                    child: RefreshIndicator(
                      onRefresh: () {
                        return _chartRepository!.update();
                      },
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Container(
                          child: Center(
                            child: Text(
                              'no_asset_pairs'.tr,
                              style: TextStyle(fontSize: 17.0),
                            ),
                          ),
                          height: MediaQuery.of(context).size.height,
                        ),
                      ),
                    ),
                  );
                } else if (assetPairsSnapshot.connectionState !=
                        ConnectionState.waiting &&
                    assetPairsSnapshot.hasData) {
                  firstAssetPair = assetPairsSnapshot.data!.first;
                  return RefreshIndicator(
                    onRefresh: () {
                      return _chartRepository!.update();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ConstrainedBox(
                          constraints: new BoxConstraints(
                            maxHeight: 95.0,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: DropDownField<AssetPairRecord>(
                              onChanged: (newPair) {
                                setState(() {
                                  selectedAssetPair = newPair;
                                  _chartRepository?.isFresh = false;
                                });
                              },
                              colorTheme: colorScheme,
                              currentValue: selectedAssetPair ??
                                  assetPairsSnapshot.data!.first,
                              list: assetPairsSnapshot.data!,
                              format: (AssetPairRecord item) {
                                return '${item.base.code}/${item.quote.code}';
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 18.0, bottom: 16.0),
                          child: Text(
                            '${(selectedAssetPair ?? assetPairsSnapshot.data!.first).base.code}/${(selectedAssetPair ?? assetPairsSnapshot.data!.first).quote.code}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: colorScheme.accent,
                              fontSize: 32.0,
                            ),
                          ),
                        ),
                        StreamBuilder<AssetChartData>(
                            stream: chartStreamController?.stream,
                            builder: (context,
                                AsyncSnapshot<AssetChartData> snapshot) {
                              if (snapshot.data == null &&
                                  _assetPairsRepository?.isNeverUpdated ==
                                      false &&
                                  snapshot.connectionState !=
                                      ConnectionState.waiting) {
                                return Center(
                                    child: Text(
                                  'loading'.tr,
                                  style: TextStyle(fontSize: 17.0),
                                ));
                              } else if (snapshot.connectionState !=
                                      ConnectionState.waiting &&
                                  snapshot.hasData) {
                                return Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.0),
                                    child:
                                        ChartView(snapshot.data!, timePeriod));
                              } else if (snapshot.hasError) {
                                log(snapshot.stackTrace.toString());
                                return Text(snapshot.error
                                    .toString()); // TODO display error correctly
                              }
                              return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(
                                      child: CircularProgressIndicator()));
                            }),
                        Row(
                          children: [
                            ConstrainedBox(
                              constraints: new BoxConstraints(
                                maxHeight: 45.0,
                              ),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: timePeriods.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (selectedTimePeriod != index) {
                                        setState(() {
                                          if (index == 0)
                                            timePeriod = ChartTimePeriod.hour;
                                          else if (index == 1)
                                            timePeriod = ChartTimePeriod.day;
                                          else if (index == 2)
                                            timePeriod = ChartTimePeriod.month;
                                          else if (index == 3)
                                            timePeriod = ChartTimePeriod.year;
                                          selectedTimePeriod = index;
                                        });
                                      }
                                    },
                                    child: Container(
                                        child: TimePeriodPicker(
                                            timePeriods[index],
                                            selectedTimePeriod == index)),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 32.0, bottom: 16.0),
                        ),
                        Column(mainAxisSize: MainAxisSize.min, children: [
                          Row(children: [
                            Text(
                              'open_orders'.tr,
                              style: TextStyle(
                                fontSize: 22.0,
                                color: colorScheme.drawerBackground,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ]),
                          Padding(
                            padding: EdgeInsets.only(top: 16.0),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'asks'.tr,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: colorScheme.drawerBackground,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child: Text(
                                    'see_all'.tr,
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderBookScreen(
                                              selectedAssetPair?.base.code ??
                                                  assetPairsSnapshot
                                                      .data!.first.base.code,
                                              selectedAssetPair?.quote.code ??
                                                  assetPairsSnapshot
                                                      .data!.first.quote.code,
                                              true,
                                            ))),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 14.0),
                            child: OrderBookList(
                              selectedAssetPair?.base.code ??
                                  assetPairsSnapshot.data!.first.base.code,
                              selectedAssetPair?.quote.code ??
                                  assetPairsSnapshot.data!.first.quote.code,
                              isFull: false,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16.0),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'bids'.tr,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: colorScheme.drawerBackground,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child: Text(
                                    'see_all'.tr,
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderBookScreen(
                                              selectedAssetPair?.base.code ??
                                                  'BTC',
                                              selectedAssetPair?.quote.code ??
                                                  'USD',
                                              false,
                                            ))),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 14.0),
                            child: OrderBookList(
                              selectedAssetPair?.base.code ?? 'BTC',
                              selectedAssetPair?.quote.code ?? 'USD',
                              isFull: false,
                              isAsk: false,
                            ),
                          ),
                        ]),
                        Padding(
                          padding: EdgeInsets.only(top: 32.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'trade_history'.tr,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: colorScheme.drawerBackground,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child: Text(
                                    'see_all'.tr,
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TradeHistoryScreen(
                                              selectedAssetPair?.base.code ??
                                                  '',
                                              selectedAssetPair?.quote.code ??
                                                  '',
                                            ))),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Visibility(
                            //TODO refactor
                            child: Padding(
                              padding: EdgeInsets.only(top: 14.0),
                              child: TradeHistoryList(
                                selectedAssetPair?.base.code ?? '',
                                selectedAssetPair?.quote.code ?? '',
                                addPadding: false,
                                isFull: false,
                              ),
                            ),
                            visible: selectedAssetPair != null,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16.0),
                        ),
                      ],
                    ),
                  );
                } else if (assetPairsSnapshot.hasError) {
                  log(assetPairsSnapshot.stackTrace.toString());
                  return Text(assetPairsSnapshot.error
                      .toString()); // TODO display error correctly
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
