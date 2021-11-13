import 'package:flutter/material.dart';

import '../elements/CardsCarouselLoaderWidget.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';
import 'CardWidget.dart';

// ignore: must_be_immutable
class CardsCarouselWidget extends StatefulWidget {
  List<Restaurant> restaurantsList;
  String city;
  String heroTag;

  CardsCarouselWidget({Key key, this.restaurantsList, this.heroTag, this.city})
      : super(key: key);

  @override
  _CardsCarouselWidgetState createState() => _CardsCarouselWidgetState();
}

class _CardsCarouselWidgetState extends State<CardsCarouselWidget> {
  @override
  void initState() {
    print("Store List : - " + widget.restaurantsList.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.restaurantsList.isEmpty
        ? CardsCarouselLoaderWidget()
        : Container(
            height: 320.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.restaurantsList == null
                  ? 0
                  : widget.restaurantsList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Details',
                        arguments: RouteArgument(
                          id: widget.restaurantsList.elementAt(index).id,
                          city: widget.city,
                          heroTag: 'home_restaurants',
                        )
                    );
                  },
                  child: CardWidget(
                      restaurant: widget.restaurantsList == null
                          ? null
                          : widget.restaurantsList.elementAt(index),
                      heroTag: widget.heroTag),
                );
              },
            ),
          );
  }
}
