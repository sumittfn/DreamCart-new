import 'package:Dreamcart/src/models/cities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/category.dart';
import '../models/route_argument.dart';

// ignore: must_be_immutable
class CategoriesCarouselItemWidget extends StatelessWidget {
  double marginLeft;
  Category category;
  String city_id;
  List<Data> cityData;
  String city;

  CategoriesCarouselItemWidget(
      {Key key, this.marginLeft, this.category, this.city_id, this.cityData, this.city})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("City Cart :::::::::::>>>> " + city);
    return InkWell(
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).pushNamed('/Category',
            arguments: RouteArgument(
                id: category.id, city_id: city_id, cityData: cityData,city: city));
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).focusColor.withOpacity(0.05),
                    offset: Offset(0, 5),
                    blurRadius: 5)
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: category.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0)),
                  child: Container(
                    // margin:
                    //     EdgeInsetsDirectional.only(start: this.marginLeft, end: 20,),
                    // width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                              color:
                                  Theme.of(context).focusColor.withOpacity(0.2),
                              offset: Offset(0, 2),
                              blurRadius: 7.0)
                        ]),
                    child: category.image.url.toLowerCase().endsWith('.svg')
                        ? Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SvgPicture.network(
                              category.image.url,
                              color: Theme.of(context).accentColor,
                            ),
                          )
                        : Image.network(
                            category.image.url,
                            height: 120.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                // margin: EdgeInsetsDirectional.only(start: this.marginLeft, end: 20,),
                child: Text(
                  category.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
