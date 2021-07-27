import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final User user;

  ProfileAvatarWidget({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(300)),
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    size: 70,
                  ),
                ),
              ],
            ),
          ),
          Text(
            user.fullName(),
            style: Theme.of(context)
                .textTheme
                .headline5
                .merge(TextStyle(color: Theme.of(context).primaryColor)),
          ),
          Text(
            user.role == "restaurant_manager"
                ? "restaurant manager"
                : user.role,
            style: Theme.of(context)
                .textTheme
                .caption
                .merge(TextStyle(color: Theme.of(context).primaryColor)),
          ),
        ],
      ),
    );
  }
}
