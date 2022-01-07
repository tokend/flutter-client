import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';

class SecurityListItem extends StatelessWidget {
  String itemName;
  String itemDescription;
  IconData icon;
  Function()? onTap;

  SecurityListItem(this.itemName, this.itemDescription, this.icon,
      {this.onTap});

  @override
  Widget build(BuildContext context) {
    var colourScheme = context.colorTheme;

    return Card(
      elevation: 0.0,
      color: colourScheme.background,
      margin: EdgeInsets.zero,
      child: Builder(
        builder: (BuildContext context) => GestureDetector(
          onTap: () {
            onTap?.call();
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 50,
            ),
            child: ListTile(
              minLeadingWidth: 12,
              leading: Icon(
                icon,
                color: colourScheme.primaryText,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$itemDescription',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12.0,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                  ),
                  Row(
                    children: [
                      Text('$itemName',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ],
                  )
                ],
              ),
              trailing: Icon(Icons.keyboard_arrow_right), //TODO add custom icon
            ),
          ),
        ),
      ),
    );
  }
}
