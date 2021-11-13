import 'package:Dreamcart/src/elements/CategoriesListForRestaurantWidget.dart';
import 'package:Dreamcart/src/models/cities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../elements/CategoriesCarouselItemWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/category.dart';

// ignore: must_be_immutable
class RestaurantwiseCategoriesWidget extends StatelessWidget {
  List<Category> categories;
  String city_id;
  String restaurant_id;
  String city;

  RestaurantwiseCategoriesWidget({Key key, this.categories, this.city_id, this.restaurant_id, this.city})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("City Data NAme ::::::>> " + city);
    return this.categories.isEmpty
        ? CircularLoadingWidget(height: 150)
        : new StaggeredGridView.countBuilder(
      primary: false,
      shrinkWrap: true,
      crossAxisCount: 4,
      itemCount: this.categories.length,
      itemBuilder: (BuildContext context, int index) {
        if(this.categories.length !=0) {
          return new CategoriesListForRestaurantWidget(
            // marginLeft: _marginLeft,
            category: this.categories[index],
            city_id: city_id,
            restaurant_id: restaurant_id,
            city: city,
          );
        }else {
          Center(
            child: Center(
              child: Text(
                "No product category found",
                style:
                Theme.of(context).textTheme.display1,
              ),
            ),
          );
        }
      },
//                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(index % 2 == 0 ? 1 : 2),
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(
          MediaQuery.of(context).orientation == Orientation.portrait
              ? 2
              : 4),
      mainAxisSpacing: 15.0,
      crossAxisSpacing: 15.0,
    );

  }
}
