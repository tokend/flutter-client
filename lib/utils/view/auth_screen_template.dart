import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/resources/sizes.dart';

class AuthScreenTemplate extends StatelessWidget {
  final Widget child;

  AuthScreenTemplate({required this.child});

  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;

    final screenSize = MediaQuery.of(context).size;

    final imageSize = screenSize.width * 0.5;
    final imageMinHeight = 100.0;

    return Scaffold(
      backgroundColor: colorTheme.accent,
      body: SafeArea(
        child: Stack(
          children: [
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
                                topLeft:
                                    Radius.circular(Sizes.backgroundCardRadius),
                                topRight:
                                    Radius.circular(Sizes.backgroundCardRadius),
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
