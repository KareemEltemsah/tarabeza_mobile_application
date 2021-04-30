import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as repository;

import '../../generated/l10n.dart';

class ProfileController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  User user = new User();

  ProfileController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void update() async {
    // repository.update(user).then((value) {
    //   setState(() {});
    //   scaffoldKey?.currentState?.showSnackBar(SnackBar(
    //     content: Text(S.of(context).profile_settings_updated_successfully),
    //   ));
    // });
  }

  Future<void> refreshProfile() async {}
}
