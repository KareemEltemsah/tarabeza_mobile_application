import 'package:flutter/material.dart';

import '../repository/order_repository.dart' as orderRepo;
import '../repository/user_repository.dart';

class OrderButtonWidget extends StatefulWidget {
  const OrderButtonWidget({
    this.iconColor,
    this.labelColor,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;

  @override
  _OrderButtonWidgetState createState() => _OrderButtonWidgetState();
}

class _OrderButtonWidgetState extends State<OrderButtonWidget> {
  _OrderButtonWidgetState() : super() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: orderRepo.currentOrder,
      builder: (context, value, child) {
        return FlatButton(
          onPressed: () {
            if (currentUser.value.apiToken != null) {
              Navigator.of(context).pushNamed('/Order');
            } else {
              Navigator.of(context).pushNamed('/Login');
            }
          },
          child: Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: <Widget>[
              Icon(
                Icons.local_mall_rounded,
                color: this.widget.iconColor,
                size: 28,
              ),
              Container(
                child: Text(
                  orderRepo.currentOrder.value.orderItems.length.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption.merge(
                        TextStyle(
                            color: Theme.of(context).primaryColor, fontSize: 9),
                      ),
                ),
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                    color: this.widget.labelColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                constraints: BoxConstraints(
                    minWidth: 15, maxWidth: 15, minHeight: 15, maxHeight: 15),
              ),
            ],
          ),
          color: Colors.transparent,
        );
      },
    );
  }
}
