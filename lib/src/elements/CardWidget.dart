import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/restaurant.dart';

// ignore: must_be_immutable
class CardWidget extends StatelessWidget {
  Restaurant restaurant;
  String heroTag;

  CardWidget({Key key, this.restaurant, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 292,
      margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.1),
              blurRadius: 15,
              offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Image of the card
          Stack(
            fit: StackFit.loose,
            alignment: AlignmentDirectional.bottomStart,
            children: <Widget>[
              Hero(
                tag: this.heroTag + restaurant.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: Image.network(
                    '${GlobalConfiguration().getValue('logos_base_url')}${restaurant.logo_url}',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                      return Icon(Icons.error);
                    },
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                        color:
                            restaurant.isClosed() ? Colors.red : Colors.green,
                        borderRadius: BorderRadius.circular(24)),
                    child: restaurant.isClosed()
                        ? Text(
                            S.of(context).closed,
                            style: Theme.of(context).textTheme.caption.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          )
                        : Text(
                            S.of(context).open,
                            style: Theme.of(context).textTheme.caption.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                      decoration: BoxDecoration(
                          color: restaurant.reservation_active
                              ? Colors.green
                              : Colors.red,
                          borderRadius: BorderRadius.circular(24)),
                      child: Text(
                        S.of(context).reservation,
                        style: Theme.of(context).textTheme.caption.merge(
                            TextStyle(color: Theme.of(context).primaryColor)),
                      )),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        restaurant.name,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: Helper.getStarsList(
                            double.parse(restaurant.rating)),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          launch(
                              "geo:${restaurant.latitude},${restaurant.longitude}");
                        },
                        child: Icon(Icons.directions,
                            color: Theme.of(context).primaryColor),
                        color: Theme.of(context).accentColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      restaurant.distance != null
                          ? Text(
                              restaurant.distance.substring(
                                  0, restaurant.distance.lastIndexOf(' ')),
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                            )
                          : SizedBox(height: 0)
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
