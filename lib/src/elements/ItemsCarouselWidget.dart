import 'package:flutter/material.dart';

import '../elements/ItemsCarouselItemWidget.dart';
import '../elements/ItemsCarouselLoaderWidget.dart';
import '../models/item.dart';

// ignore: must_be_immutable
class ItemsCarouselWidget extends StatelessWidget {
  List<Item> itemsList = <Item>[];
  final String heroTag;

  ItemsCarouselWidget({Key key, this.itemsList, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return itemsList.isEmpty
        ? ItemsCarouselLoaderWidget()
        : Container(
            height: 210,
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              itemCount: itemsList.length,
              itemBuilder: (context, index) {
                double _marginLeft = 0;
                (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
                return ItemsCarouselItemWidget(
                  heroTag: heroTag,
                  marginLeft: _marginLeft,
                  item: itemsList.elementAt(index),
                );
              },
              scrollDirection: Axis.horizontal,
            ));
  }
}
