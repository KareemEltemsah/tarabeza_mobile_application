import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';

class ProfileController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

  ProfileController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Future<void> refreshProfile() async {}
}
