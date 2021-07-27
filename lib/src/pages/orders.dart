import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/order_controller.dart';
import '../elements/EmptyOrdersWidget.dart';
import '../elements/WholeOrderItemWidget.dart';
import '../repository/user_repository.dart' as userRepo;
import '../elements/PermissionDeniedWidget.dart';
import '../repository/user_repository.dart';

class OrdersWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  OrdersWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends StateMVC<OrdersWidget> {
  OrderController _con;

  _OrdersWidgetState() : super(OrderController()) {
    _con = controller;
  }

  @override
  void initState() {
    currentUser.value.apiToken != null
        ? currentUser.value.role == "staff" ||
        currentUser.value.role == "restaurant_manager"
        ? _con.getRestaurantOrders()
        : _con.getUserOrders()
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _con.orders,
      builder: (BuildContext context, value, Widget child) {
        return Scaffold(
          key: _con.scaffoldKey,
          appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
              onPressed: () =>
                  widget.parentScaffoldKey.currentState.openDrawer(),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              currentUser?.value?.role == "staff" ||
                      currentUser?.value?.role == "restaurant_manager"
                  ? "Orders"
                  : S.of(context).my_orders,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .merge(TextStyle(letterSpacing: 1.3)),
            ),
          ),
          body: currentUser.value.apiToken == null
              ? PermissionDeniedWidget()
              : _con.orders.value.isEmpty
                  ? EmptyOrdersWidget()
                  : RefreshIndicator(
                      onRefresh: currentUser.value.role == "staff"
                          ? _con.getRestaurantOrders
                          : _con.getUserOrders,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: _con.orders.value.length,
                              itemBuilder: (context, index) {
                                var _order = _con.orders.value.elementAt(index);
                                return WholeOrderItemWidget(
                                  order: _order,
                                  cancel: () {
                                    _con.cancelOrder(_order);
                                  },
                                  approve: () {
                                    _con.approveOrder(_order);
                                  },
                                  finish: () {
                                    _con.finishOrder(_order);
                                  },
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 20);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
        );
      },
    );
  }
}
