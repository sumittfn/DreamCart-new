import 'package:Dreamcart/src/models/cities.dart';
import 'package:flutter/material.dart';

class ModalBottomSheet extends StatefulWidget {
  final List<Data> city;

  final Function setCompany;

  const ModalBottomSheet({Key key, this.city, this.setCompany})
      : super(key: key);
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet>
    with SingleTickerProviderStateMixin {
  String filter = "";
  TextEditingController controller;
  Data selectedCity = null;
  var heightOfModalBottomSheet = 100.0;

  @override
  void initState() {
    controller = new TextEditingController();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFFF7F7F8),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0))),
                height: 50.0,
                alignment: Alignment.center,
                child: TextField(
                  onChanged: (String x) {
                    setState(() {
                      print(x);
                      filter = x;
                    });
                  },
                  autofocus: false,
                  style:TextStyle(
                      color: Color(0XFF7D7D7D),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Lato",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  decoration: InputDecoration(
                      hintText: "Search",
                      helperStyle:TextStyle(
                          color: Color(0XFF7D7D7D),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Lato",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 24.0)),
                  controller: controller,
                ),
              ),
              Flexible(
                flex: 1,
                child: _buildListView(),
              ),
            ],
          )),
    );
  }

  Widget _buildListView() {
    return Container(
      alignment: Alignment.center,
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: widget.city.length,
          itemBuilder: (BuildContext context, int index) {
            if (filter == null || filter == "") {
              return Column(
                children: <Widget>[
                  _buildRow(widget.city[index]),
                  Divider()
                ],
              );
            } else {
              if (widget.city[index].name
                  .toLowerCase()
                  .contains(filter.toLowerCase()) ||
                  widget.city[index].name[0]
                      .toString()
                      .contains(filter.toLowerCase())) {
                return _buildRow(widget.city[index]);
              } else {
                return new Container();
              }
            }
          }),
    );
  }

  Widget _buildRow(Data c) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCity = c;
          widget.setCompany(selectedCity);
          Navigator.of(context).pop();
        });
      },
      child: Container(
        width: double.infinity,
        height: 50.0,
        padding: EdgeInsets.only(left: 24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Container(
                width: 280.0,
                child: Text(
                  c.name.toString(),
                  style:
                  TextStyle(
                      color: Color(0XFF7D7D7D),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Lato",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0).copyWith(fontSize: 12.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}