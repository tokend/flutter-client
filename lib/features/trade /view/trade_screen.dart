import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/offers/view%20/my_offers_screen.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import 'exchange_tab.dart';

class TradeScreen extends StatelessWidget {
  final tabs = [
    'exchange'.tr,
    'my_orders'.tr,
  ];

  @override
  Widget build(BuildContext context) {
    var colourScheme = context.colorTheme;
    return DefaultTabController(
      length: tabs.length,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          color: colourScheme.background,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            TabBar(
              labelColor: colourScheme.primary,
              indicatorColor: colourScheme.primary,
              unselectedLabelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Container(
                  color: colourScheme.background,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Tab(
                    text: tabs[0],
                    iconMargin: EdgeInsets.zero,
                  ),
                ),
                Container(
                  color: colourScheme.background,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Tab(
                    text: tabs[1],
                    iconMargin: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    color: colourScheme.background,
                    child: ExchangeTab(),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    color: colourScheme.background,
                    child: MyOffersScreen(),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
