import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/item.dart';
import '../models/order_item.dart';
import '../repository/order_repository.dart' as orderRepo;
import '../../generated/l10n.dart';

class ItemWidget extends StatefulWidget {
  final String heroTag;
  final Item item;
  final bool clickable;

  const ItemWidget({
    Key key,
    this.item,
    this.heroTag,
    this.clickable,
  }) : super(key: key);

  @override
  _ItemWidgetState createState() {
    return _ItemWidgetState();
  }
}

class _ItemWidgetState extends State<ItemWidget> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();
  }

  _itemBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (context) {
          quantity = 1;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: 230,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 110,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                widget.item?.name ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Helper.getPrice(
                                    widget.item.getPrice(),
                                    context,
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                  widget.item.discount > 0
                                      ? Helper.getPrice(
                                          widget.item.price, context,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .merge(TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough)))
                                      : SizedBox(height: 0),
                                ],
                              ),
                            ),
                          ],
                        )),
                    SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 110,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              S.of(context).quantity,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  setModalState(() {
                                    if (quantity > 1) quantity--;
                                  });
                                },
                                iconSize: 30,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                icon: Icon(Icons.remove_circle_outline),
                                color: Theme.of(context).hintColor,
                              ),
                              Text(
                                quantity.toString(),
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              IconButton(
                                onPressed: () {
                                  setModalState(() {
                                    quantity++;
                                  });
                                },
                                iconSize: 30,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                icon: Icon(Icons.add_circle_outline),
                                color: Theme.of(context).hintColor,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 110,
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            OrderItem oi = new OrderItem(
                              widget.item,
                              quantity,
                              DateTime.now().microsecond.toString(),
                            );
                            orderRepo.addOrderItem(oi);
                          });
                        },
                        padding: EdgeInsets.symmetric(vertical: 14),
                        color: Theme.of(context).accentColor,
                        shape: StadiumBorder(),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  S.of(context).add_to_order,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                              Helper.getPrice(
                                (widget.item.getPrice() * quantity),
                                context,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .merge(TextStyle(
                                        color: Theme.of(context).primaryColor)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            );
          });
        });
  }

  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: widget.clickable ? () {
         _itemBottomSheet();
      }: null,
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
              tag: widget.heroTag + widget.item.id + '${DateTime.now()}',
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Icon(
                  Icons.fastfood,
                  size: 30,
                ),
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
                          widget.item.name,
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
                        widget.item.getPrice(),
                        context,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      widget.item.discount > 0
                          ? Helper.getPrice(widget.item.price, context,
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
