import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:global_configuration/global_configuration.dart';
import '../../generated/l10n.dart';
import '../controllers/home_controller.dart';
import '../elements/CardsCarouselWidget.dart';
import '../elements/ItemsCarouselWidget.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../elements/SearchWidget.dart';
import '../repository/user_repository.dart' as userRepo;

class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomeWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> {
  HomeController _con;

  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: settingsRepo.setting,
          builder: (context, value, child) {
            return Text(
              value.appName ?? S.of(context).home,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .merge(TextStyle(letterSpacing: 1.3)),
            );
          },
        ),
        actions: <Widget>[
          userRepo.currentUser?.value?.role != "restaurant_manager"
              ? new IconButton(
                  icon: new Icon(Icons.search,
                      color: Theme.of(context).hintColor),
                  onPressed: () => Navigator.of(context).push(SearchModal()),
                )
              : SizedBox(width: 0),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshHome,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: userRepo.currentUser?.value?.role != "restaurant_manager"
                ? List.generate(settingsRepo.setting.value.homeSections.length,
                    (index) {
                    String _homeSection = settingsRepo
                        .setting.value.homeSections
                        .elementAt(index);
                    switch (_homeSection) {
                      case 'recent_restaurants_heading':
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 20, right: 20, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      S.of(context).recent_restaurants,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      case 'recent_restaurants':
                        return CardsCarouselWidget(
                            restaurantsList: _con.recentRestaurants,
                            heroTag: 'home_recent_restaurants');
                      case 'recent_items_heading':
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          title: Text(
                            S.of(context).recent_Items,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          subtitle: Text(
                            S.of(context).clickOnTheFoodToGetMoreDetailsAboutIt,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        );
                      case 'recent_items':
                        return ItemsCarouselWidget(
                            itemsList: _con.recentItems,
                            heroTag: 'home_recent_items');
                      case 'recommended_restaurants_heading':
                        return userRepo.currentUser.value.apiToken == null ||
                                _con.recommendedRestaurants.isEmpty
                            ? SizedBox(height: 0)
                            : Padding(
                                padding: const EdgeInsets.only(
                                    top: 15, left: 20, right: 20, bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            S
                                                .of(context)
                                                .recommended_restaurants,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                            maxLines: 1,
                                            softWrap: false,
                                            overflow: TextOverflow.fade,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                      case 'recommended_restaurants':
                        return userRepo.currentUser.value.apiToken == null ||
                                _con.recommendedRestaurants.isEmpty
                            ? SizedBox(height: 0)
                            : CardsCarouselWidget(
                                restaurantsList: _con.recommendedRestaurants,
                                heroTag: 'home_recommended_restaurants');
                      default:
                        return SizedBox(height: 0);
                    }
                  })
                : [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Statistics about today",
                          style: Theme.of(context).textTheme.headline3,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Revenue",
                              style: Theme.of(context).textTheme.headline4,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "${_con.revenue}",
                              style: Theme.of(context).textTheme.headline4,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          Expanded(flex: 1, child: SizedBox(width: 0)),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Orders Count",
                              style: Theme.of(context).textTheme.headline4,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "${_con.count_orders}",
                              style: Theme.of(context).textTheme.headline4,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          Expanded(flex: 1, child: SizedBox(width: 0)),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Most ordered items",
                            style: Theme.of(context).textTheme.headline4,
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "item",
                                  style: Theme.of(context).textTheme.subtitle2,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "count",
                                  style: Theme.of(context).textTheme.subtitle2,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              Expanded(flex: 1, child: SizedBox(width: 0)),
                            ],
                          ),
                          SizedBox(height: 10),
                          ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: _con.topItems.length,
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 8);
                            },
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _con.topItems.elementAt(index).name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Text(
                                      _con.topItems
                                          .elementAt(index)
                                          .count_orders,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                    flex: 1,
                                  ),
                                  Expanded(flex: 1, child: SizedBox(width: 0)),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Most crowded hours",
                            style: Theme.of(context).textTheme.headline4,
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "hour",
                                  style: Theme.of(context).textTheme.subtitle2,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "orders",
                                  style: Theme.of(context).textTheme.subtitle2,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              Expanded(flex: 1, child: SizedBox(width: 0)),
                            ],
                          ),
                          SizedBox(height: 10),
                          ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: _con.topHours.length,
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 8);
                            },
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _con.topHours.elementAt(index).hour,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Text(
                                      _con.topHours
                                          .elementAt(index)
                                          .hourly_orders,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                    flex: 1,
                                  ),
                                  Expanded(flex: 1, child: SizedBox(width: 0)),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Your Restaurant QR code",
                          style: Theme.of(context).textTheme.headline3,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: Image.network(
                        '${GlobalConfiguration().getValue('api_base_url')}'
                        'restaurants/qr/${userRepo.currentUser.value.restaurant_id}',
                        height: 250,
                        width: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace stackTrace) {
                          return Icon(Icons.error);
                        },
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
