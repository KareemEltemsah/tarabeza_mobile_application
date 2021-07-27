import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../controllers/restaurant_controller.dart';
import '../models/reservation.dart';

// ignore: must_be_immutable
class ReservationItemWidget extends StatefulWidget {
  String heroTag;
  Reservation reservation;

  ReservationItemWidget({Key key, this.reservation, this.heroTag})
      : super(key: key);

  @override
  _ReservationItemWidgetState createState() => _ReservationItemWidgetState();
}

class _ReservationItemWidgetState extends State<ReservationItemWidget> {
  String tableNumber;

  getTableNumber() async {
    RestaurantController tempCon = new RestaurantController();
    String n = await tempCon.getTableNumberByID(
        widget.reservation.restaurant_id, widget.reservation.table_id);
    try {
      setState(() {
        tableNumber = n;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    getTableNumber();
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
                          "${widget.reservation.customer_name}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          "${widget.reservation.restaurant_name}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                    flex: 4,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Table: ${tableNumber != null ? tableNumber : "#"}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          widget.reservation.requested_at.substring(5, 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                    flex: 2,
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Date: ${widget.reservation.created_at}",
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
