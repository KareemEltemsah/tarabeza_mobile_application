import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/item.dart';
import '../models/route_argument.dart';

class ItemsCarouselItemWidget extends StatelessWidget {
  final double marginLeft;
  final Item item;
  final String heroTag;

  ItemsCarouselItemWidget({Key key, this.heroTag, this.marginLeft, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      highlightColor: Colors.transparent,
      onTap: () {
        // Navigator.of(context).pushNamed('/Item', arguments: RouteArgument(id: item.id, heroTag: heroTag));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.topEnd,
            children: <Widget>[
              Hero(
                tag: heroTag + item.id,
                child: Container(
                  margin: EdgeInsetsDirectional.only(start: this.marginLeft, end: 20),
                  width: 100,
                  height: 130,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: Image.network(
                      '',
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context,
                          Object exception, StackTrace stackTrace) {
                        return Icon(Icons.fastfood);
                      },
                    ),
                    /*CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: '',
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.fastfood),
                    ),*/
                  ),
                ),
              ),
              Container(
                margin: EdgeInsetsDirectional.only(end: 25, top: 5),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: item.discount > 0 ? Colors.red : Theme.of(context).accentColor,
                ),
                alignment: AlignmentDirectional.topEnd,
                child: Helper.getPrice(
                  item.getPrice(),
                  context,
                  style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Container(
              width: 100,
              margin: EdgeInsetsDirectional.only(start: this.marginLeft, end: 20),
              child: Column(
                children: <Widget>[
                  Text(
                    this.item.name,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  /*Text(
                    item.restaurant_id,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: Theme.of(context).textTheme.caption,
                  ),*/
                ],
              )),
        ],
      ),
    );
  }
}
