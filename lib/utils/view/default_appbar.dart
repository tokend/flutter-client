import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/resources/sizes.dart';
import 'package:flutter_template/resources/theme/themes.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';

class DefaultAppBar extends AppBar {
  DefaultAppBar(
      {required BaseColorTheme colorTheme,
      required String title,
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
                fontWeight: FontWeight.w400,
                fontSize: Sizes.textSizeHeadingLarge,
                color: colorTheme.accent),
          ),
          centerTitle: true,
        );
}
