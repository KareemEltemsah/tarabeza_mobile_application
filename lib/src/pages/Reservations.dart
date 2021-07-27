import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../controllers/reservation_controller.dart';
import '../elements/EmptyReservationsWidget.dart';
import '../elements/ReservationItemWidget.dart';
import '../elements/PermissionDeniedWidget.dart';
import '../repository/user_repository.dart';

class ReservationsWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  ReservationsWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _ReservationsWidgetState createState() => _ReservationsWidgetState();
}

class _ReservationsWidgetState extends StateMVC<ReservationsWidget> {
  ReservationController _con;

  _ReservationsWidgetState() : super(ReservationController()) {
    _con = controller;
  }

  @override
  void initState() {
    currentUser.value.apiToken != null
        ? currentUser.value.role == "staff" ||
                currentUser.value.role == "restaurant_manager"
            ? _con.getRestaurantReservations()
            : _con.getUserReservations()
        : null;
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
          currentUser?.value?.role == "staff" ||
                  currentUser?.value?.role == "restaurant_manager"
              ? "Reservations"
              : S.of(context).my_reservations,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: currentUser.value.apiToken == null
          ? PermissionDeniedWidget()
          : _con.reservations.isEmpty
              ? EmptyReservationsWidget()
              : RefreshIndicator(
                  onRefresh: currentUser.value.role == "staff"
                      ? _con.getRestaurantReservations
                      : _con.getUserReservations,
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
                          itemCount: _con.reservations.length,
                          itemBuilder: (context, index) {
                            var _reservation =
                                _con.reservations.elementAt(index);
                            return ReservationItemWidget(
                                reservation: _reservation);
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
  }
}
