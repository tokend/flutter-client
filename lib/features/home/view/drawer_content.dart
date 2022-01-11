import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/di/main_bindings.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/account/model/account_role.dart';
import 'package:flutter_template/features/home/logic/drawer_bloc.dart';
import 'package:flutter_template/features/home/logic/drawer_event.dart';
import 'package:flutter_template/features/home/logic/drawer_state.dart';
import 'package:flutter_template/features/kyc/model/active_kyc.dart';
import 'package:flutter_template/features/kyc/model/kyc_form.dart';
import 'package:flutter_template/resources/sizes.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:get/get.dart';

final List<NavigationItemData> listItems = [
  NavigationItemData(true, null, null, CustomIcons.element_3),
  NavigationItemData(
      false, NavItem.dashboard, 'dashboard'.tr, CustomIcons.element_3),
  NavigationItemData(
      false, NavItem.movements, 'movements'.tr, CustomIcons.message_text),
  NavigationItemData(false, NavItem.assets, 'assets'.tr, CustomIcons.blend_2),
  NavigationItemData(false, NavItem.sales, 'sales'.tr, CustomIcons.diagram),
  NavigationItemData(
      false, NavItem.polls, 'polls'.tr, CustomIcons.clipboard_tick),
  NavigationItemData(false, NavItem.trade, 'trade'.tr, CustomIcons.status_up),
  NavigationItemData(false, NavItem.issuance_request, 'issuance_requests'.tr,
      CustomIcons.chart),
  NavigationItemData(
      false, NavItem.limits, 'limits'.tr, CustomIcons.favorite_chart),
  NavigationItemData(false, NavItem.fees, 'fees'.tr, CustomIcons.graph),
  NavigationItemData(
      false, NavItem.settings, 'settings'.tr, CustomIcons.setting_2),
  NavigationItemData(false, NavItem.log_out, 'log_out'.tr, CustomIcons.login),
];

class DrawerContent extends BaseStatelessWidget {
  final String accountName;
  final String accountEmail;

  DrawerContent(this.accountName, this.accountEmail) {
    if (repositoryProvider.activeKyc.isNeverUpdated == true) {
      subscribeToActiveKyc();
    }

    streamController = repositoryProvider.activeKyc.streamSubject;

    if (repositoryProvider.account.isNeverUpdated) {
      updateAccount();
    }
  }

  var streamController;

  void subscribeToActiveKyc() async {
    await repositoryProvider.activeKyc.getItem();
  }

  void updateAccount() async {
    await repositoryProvider.account.getItem();
  }

  //TODO create header
  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: streamController.stream,
        builder: (context, AsyncSnapshot<ActiveKyc> snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting &&
              snapshot.hasData) {
            return Drawer(
                // Add a ListView to the drawer. This ensures the user can scroll
                // through the options in the drawer if there isn't enough vertical
                // space to fit everything.
                child: Container(
                    color: context.colorTheme.drawerBackground,
                    child: Stack(
                      children: [
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: EdgeInsets.only(left: 10.0),
                            itemCount: listItems.length,
                            itemBuilder: (BuildContext context, int index) =>
                                BlocBuilder<DrawerBloc, DrawerState>(
                                  builder: (BuildContext context,
                                          DrawerState state) =>
                                      _buildItem(snapshot, listItems[index],
                                          state, context),
                                )),
                        Positioned(
                          bottom: 24.0,
                          child: Padding(
                            padding: EdgeInsets.only(left: 30.0),
                            child: makeFooter(context),
                          ),
                        )
                      ],
                    )));
          }
          return CircularProgressIndicator();
        },
      );

  Widget _buildItem(AsyncSnapshot<ActiveKyc> snapshot, NavigationItemData data,
          DrawerState state, BuildContext context) =>
      data.header
          // if the item is a header return the header widget
          ? makeHeader(snapshot, context)
          // otherwise build and return the default list item
          : _makeListItem(data, state, context);

  Widget makeHeader(AsyncSnapshot<ActiveKyc> snapshot, BuildContext context) {
    var form = ((snapshot.data as ActiveKycForm).formData
        as GeneralKycForm); //TODO not always acc is general
    var documentUrl = form.documents?['kyc_avatar']
        ?.getUrl(urlConfigProvider.getConfig().storage);
    return Card(
      color: context.colorTheme.drawerBackground,
      margin: EdgeInsets.only(top: 100.0, left: 20.0),
      elevation: 0,
      child: Row(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: documentUrl != null
                    ? CircleAvatar(
                        backgroundColor: context.colorTheme.buttonDisabled,
                        radius: 24,
                        backgroundImage: NetworkImage(documentUrl),
                      )
                    : CircleAvatar(
                        child: Icon(
                          Icons.person,
                          color: context.colorTheme.secondaryText,
                        ),
                      ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${form.firstName} ${form.lastName}',
                style: TextStyle(
                    color: context.colorTheme.secondaryText, fontSize: 17.0),
                textAlign: TextAlign.start,
              ),
              Row(
                children: [
                  Icon(CustomIcons.info_circle,
                      color: context.colorTheme.secondaryText, size: 12),
                  Padding(
                    padding: EdgeInsets.only(left: 6.0),
                    child: Text(
                      getLocalizedNameForAccountRole(repositoryProvider
                          .account.streamSubject.value.role.accountRole),
                      style: TextStyle(
                          color: context.colorTheme.secondaryText,
                          fontSize: Sizes.textSizeHint),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _makeListItem(
          NavigationItemData data, DrawerState state, BuildContext context) =>
      Card(
        color: context.colorTheme.drawerBackground,
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Builder(
          builder: (BuildContext context) => ListTile(
            minLeadingWidth: 10,
            title: Text(
              data.title!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.0,
              ),
            ),
            leading: Icon(
              data.icon,
              // if it's selected change the color
              color: Colors.white,
              size: 24.0,
            ),
            onTap: () => _handleItemClick(context, data.item),
          ),
        ),
      );

  void _handleItemClick(BuildContext context, NavItem? item) {
    if (item != null) {
      if (item == NavItem.log_out) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('confirm_sign_out'.tr),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('cancel'.tr),
                  ),
                  TextButton(
                    onPressed: () => signOut(),
                    child: Text('ok'.tr),
                  ),
                ],
              );
            });
      } else {
        BlocProvider.of<DrawerBloc>(context).add(NavigateTo(item));
        Navigator.pop(context);
      }
    }
  }

  Widget makeFooter(BuildContext context) {
    return Text(
      'footer'.tr,
      style: TextStyle(
          color: context.colorTheme.secondaryText,
          fontSize: Sizes.textSizeHint),
    );
  }

  signOut({bool soft = false}) {
    //Delete all dependencies for current account
    sharedPreferences.clear();
    Get.deleteAll();
    MainBindings(env, sharedPreferences).dependencies();

    Get.offAllNamed('/signIn');
  }
}

// helper class used to represent navigation list items
class NavigationItemData {
  final bool header;
  final NavItem? item;
  final String? title;
  final IconData? icon;

  NavigationItemData(this.header, this.item, this.title, this.icon);
}

String getLocalizedNameForAccountRole(String accountRole) {
  log('getLocalizedNameForAccountRole $accountRole');
  switch (accountRole) {
    case AccountRole.UNVERIFIED:
      return 'unverified_acc'.tr;
    case AccountRole.GENERAL:
      return 'general_acc'.tr;
    case AccountRole.CORPORATE:
      return 'corporate_acc'.tr;
    case AccountRole.BLOCKED:
      return 'blocked_acc'.tr;
    default:
      return 'unknown_acc'.tr;
  }
}
