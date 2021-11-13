import 'package:Dreamcart/src/models/cities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../elements/CategoriesCarouselItemWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/category.dart';

// ignore: must_be_immutable
class CategoriesCarouselWidget extends StatelessWidget {
  List<Category> categories = <Category>[];
  String city_id;
  List<Data> cityData;
  List<Category> sortCategories =<Category>[];
  String city;
  CategoriesCarouselWidget(
      {Key key, this.categories, this.city_id, this.cityData, this.city})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Category re:::::::::::::>>>>>>>>>>>>>> " + categories.toString());
    for (int i = 0; i < categories.length; i++) {
      if (this.categories[i].type == "0") {
        sortCategories.add(categories[i]);
      }

    }
    return this.categories.isEmpty
        ? CircularLoadingWidget(height: 150)
        : new StaggeredGridView.countBuilder(
            primary: false,
            shrinkWrap: true,
            crossAxisCount: 4,
            itemCount: this.sortCategories.length,
            itemBuilder: (BuildContext context, int index) {
              return new CategoriesCarouselItemWidget(
                // marginLeft: _marginLeft,
                category: this.sortCategories.elementAt(index),
                city_id: city_id,
                cityData: cityData,
                city: city,
              );
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
