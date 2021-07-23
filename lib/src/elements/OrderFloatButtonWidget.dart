import 'package:flutter/material.dart';

import '../repository/order_repository.dart' as orderRepo;
import '../repository/user_repository.dart';

class OrderFloatButtonWidget extends StatefulWidget {
  const OrderFloatButtonWidget({
    this.iconColor,
    this.labelColor,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;

  @override
  _OrderFloatButtonWidgetState createState() => _OrderFloatButtonWidgetState();
}

class _OrderFloatButtonWidgetState extends State<OrderFloatButtonWidget> {
  _OrderFloatButtonWidgetState() : super() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: RaisedButton(
        padding: EdgeInsets.all(0),
        color: Theme.of(context).accentColor,
        shape: StadiumBorder(),
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
      ),
    );
  }
}
