import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import '../repository/user_repository.dart';

import '../../generated/l10n.dart';
import '../models/user.dart';

class ProfileSettingsDialog extends StatefulWidget {
  final User user;
  final VoidCallback onChanged;

  ProfileSettingsDialog({Key key, this.user, this.onChanged}) : super(key: key);

  @override
  _ProfileSettingsDialogState createState() => _ProfileSettingsDialogState();
}

class _ProfileSettingsDialogState extends State<ProfileSettingsDialog> {
  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();
  TextEditingController _DOBController;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
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
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text(
                      S.of(context).profile_settings,
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _profileSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              labelText: S.of(context).first_name),
                          initialValue: currentUser.value.first_name,
                          validator: (input) => input.length < 3
                              ? S.of(context).should_be_at_least_3_letters
                              : null,
                          onSaved: (input) => widget.user.first_name = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              labelText: S.of(context).last_name),
                          initialValue: currentUser.value.last_name,
                          validator: (input) => input.length < 3
                              ? S.of(context).should_be_at_least_3_letters
                              : null,
                          onSaved: (input) => widget.user.last_name = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.emailAddress,
                          decoration: getInputDecoration(
                              labelText: S.of(context).email_address),
                          initialValue: currentUser.value.email,
                          validator: (input) => !input.contains('@')
                              ? S.of(context).should_be_a_valid_email
                              : null,
                          onSaved: (input) => widget.user.email = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.phone,
                          decoration: getInputDecoration(
                              labelText: S.of(context).phone),
                          initialValue: currentUser.value.phone,
                          validator: (input) =>
                              input.length < 11 || input.substring(0, 2) != "01"
                                  ? S.of(context).not_a_valid_phone
                                  : null,
                          onSaved: (input) => widget.user.phone = input,
                        ),
                        new TextFormField(
                          onSaved: (input) => widget.user.DOB = input,
                          validator: (input) => input.length == 0
                              ? S.of(context).not_a_valid_date
                              : null,
                          controller: _DOBController,
                          initialValue: currentUser.value.DOB,
                          onTap: () async {
                            // Below line stops keyboard from appearing
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            // Show Date Picker Here
                            await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1940),
                              lastDate: DateTime.now(),
                            ).then((value) => _DOBController.text =
                                DateFormat('yyyy-MM-dd').format(value));
                          },
                          decoration: InputDecoration(
                            labelText: "Date of birth",
                          ),
                        ),
                        FormBuilderRadioGroup(
                          name: null,
                          onSaved: (value) => widget.user.gender = value,
                          validator: (value) =>
                              value == null ? 'you must choose gender' : null,
                          initialValue: currentUser.value.gender,
                          options: ["male", "female"]
                              .map((gender) => FormBuilderFieldOption(
                                    value: gender,
                                    child: Text('${gender}'),
                                  ))
                              .toList(growable: false),
                          decoration: InputDecoration(
                            labelText: "Gender",
                          ),
                        ),
                        SizedBox(height: 20),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              labelText: "${S.of(context).password} to Confirm"),
                          validator: (input) => input.length < 8
                              ? S.of(context).should_be_at_least_8_characters
                              : null,
                          onSaved: (input) => widget.user.password = input,
                        ),
                      ],
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
                        onPressed: _submit,
                        child: Text(
                          S.of(context).save,
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  SizedBox(height: 10),
                ],
              );
            });
      },
      child: Text(
        S.of(context).edit,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit() {
    if (_profileSettingsFormKey.currentState.validate()) {
      _profileSettingsFormKey.currentState.save();
      widget.onChanged();
      Navigator.pop(context);
    }
  }
}
