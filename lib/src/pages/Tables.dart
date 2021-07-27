import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:tarabeza_mobile_application/src/models/table.dart';
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
  RestaurantTable table = new RestaurantTable();
  TextEditingController tableNumber = new TextEditingController();
  TextEditingController tableChairs = new TextEditingController();

  _TablesWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.getRestaurantTables(currentUser.value.restaurant_id);
    super.initState();
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
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      titlePadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      title: Row(
                        children: <Widget>[
                          Text(
                            "Add table",
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                      ),
                      children: [
                        new TextFormField(
                          controller: tableNumber,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Table number",
                            labelStyle:
                                TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 10),
                        new TextFormField(
                          controller: tableChairs,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "No of chairs",
                            labelStyle:
                                TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(S.of(context).cancel),
                            ),
                            MaterialButton(
                              onPressed: () {
                                if (!tableNumber.text.isEmpty &&
                                    !tableNumber.text.trim().isEmpty &&
                                    !tableChairs.text.isEmpty &&
                                    !tableChairs.text.trim().isEmpty) {
                                  table.number = tableNumber.text;
                                  table.no_of_chairs = tableChairs.text;
                                  table.restaurant_id =
                                      userRepo.currentUser.value.restaurant_id;
                                  _con.addTable(table).then((value) {
                                    Navigator.pop(context);
                                  });
                                }
                              },
                              child: Text(
                                S.of(context).submit,
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.end,
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  },
                );
              })
        ],
      ),
      body: _con.tables.isEmpty
          ? Center(
              child: Text(
                "No Tables",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            )
          : SingleChildScrollView(
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
