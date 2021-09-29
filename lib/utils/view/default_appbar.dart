import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/resources/sizes.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';

class DefaultAppBar extends AppBar {
  DefaultAppBar(
      {required String title,
      required Color color,
      required Function onBackPressed})
      : super(
          elevation: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.black.withOpacity(0), //top bar color
            statusBarIconBrightness:
                Brightness.dark, //top bar icon//bottom bar icons
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            splashRadius: 20,
            icon: Icon(CustomIcons.ic_chevron_left),
            onPressed: () {
              onBackPressed();
            },
          ),
          title: Text(
            title,
            style: TextStyle(
                color: color,
                fontSize: Sizes.textSizeDialog,
                fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        );
}
