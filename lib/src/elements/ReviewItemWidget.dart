import 'package:flutter/material.dart';
import '../helpers/helper.dart';
import '../models/review.dart';

// ignore: must_be_immutable
class ReviewItemWidget extends StatelessWidget {
  Review review;

  ReviewItemWidget({Key key, this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Wrap(
        direction: Axis.horizontal,
        runSpacing: 10,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            review.customer_name,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.headline6.merge(
                                TextStyle(color: Theme.of(context).hintColor)),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                          child: Chip(
                            padding: EdgeInsets.all(0),
                            label: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(review.rate,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .merge(TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor))),
                                Icon(
                                  Icons.star_border,
                                  color: Theme.of(context).primaryColor,
                                  size: 16,
                                ),
                              ],
                            ),
                            backgroundColor:
                                Theme.of(context).accentColor.withOpacity(0.9),
                            shape: StadiumBorder(),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      Helper.skipHtml(review.comment),
                      style: Theme.of(context).textTheme.bodyText2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
