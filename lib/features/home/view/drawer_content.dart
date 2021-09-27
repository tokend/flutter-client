import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/home/logic/drawer_bloc.dart';
import 'package:flutter_template/features/home/logic/drawer_event.dart';
import 'package:flutter_template/features/home/logic/drawer_state.dart';
import 'package:flutter_template/resources/sizes.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class DrawerContent extends StatelessWidget {
  final String accountName;
  final String accountEmail;
  final List<_NavigationItem> _listItems = [
    //TODO update icons
    _NavigationItem(true, NavItem.dashboard, 'dashboard'.tr, CustomIcons.eye),
    _NavigationItem(false, NavItem.movements, 'movements'.tr, CustomIcons.eye),
    _NavigationItem(false, NavItem.assets, 'assets'.tr, CustomIcons.eye),
    _NavigationItem(false, NavItem.sales, 'sales'.tr, CustomIcons.eye),
    _NavigationItem(false, NavItem.polls, 'polls'.tr, CustomIcons.eye),
    _NavigationItem(false, NavItem.trade, 'trade'.tr, CustomIcons.eye),
    _NavigationItem(false, NavItem.issuance_request, 'issuance_requests'.tr,
        CustomIcons.eye),
    _NavigationItem(false, NavItem.limits, 'limits'.tr, CustomIcons.eye),
    _NavigationItem(false, NavItem.fees, 'fees'.tr, CustomIcons.eye),
    _NavigationItem(false, NavItem.settings, 'settings'.tr, CustomIcons.eye),
    _NavigationItem(false, NavItem.log_out, 'log_out'.tr, CustomIcons.eye),
  ];

  DrawerContent(this.accountName, this.accountEmail);

  //TODO create header
  @override
  Widget build(BuildContext context) => Drawer(
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
                  itemCount: _listItems.length,
                  itemBuilder: (BuildContext context, int index) =>
                      BlocBuilder<DrawerBloc, DrawerState>(
                        builder: (BuildContext context, DrawerState state) =>
                            _buildItem(_listItems[index], state, context),
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

  Widget _buildItem(
          _NavigationItem data, DrawerState state, BuildContext context) =>
      data.header
          // if the item is a header return the header widget
          ? makeHeader(context)
          // otherwise build and return the default list item
          : _makeListItem(data, state, context);

  Widget makeHeader(BuildContext context) {
    return Card(
      color: context.colorTheme.drawerBackground,
      margin: EdgeInsets.only(top: 100.0, left: 30.0),
      //shape: ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 0,
      child: Row(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: CircleAvatar(
                    backgroundColor: context.colorTheme.buttonDisabled,
                    radius: 24,
                    child: Icon(
                      Icons.person,
                      color: context.colorTheme.secondaryText,
                    )),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "Dafna Shvimer", //TODO
                style: TextStyle(color: context.colorTheme.secondaryText),
              ),
              Row(
                children: [
                  Icon(CustomIcons.eye,
                      color: context.colorTheme.secondaryText, size: 12),
                  Padding(
                    padding: EdgeInsets.only(left: 6.0),
                    child: Text(
                      "Unverified account", //TODO
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

  Widget _makeHeaderItem(BuildContext context) => UserAccountsDrawerHeader(
        accountName: Text(accountName, style: TextStyle(color: Colors.white)),
        accountEmail: Text(accountEmail, style: TextStyle(color: Colors.white)),
        decoration: BoxDecoration(color: Colors.blueGrey),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.amber,
          child: Icon(
            Icons.person,
            size: 54,
          ),
        ),
      );

  Widget _makeListItem(
          _NavigationItem data, DrawerState state, BuildContext context) =>
      Card(
        color: context.colorTheme.drawerBackground,
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Builder(
          builder: (BuildContext context) => ListTile(
            title: Text(
              data.title!,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            leading: Icon(
              data.icon,
              // if it's selected change the color
              color: Colors.white,
            ),
            onTap: () => _handleItemClick(context, data.item),
          ),
        ),
      );

  void _handleItemClick(BuildContext context, NavItem? item) {
    if (item != null) {
      BlocProvider.of<DrawerBloc>(context).add(NavigateTo(item));
      Navigator.pop(context);
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
}

// helper class used to represent navigation list items
class _NavigationItem {
  final bool header;
  final NavItem? item;
  final String? title;
  final IconData? icon;

  _NavigationItem(this.header, this.item, this.title, this.icon);
}
