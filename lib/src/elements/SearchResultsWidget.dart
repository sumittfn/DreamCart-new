import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/search_controller.dart';
import '../elements/CardWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/FoodItemWidget.dart';
import '../models/route_argument.dart';
import 'categorycardwidget.dart';

class SearchResultWidget extends StatefulWidget {
  final String heroTag;
  final String city_id;

  SearchResultWidget({Key key, this.heroTag, this.city_id}) : super(key: key);

  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends StateMVC<SearchResultWidget> {
  SearchController _con;
 TextEditingController textcontroller = new TextEditingController();
  _SearchResultWidgetState() : super(SearchController()) {
    _con = controller;
  }

  @override
  void initState() {
print("City ID:>>>> " + widget.city_id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              trailing: IconButton(
                icon: Icon(Icons.close),
                color: Theme.of(context).hintColor,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                S.of(context).search,
                style: Theme.of(context).textTheme.display1,
              ),
              // subtitle: Text(
              //   S.of(context).ordered_by_nearby_first,
              //   style: Theme.of(context).textTheme.caption,
              // ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              onSubmitted: (text) async {
                await _con.refreshSearch(text);
                // _con.saveSearch(text);
              },
              onChanged: (text)async{
                await _con.refreshSearch(text);
              },
             controller: textcontroller,
              autofocus: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12),
                hintText: S.of(context).search_for_restaurants_or_foods,
                hintStyle: Theme.of(context)
                    .textTheme
                    .caption
                    .merge(TextStyle(fontSize: 14)),
                prefixIcon:
                    Icon(Icons.search, color: Theme.of(context).accentColor),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).focusColor.withOpacity(0.1))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).focusColor.withOpacity(0.3))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).focusColor.withOpacity(0.1))),
              ),
            ),
          ),
          _con.restaurants.isEmpty && _con.foods.isEmpty
              ? CircularLoadingWidget(height: 288)
              : Container(
            height: MediaQuery.of(context).size.height - 200,
                child: ListView(
                  shrinkWrap: true,
                  addAutomaticKeepAlives: true,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        title: Text(
                          S.of(context).foods_results,
                          style: Theme.of(context).textTheme.subhead,
                        ),
                        subtitle: Text(""),
                      ),
                    ),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _con.foods.length,
                      // separatorBuilder: (context, index) {
                      //   return SizedBox(height: 10);
                      // },
                      itemBuilder: (context, index) {
                        return FoodItemWidget(
                          heroTag: 'search_list',
                          food: _con.foods.elementAt(index),
                          city_id: widget.city_id,
                        );
                      },
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        title: Text(
                          S.of(context).restaurants_results,
                          style: Theme.of(context).textTheme.subhead,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _con.restaurants.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/Details',
                                arguments: RouteArgument(
                                  id: _con.restaurants.elementAt(index).id,
                                  heroTag: widget.heroTag,
                                  city_id: widget.city_id
                                ));
                          },
                          child: CategoryCardWidget(
                              restaurant: _con.restaurants.elementAt(index),
                              heroTag: widget.heroTag),
                        );
                      },
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
