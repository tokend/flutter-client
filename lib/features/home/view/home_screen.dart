import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/assets/view/assets_screen.dart';
import 'package:flutter_template/features/balances/view/balances_screen.dart';
import 'package:flutter_template/features/home/logic/drawer_bloc.dart';
import 'package:flutter_template/features/home/logic/drawer_state.dart';
import 'package:flutter_template/features/home/view/drawer_content.dart';
import 'package:flutter_template/features/offers/view%20/create_order_bottom_dialog.dart';
import 'package:flutter_template/features/sales/view/list/sales_list_screen.dart';
import 'package:flutter_template/features/settings/view/settings_screen.dart';
import 'package:flutter_template/features/trade%20/view/trade_screen.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:flutter_template/utils/view/default_bottom_dialog.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class HomeScreen extends BaseStatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider<DrawerBloc>(
      create: (BuildContext context) =>
          DrawerBloc(DrawerState(NavItem.dashboard)),
      child: BlocBuilder<DrawerBloc, DrawerState>(
        builder: (BuildContext context, DrawerState state) => Scaffold(
          body: _getCurrentPage(state.selectedItem),
          drawer: DrawerContent("Joe Shmoe", "shmoe@joesemail.com"),
          //TODO kyc data
          appBar: AppBar(
            backgroundColor: context.colorTheme.background,
            iconTheme: IconThemeData(color: context.colorTheme.accent),
            title: Text(
              _getTextForItem(state.selectedItem),
              style:
                  TextStyle(color: context.colorTheme.accent, fontSize: 28.0),
            ),
            actions: state.selectedItem == NavItem.trade
                ? [
                    IconButton(
                      icon: Icon(
                        CustomIcons.add,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => DefaultBottomDialog(
                                  CreateOrderScaffold(repositoryProvider
                                      .assetPairsRepository
                                      .streamSubject
                                      .value),
                                  height:
                                      MediaQuery.of(context).size.height * 0.9,
                                ));
                      },
                    )
                  ]
                : [],
            elevation: 0,
          ),
        ),
      ));

  String _getTextForItem(NavItem item) {
    String defaultTitle = 'app_title'.tr;
    if (listItems.firstWhere((element) => element.item == item).title != null) {
      return listItems.firstWhere((element) => element.item == item).title!;
    }
    return defaultTitle;
  }

  Widget _getCurrentPage(NavItem item) {
    switch (item) {
      case NavItem.dashboard:
        return BalancesScreen(false, false);
      case NavItem.movements:
        return BalancesScreen(true, false);
      case NavItem.assets:
        return AssetsScreen();
      case NavItem.sales:
        return SalesListScreen();
      case NavItem.polls:
        // TODO: Handle this case.
        break;
      case NavItem.trade:
        return TradeScreen();
      case NavItem.issuance_request:
        // TODO: Handle this case.
        break;
      case NavItem.limits:
        // TODO: Handle this case.
        break;
      case NavItem.fees:
        // TODO: Handle this case.
        break;
      case NavItem.settings:
        return SettingsScreen();
      case NavItem.log_out:
        // TODO: Handle this case.
        break;
    }

    return BalancesScreen(false, false);
  }
}
