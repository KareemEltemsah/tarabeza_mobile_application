import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

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
          new IconButton(
            icon: new Icon(Icons.search, color: Theme.of(context).hintColor),
            onPressed: () => Navigator.of(context).push(SearchModal()),
          ),
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
            children: List.generate(
                settingsRepo.setting.value.homeSections.length, (index) {
              String _homeSection =
                  settingsRepo.setting.value.homeSections.elementAt(index);
              switch (_homeSection) {
                case 'recent_restaurants_heading':
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: 20, right: 20, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                S.of(context).recent_restaurants,
                                style: Theme.of(context).textTheme.headline4,
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
                  return userRepo.currentUser.value.apiToken == null
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
                                      S.of(context).recommended_restaurants,
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
                case 'recommended_restaurants':
                  return userRepo.currentUser.value.apiToken == null
                      ? SizedBox(height: 0)
                      : CardsCarouselWidget(
                      restaurantsList: _con.recommendedRestaurants,
                      heroTag: 'home_recommended_restaurants');
                default:
                  return SizedBox(height: 0);
              }
            }),
          ),
        ),
      ),
    );
  }
}
