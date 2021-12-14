import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomModalBottomSheet extends StatelessWidget {
  const CustomModalBottomSheet({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildHandle(context), if (child != null) child!],
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    final theme = Theme.of(context);

    return FractionallySizedBox(
      widthFactor: 0.25,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 12.0,
        ),
        child: Container(
          height: 5.0,
          decoration: BoxDecoration(
            color: theme.dividerColor,
            borderRadius: const BorderRadius.all(Radius.circular(2.5)),
          ),
        ),
      ),
    );
  }
}

Widget buildListItem(
  BuildContext context, {
  Widget? title,
  Widget? leading,
  Widget? trailing,
  bool isDivided = false,
}) {
  final theme = Theme.of(context);

  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 24.0,
      vertical: 16.0,
    ),
    decoration: isDivided
        ? BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor,
                width: 0.5,
              ),
            ),
          )
        : null,
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (leading != null) leading,
        if (title != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: DefaultTextStyle(
              child: title,
              style: theme.textTheme.headline6!,
            ),
          ),
        Spacer(),
        if (trailing != null) trailing,
      ],
    ),
  );
}

Widget buildCenterListItem(BuildContext context, {Widget? title}) {
  final theme = Theme.of(context);

  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 24.0,
      vertical: 16.0,
    ),
    child: Center(
        child: title != null
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: DefaultTextStyle(
                  child: title,
                  style: theme.textTheme.headline6!,
                ),
              )
            : Text("")),
  );
}
