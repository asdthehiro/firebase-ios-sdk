import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/category.dart';
import 'package:flutter_sixvalley_ecommerce/provider/localization_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_image.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;
  final int index;
  final int length;
  const CategoryWidget(
      {super.key,
      required this.category,
      required this.index,
      required this.length});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: Provider.of<LocalizationProvider>(context, listen: false).isLtr
              ? Dimensions.homePagePadding
              : 0,
          right: index + 1 == length
              ? Dimensions.paddingSizeDefault
              : Provider.of<LocalizationProvider>(context, listen: false).isLtr
                  ? 0
                  : Dimensions.homePagePadding),
      child: Column(children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withOpacity(.25)),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          padding: EdgeInsets.all(5),
          child: CircleAvatar(
              backgroundColor: Colors.orange[300],
              radius: 50,
              child: CustomImage(
                image:
                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}'
                    '/${category.icon}',
                width: MediaQuery.of(context).size.width * 0.20,
                fit: BoxFit.contain,
              )),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        Center(
          child: SizedBox(
            width: 70,
            child: Text(category.name!,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: titilliumRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    fontWeight: FontWeight.w500,
                    color: ColorResources.getTextTitle(context))),
          ),
        ),
      ]),
    );
  }
}
