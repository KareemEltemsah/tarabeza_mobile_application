import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import '../elements/DrawerWidget.dart';
import '../elements/PermissionDeniedWidget.dart';
import '../elements/ProfileAvatarWidget.dart';
import '../repository/user_repository.dart' as userRepo;
import '../elements/ProfileSettingsDialog.dart';

class ProfileWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  ProfileWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends StateMVC<ProfileWidget> {
  UserController _con;

  _ProfileWidgetState() : super(UserController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).primaryColor),
          onPressed: () => _con.scaffoldKey?.currentState?.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).profile,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(
              letterSpacing: 1.3, color: Theme.of(context).primaryColor)),
        ),
      ),
      body: userRepo.currentUser.value.apiToken == null
          ? PermissionDeniedWidget()
          : ValueListenableBuilder(
              valueListenable: userRepo.currentUser,
              builder: (BuildContext context, value, Widget child) {
                return SingleChildScrollView(
//              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: Column(
                    children: <Widget>[
                      ProfileAvatarWidget(user: userRepo.currentUser.value),
                      SizedBox(height: 10),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.15),
                                offset: Offset(0, 3),
                                blurRadius: 10)
                          ],
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          primary: false,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                S.of(context).profile_settings,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              trailing: ButtonTheme(
                                padding: EdgeInsets.all(0),
                                minWidth: 50.0,
                                height: 25.0,
                                child: ProfileSettingsDialog(
                                  user: _con.user,
                                  onChanged: () {
                                    _con.update();
                                  },
                                ),
                              ),
                            ),
                            ListTile(
                              dense: true,
                              title: Text(
                                S.of(context).full_name,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              trailing: Text(
                                userRepo.currentUser.value.fullName(),
                                style: TextStyle(
                                    color: Theme.of(context).focusColor),
                              ),
                            ),
                            ListTile(
                              dense: true,
                              title: Text(
                                S.of(context).email,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              trailing: Text(
                                userRepo.currentUser.value.email,
                                style: TextStyle(
                                    color: Theme.of(context).focusColor),
                              ),
                            ),
                            ListTile(
                              dense: true,
                              title: Text(
                                S.of(context).phone,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              trailing: Text(
                                userRepo.currentUser.value.phone,
                                style: TextStyle(
                                    color: Theme.of(context).focusColor),
                              ),
                            ),
                            userRepo.currentUser.value.role == "customer"
                                ? ListTile(
                                    dense: true,
                                    title: Text(
                                      S.of(context).address,
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                    trailing: Text(
                                      userRepo.currentUser.value.address,
                                      style: TextStyle(
                                          color: Theme.of(context).focusColor),
                                    ),
                                  )
                                : SizedBox(),
                            ListTile(
                              dense: true,
                              title: Text(
                                S.of(context).DOB,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              trailing: Text(
                                userRepo.currentUser.value.DOB,
                                style: TextStyle(
                                    color: Theme.of(context).focusColor),
                              ),
                            ),
                            ListTile(
                              dense: true,
                              title: Text(
                                S.of(context).gender,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              trailing: Text(
                                userRepo.currentUser.value.gender,
                                style: TextStyle(
                                    color: Theme.of(context).focusColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
