import 'package:Dreamcart/src/controllers/restaurant_controller.dart';
import 'package:flutter/material.dart';
import 'package:Dreamcart/src/models/route_argument.dart';
import 'package:Dreamcart/src/repository/user_repository.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/i18n.dart';
import '../helpers/checkbox_form_field.dart';
import '../models/address.dart';

// ignore: must_be_immutable
class EnquireDialog {
  final RestaurantController con;
  BuildContext context;
  final RouteArgument routeArgument;
  String description;
  String name;
  String mobile;
  GlobalKey<FormState> _enquiryFormKey = new GlobalKey<FormState>();
  TextEditingController descriptionController = new TextEditingController();

  EnquireDialog({
    this.con,
    this.context,
    this.routeArgument,
    this.description,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            titlePadding: EdgeInsets.fromLTRB(16, 25, 16, 0),
            title: Row(
              children: <Widget>[
                Text(
                  S.of(context).enquiry,
                  style: Theme.of(context).textTheme.body2,
                )
              ],
            ),
            children: <Widget>[
              Form(
                key: _enquiryFormKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                            hintText: S.of(context).hint_name,
                            labelText: S.of(context).full_name),
                        initialValue:
                            currentUser.value.name?.isNotEmpty ?? false
                                ? currentUser.value.name
                                : null,
                        validator: (input) => input.trim().length == 0
                            ? 'Not valid  description'
                            : null,
                        onSaved: (input) => name = input,
                        readOnly: true,
                        enabled: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                            hintText: S.of(context).mobile,
                            labelText: S.of(context).mobile_no),
                        initialValue: currentUser.value.phone != null
                            ? currentUser.value.phone
                            : null,
                        validator: (input) => input.trim().length == 0
                            ? 'Not valid mobile number'
                            : null,
                        onSaved: (input) {
                          mobile = input;
                        },
                        readOnly: true,
                        enabled: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        maxLines: 2,
                        maxLength: 225,
                        inputFormatters: [LengthLimitingTextInputFormatter(225),],
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        controller: descriptionController,
                        decoration: getInputDecoration(
                            hintText: S.of(context).food_description,
                            labelText: S.of(context).description),
                        validator: (input) => input.trim().length == 0
                            ? 'Not valid description'
                            : null,
                        onSaved: (input) {
                          description = input;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      S.of(context).cancel,
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ),
                  MaterialButton(
                    onPressed: _submit,
                    child: Text(
                      S.of(context).save,
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
              SizedBox(height: 10),
            ],
          );
        });
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.body1.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      hasFloatingPlaceholder: true,
      labelStyle: Theme.of(context).textTheme.body1.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit() {
    print("Description::::::::::::::::>>>>>>>>>>>>>> " +
        descriptionController.text);
    if (_enquiryFormKey.currentState.validate()) {
      print("Name::::::::::::::::>>>>>>>>>>>>>> " + currentUser.value.name);
      print("mobile::::::::::::::::>>>>>>>>>>>>>> " + currentUser.value.phone);
      print("RTestaurant ID::::::::::::::::>>>>>>>>>>>>>> " + routeArgument.id);
      print("user ID::::::::::::::::>>>>>>>>>>>>>> " + currentUser.value.id);
      descriptionController.text.isNotEmpty
          ? con.enquryNow(
              user_id: currentUser.value.id,
              restaurant_id: routeArgument.id,
              mobile: currentUser.value.phone,
              description: descriptionController.text,
              username: currentUser.value.name,
            )
          : null;

      FlutterToast(context).showToast(
          child: Container(
            height: 30.0,
              width: 200.0,
              color: Colors.black,
              child: Center(
                child: Text(
                  "Enquiry submitted Successfully",
                  style: TextStyle(color: Colors.white),
                ),
              )),
          gravity: ToastGravity.BOTTOM,
          toastDuration: Duration(seconds: 5));

      Navigator.pop(context);
    }
  }
}
