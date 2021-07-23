import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

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

  _OrderWidgetState() : super(OrderController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: orderRepo.currentOrder,
        builder: (context, value, child) {
          return Scaffold(
            key: _con.scaffoldKey,
            // bottomNavigationBar: OrderBottomDetailsWidget(con: _con),
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
                : Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      ListView(
                        primary: true,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 10),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              leading: Icon(
                                Icons.local_mall_rounded,
                                color: Theme.of(context).hintColor,
                              ),
                              title: Text(
                                S.of(context).order,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              subtitle: Text(
                                S
                                    .of(context)
                                    .verify_quantity_and_click_submit,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          ),
                          ListView.separated(
                            padding: EdgeInsets.only(top: 15, bottom: 120),
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
                        ],
                      ),
                      Center(
                        child: Text(
                          orderRepo.currentOrder.value
                              .getTotalPrice()
                              .toStringAsFixed(2),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ],
                  ),
          );
        });
  }
}
