import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/order.dart';
import '../repository/user_repository.dart' as userRepo;

// ignore: must_be_immutable
class WholeOrderItemWidget extends StatefulWidget {
  String heroTag;
  Order order;
  VoidCallback cancel;
  VoidCallback approve;
  VoidCallback finish;

  WholeOrderItemWidget(
      {Key key,
      this.order,
      this.heroTag,
      this.cancel,
      this.approve,
      this.finish})
      : super(key: key);

  @override
  _WholeOrderItemWidgetState createState() => _WholeOrderItemWidgetState();
}

class _WholeOrderItemWidgetState extends State<WholeOrderItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Customer: ${widget.order.customer_name}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          "Restaurant: ${widget.order.restaurant_name}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    flex: 4,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "table: ${widget.order.table_number}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          widget.order.is_finished
                              ? "finished"
                              : widget.order.is_approved
                                  ? "approved"
                                  : "submitted",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 15),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "item",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              flex: 3,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "qty",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "total",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: widget.order.orderItems.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.order.orderItems
                                        .elementAt(index)
                                        .item_name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  flex: 3,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    widget.order.orderItems
                                        .elementAt(index)
                                        .qty
                                        .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  flex: 1,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    widget.order.orderItems
                                        .elementAt(index)
                                        .total
                                        .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  flex: 1,
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                                onPressed: !widget.order.is_finished
                                    ? () {
                                        setState(() {
                                          widget.cancel();
                                        });
                                      }
                                    : null,
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                color: Theme.of(context).accentColor,
                                child: Text("Cancel"),
                                disabledColor: Theme.of(context).disabledColor),
                            SizedBox(
                              width: userRepo.currentUser.value.role == "staff"
                                  ? 15
                                  : 0,
                            ),
                            userRepo.currentUser.value.role == "staff"
                                ? FlatButton(
                                    onPressed: !widget.order.is_approved &&
                                        !widget.order.is_finished
                                        ? () {
                                            setState(() {
                                              widget.approve();
                                            });
                                          }
                                        : null,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    color: Theme.of(context).accentColor,
                                    child: Text("Approve"),
                                    disabledColor:
                                        Theme.of(context).disabledColor)
                                : SizedBox(
                                    height: 0,
                                    width: 0,
                                  ),
                            SizedBox(
                              width: userRepo.currentUser.value.role == "staff"
                                  ? 15
                                  : 0,
                            ),
                            userRepo.currentUser.value.role == "staff"
                                ? FlatButton(
                                    onPressed: !widget.order.is_finished
                                        ? () {
                                            setState(() {
                                              widget.finish();
                                            });
                                          }
                                        : null,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    color: Theme.of(context).accentColor,
                                    child: Text("Finish"),
                                    disabledColor:
                                        Theme.of(context).disabledColor)
                                : SizedBox(
                                    height: 0,
                                    width: 0,
                                  ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Date: ${widget.order.created_at}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
