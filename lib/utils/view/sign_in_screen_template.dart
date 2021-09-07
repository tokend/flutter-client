import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/resources/assets.dart';
import 'package:flutter_template/resources/sizes.dart';

class SignInScreenTemplate extends StatelessWidget {
  final Widget child;

  SignInScreenTemplate({required this.child});

  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;

    final screenSize = MediaQuery.of(context).size;

    final imageSize = screenSize.width * 0.5;
    final imageMinHeight = 220.0;

    return Scaffold(
      backgroundColor: colorTheme.accent,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: imageSize,
              transform: Matrix4.translationValues(0.0, 25.0, 0.0),
              constraints: BoxConstraints(minHeight: imageMinHeight),
              alignment: Alignment.bottomCenter,
              child: Transform.scale(
                alignment: Alignment.bottomCenter,
                scale: 1.9,
                child: Opacity(
                  opacity: 0.15,
                  child: SvgPicture.asset(Assets.ic_city,
                      alignment: Alignment.bottomCenter),
                ),
              ),
            ),
            CustomScrollView(
              physics: ClampingScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      Container(
                        height: imageSize,
                        constraints: BoxConstraints(minHeight: imageMinHeight),
                      ),
                      Expanded(
                        child: Container(
                          constraints: BoxConstraints(minHeight: 400),
                          child: Card(
                            elevation: 0,
                            margin: EdgeInsets.zero,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Container(
                                color: colorTheme.background, child: child),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(Sizes.mediumRadius),
                                topRight: Radius.circular(Sizes.mediumRadius),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
