import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../controllers/search_controller.dart';
import '../elements/CardWidget.dart';
import '../models/route_argument.dart';

class SearchResultWidget extends StatefulWidget {
  final String heroTag;

  SearchResultWidget({Key key, this.heroTag}) : super(key: key);

  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends StateMVC<SearchResultWidget> {
  SearchController _con;

  _SearchResultWidgetState() : super(SearchController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              trailing: IconButton(
                icon: Icon(Icons.close),
                color: Theme.of(context).hintColor,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                S.of(context).search,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ),
          Stack(alignment: Alignment.centerRight, children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                onChanged: (text) {
                  _con.refreshSearch(text);
                  _con.saveSearch(text);
                },
                autofocus: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 12, 48, 12),
                  hintText: S.of(context).search_for_restaurants,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .caption
                      .merge(TextStyle(fontSize: 14)),
                  prefixIcon:
                      Icon(Icons.search, color: Theme.of(context).accentColor),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).focusColor.withOpacity(0.1))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).focusColor.withOpacity(0.3))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).focusColor.withOpacity(0.1))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: IconButton(
                onPressed: () {
                  // Below line stops keyboard from appearing
                  FocusScope.of(context).requestFocus(new FocusNode());
                  Scaffold.of(context).openEndDrawer();
                },
                icon:
                    Icon(Icons.filter_list, color: Theme.of(context).hintColor),
              ),
            ),
          ]),
          _con.restaurants.isEmpty
              ? Center(
                  child: Text(
                    "No Results",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                )
              : Expanded(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          title: Text(
                            S.of(context).restaurants_results,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _con.restaurants.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/Details',
                                  arguments: RouteArgument(
                                    id: '0',
                                    param: _con.restaurants.elementAt(index).id,
                                    heroTag: widget.heroTag,
                                  ));
                            },
                            child: CardWidget(
                                restaurant: _con.restaurants.elementAt(index),
                                heroTag: widget.heroTag),
                          );
                        },
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
