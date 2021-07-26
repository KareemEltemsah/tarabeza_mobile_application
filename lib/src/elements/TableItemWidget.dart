import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../controllers/restaurant_controller.dart';

import '../models/table.dart';
import '../repository/user_repository.dart' as userRepo;

// ignore: must_be_immutable
class TableItemWidget extends StatefulWidget {
  String heroTag;
  RestaurantTable table;
  VoidCallback hold;
  VoidCallback release;

  TableItemWidget({Key key, this.table, this.heroTag, this.hold, this.release}) : super(key: key);

  @override
  _TableItemWidgetState createState() => _TableItemWidgetState();
}

class _TableItemWidgetState extends StateMVC<TableItemWidget> {
  RestaurantController _con;

  _TableItemWidgetState() : super(RestaurantController()) {
    _con = controller;
    _con.getRestaurantTables(userRepo.currentUser.value.restaurant_id);
  }

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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Table: ${widget.table.number}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          "No of chairs: ${widget.table.no_of_chairs}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text(
                      widget.table.is_reserved ? "Busy" : "Available",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    flex: 2,
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                      onPressed: !widget.table.is_reserved
                          ? () {
                              setState(() {
                                widget.hold();
                              });
                            }
                          : null,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      color: Theme.of(context).accentColor,
                      child: Text("Busy"),
                      disabledColor: Theme.of(context).disabledColor),
                  SizedBox(width: 15),
                  FlatButton(
                      onPressed: widget.table.is_reserved
                          ? () {
                              setState(() {
                                widget.release();
                              });
                            }
                          : null,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      color: Theme.of(context).accentColor,
                      child: Text("Available"),
                      disabledColor: Theme.of(context).disabledColor)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
