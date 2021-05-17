import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/item.dart';
import '../models/route_argument.dart';

class ItemWidget extends StatelessWidget {
  final String heroTag;
  final Item item;

  const ItemWidget({Key key, this.item, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        // Navigator.of(context).pushNamed('/Item',
        //     arguments: RouteArgument(id: item.id, heroTag: this.heroTag));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: heroTag + item.id,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Icon(Icons.fastfood, size: 30,),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Helper.getPrice(
                        item.price,
                        context,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      item.discount > 0
                          ? Helper.getPrice(item.getDiscountedPrice(), context,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .merge(TextStyle(
                                      decoration: TextDecoration.lineThrough)))
                          : SizedBox(height: 0),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
