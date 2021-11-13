import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../generated/i18n.dart';
import '../helpers/helper.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';

// ignore: must_be_immutable
class CategoryCardWidget extends StatelessWidget {
  Restaurant restaurant;
  String heroTag;

  CategoryCardWidget({Key key, this.restaurant, this.heroTag})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("Image URL ::::::::::::::- " + restaurant.image.url);
    print("Distance ::::::::::- " + restaurant.distance.toString());

    return Container(
      width: 292,
      height: 280.0,
      margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.1),
              blurRadius: 15,
              offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Image of the card
          Hero(
            tag: this.heroTag + restaurant.id,
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Image.network(
                  restaurant.image.url,
                  height: 150.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: restaurant.closed
                                  ? Colors.grey
                                  : Colors.green,
                              borderRadius: BorderRadius.circular(24)),
                          child: restaurant.closed
                              ? Text(
                                  S.of(context).closed,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .merge(TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                )
                              : Text(
                                  S.of(context).open,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .merge(TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: Helper.canDelivery(restaurant)
                                  ? Colors.green
                                  : Color(0xff1f740f),
                              borderRadius: BorderRadius.circular(24)),
                          child: Helper.canDelivery(restaurant)
                              ? Text(
                                  S.of(context).delivery,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .merge(TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                )
                              : Text(
                                  S.of(context).pickup,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .merge(TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                ),
                        ),
                      ],
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(right:8.0),
                    //   child: Text(
                    //     restaurant.distance.toString() + "KM",
                    //     style: TextStyle(
                    //         color: Colors.black45,
                    //         fontSize: 14.0,
                    //         fontWeight: FontWeight.bold),
                    //   ),
                    // ),

                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            restaurant.name,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: Theme.of(context).textTheme.subhead,
                          ),
                          Text(
                            Helper.skipHtml(restaurant.description),
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: Helper.getStarsList(
                                double.parse(restaurant.rate)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 15),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
