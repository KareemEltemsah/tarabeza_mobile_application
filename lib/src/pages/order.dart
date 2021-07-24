import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../elements/BlockButtonWidget.dart';
import '../models/table.dart';
import '../controllers/restaurant_controller.dart';

import '../../generated/l10n.dart';
import '../controllers/order_controller.dart';

import '../elements/OrderItemWidget.dart';
import '../elements/EmptyOrderWidget.dart';
import '../repository/order_repository.dart' as orderRepo;
import '../models/route_argument.dart';

class OrderWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  OrderWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends StateMVC<OrderWidget> {
  OrderController _con;
  List<RestaurantTable> tables = [];
  RestaurantTable selectedTable;

  _OrderWidgetState() : super(OrderController()) {
    _con = controller;
  }

  getRestaurantTables() async {
    RestaurantController tempCon = new RestaurantController();
    await tempCon
        .getRestaurantTables(orderRepo.currentOrder.value.restaurant_id);
    setState(() {
      tables = tempCon.tables;
    });
  }

  @override
  void initState() {
    super.initState();
    getRestaurantTables();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: orderRepo.currentOrder,
        builder: (context, value, child) {
          return Scaffold(
            key: _con.scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back),
                color: Theme.of(context).hintColor,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                S.of(context).order,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .merge(TextStyle(letterSpacing: 1.3)),
              ),
            ),
            body: orderRepo.currentOrder.value.orderItems.isEmpty
                ? EmptyOrderWidget()
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            S.of(context).verify_quantity_and_click_submit,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                        ListView.separated(
                          padding: EdgeInsets.only(top: 15, bottom: 20),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount:
                              orderRepo.currentOrder.value.orderItems.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: OrderItemWidget(
                                orderItem: orderRepo
                                    .currentOrder.value.orderItems
                                    .elementAt(index),
                                heroTag: 'orderItem',
                                increment: () {
                                  _con.incrementQuantity(orderRepo
                                      .currentOrder.value.orderItems
                                      .elementAt(index));
                                },
                                decrement: () {
                                  _con.decrementQuantity(orderRepo
                                      .currentOrder.value.orderItems
                                      .elementAt(index));
                                },
                                onDismissed: () {
                                  _con.removeFromOrder(orderRepo
                                      .currentOrder.value.orderItems
                                      .elementAt(index));
                                },
                              ),
                            );
                          },
                        ),
                        Column(
                          children: [
                            Text(
                              'Total price : ${orderRepo.currentOrder.value.getTotalPrice().toStringAsFixed(2)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Table number',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                SizedBox(width: 10),
                                DropdownButton(
                                    hint: Text('Choose table'),
                                    value: selectedTable,
                                    items: tables.map((t) {
                                      return DropdownMenuItem(
                                          value: t,
                                          child:
                                              new Text('table #${t.number}'));
                                    }).toList(),
                                    onChanged: (t) {
                                      setState(() {
                                        selectedTable = t;
                                        orderRepo.currentOrder.value.table_id =
                                            selectedTable.id;
                                        orderRepo.currentOrder.value
                                                .table_number =
                                            selectedTable.number;
                                        print(orderRepo.currentOrder.value
                                            .toMap());
                                      });
                                    })
                              ],
                            ),
                            SizedBox(height: 10),
                            BlockButtonWidget(
                              text: Text(
                                S.of(context).submit_order,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              color: Theme.of(context).accentColor,
                              onPressed: () {
                                selectedTable == null
                                    ? _con.scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                        content: Text("please choose a table first"),
                                        duration: Duration(seconds: 3),
                                      ))
                                    : _con.makeOrder();
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
          );
        });
  }
}
