import 'package:Dreamcart/src/elements/citybottommodelsheet.dart';
import 'package:Dreamcart/src/models/cities.dart';
import 'package:flutter/material.dart';
import 'package:Dreamcart/src/models/route_argument.dart';
import 'package:Dreamcart/src/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/address.dart' as model;
import '../../generated/i18n.dart';
import '../helpers/checkbox_form_field.dart';
import '../models/address.dart';

// ignore: must_be_immutable
class DeliveryAddressDialog extends StatefulWidget {
  BuildContext context;
  Address address;
  String useraddress;
  ValueChanged<Address> onChanged;
  final RouteArgument routeArgument;
  List<dynamic> listAddress = [];
  String cityName;
  String city_id;
  List<Data> cityData;

  DeliveryAddressDialog(
      {this.context,
      this.address,
      this.onChanged,
      this.routeArgument,
      this.listAddress,
      this.cityData,
      this.city_id,
      this.cityName,
      this.useraddress});

  @override
  _DeliveryAddressDialogState createState() => _DeliveryAddressDialogState();
}

class _DeliveryAddressDialogState extends State<DeliveryAddressDialog> {
  String id;

  bool exist = false;

  TextEditingController textEditingController = TextEditingController();

  GlobalKey<FormState> _deliveryAddressFormKey = new GlobalKey<FormState>();

  void initState() {
    // cityName = "Khamgaon";
    // city_id = "13";
    textEditingController.text = widget.useraddress;
    print("Current User Address ;;;;;;;;;>>>>>>> " + currentUser.value.address);
  }

  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, state) {
        return SimpleDialog(
          titlePadding: EdgeInsets.fromLTRB(16, 25, 16, 0),
          title: Row(
            children: <Widget>[
              Icon(
                Icons.place,
                color: Theme.of(context).hintColor,
              ),
              SizedBox(width: 10),
              Text(
                S.of(context).add_delivery_address,
                style: Theme.of(context).textTheme.body2,
              )
            ],
          ),
          children: <Widget>[
            Form(
              key: _deliveryAddressFormKey,
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
                      initialValue: currentUser.value.name?.isNotEmpty ?? false
                          ? currentUser.value.name
                          : null,
                      validator: (input) => input.trim().length == 0
                          ? 'Not valid address description'
                          : null,
                      onSaved: (input) => currentUser.value.name = input,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: new TextFormField(
                      controller: textEditingController,
                      style: TextStyle(color: Theme.of(context).hintColor),
                      keyboardType: TextInputType.text,
                      decoration: getInputDecoration(
                          hintText: S.of(context).hint_full_address,
                          labelText: S.of(context).full_address),
                      // initialValue:
                      //     widget.useraddress == null || widget.useraddress == ""
                      //         ? ""
                      //         : widget.useraddress,
                      validator: (input) =>
                          input.trim().length == 0 || exist == true
                              ? 'Already exists'
                              : null,
                      onSaved: (input) {
                        widget.address.address = input;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 18.0),
                        child: Text(
                          "City",
                          style: TextStyle(color: Theme.of(context).hintColor),
                          textAlign: TextAlign.left,
                        ),
                      )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 18.0, top: 4.0, bottom: 4.0),
                        child: Text(
                          widget.cityName,
                          style: Theme.of(context).textTheme.body2,
                          textAlign: TextAlign.left,
                        ),
                      )),
                  // InkWell(
                  //   onTap: () {
                  //     _setRoleBottomSheet();
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(15.0),
                  //     child: Container(
                  //       width: double.infinity,
                  //       height: 32.0,
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           Align(
                  //               alignment: Alignment.centerLeft,
                  //               child: Padding(
                  //                 padding: const EdgeInsets.all(6.0),
                  //                 child: Text(
                  //                   widget.cityName,
                  //                   style: TextStyle(fontSize: 14.0),
                  //                   textAlign: TextAlign.left,
                  //                 ),
                  //               )),
                  //           Icon(
                  //             Icons.arrow_drop_down_sharp,
                  //             size: 15.0,
                  //           )
                  //         ],
                  //       ),
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(8.0),
                  //           border: Border.all(color: Colors.black26)),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    width: double.infinity,
                    child: CheckboxFormField(
                      context: context,
                      initialValue: false,
                      onSaved: (input) async {
                        widget.address.isDefault = input;
                      },
                      title: Text('Make it default'),
                    ),
                  )
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
      },
    );
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(widget.context).textTheme.body1.merge(
            TextStyle(color: Theme.of(widget.context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(widget.context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(widget.context).hintColor)),
      hasFloatingPlaceholder: true,
      labelStyle: Theme.of(widget.context).textTheme.body1.merge(
            TextStyle(color: Theme.of(widget.context).hintColor),
          ),
    );
  }

  void checkExist() {
    textEditingController.addListener(() {
      if (widget.listAddress.every((element) =>
          element.address.toString() != textEditingController.text)) {
        exist = false;
      } else {
        exist = true;
      }
    });
  }

  void _submit() {
    if (_deliveryAddressFormKey.currentState.validate()) {
      checkExist();
      exist == false ? _deliveryAddressFormKey.currentState.save() : null;
      exist == false ? widget.onChanged(widget.address) : null;
      widget.address.address = textEditingController.text;
      exist == false
          ? Navigator.of(widget.context)
              .pushNamed(
                '/PaymentMethod',
                arguments: RouteArgument(
                  id: widget.routeArgument.id,
                  amount: widget.routeArgument.amount,
                  address: widget.address,
                  city_id: widget.routeArgument.city_id,
                  discount: widget.routeArgument.discount,
                  promocode: widget.routeArgument.promocode,
                ),
              )
              .then((value) => Navigator.of(widget.context).pop())
          : null;
    } else {
      // Navigator.pop(context);
    }
  }

  // void _setRoleBottomSheet() {
  //   showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: widget.context,
  //       builder: (context) {
  //         return SingleChildScrollView(
  //           padding: EdgeInsets.only(
  //               bottom: MediaQuery.of(context).viewInsets.bottom),
  //           child: Container(
  //             height: 200.0,
  //             child: ModalBottomSheet(
  //               city: widget.cityData,
  //               setCompany: selectedCity,
  //             ),
  //           ),
  //         );
  //       });
  // }

  // void selectedCity(Data city) {
  //   setState(() {});
  //   cityName = city.name;
  //   city_id = city.id.toString();
  //   // _con.serviceStatus(city.id.toString());
  // }
}
