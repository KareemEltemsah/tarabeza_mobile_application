import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../elements/TableItemWidget.dart';

import '../../generated/l10n.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/ReservationItemWidget.dart';
import '../repository/user_repository.dart' as userRepo;
import '../elements/PermissionDeniedWidget.dart';
import '../repository/user_repository.dart';

class TablesWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  TablesWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _TablesWidgetState createState() => _TablesWidgetState();
}

class _TablesWidgetState extends StateMVC<TablesWidget> {
  RestaurantController _con;

  _TablesWidgetState() : super(RestaurantController()) {
    _con = controller;
    _con.tables.clear();
    _con.getRestaurantTables(currentUser.value.restaurant_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Tables",
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: [IconButton(icon: Icon(Icons.add), onPressed: null)],
      ),
      body: _con.tables.isEmpty
          ? Center(
              child: Text(
                "No Results",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _con.tables.length,
                    itemBuilder: (context, index) {
                      var _table = _con.tables.elementAt(index);
                      return TableItemWidget(
                          table: _table,
                          hold: () {
                            _con.holdTable(_table);
                          },
                          release: () {
                            _con.releaseTable(_table);
                          });
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 20);
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
