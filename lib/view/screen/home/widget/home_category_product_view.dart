import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/home_category_product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/brand_and_category_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/product_details_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class HomeCategoryProductView extends StatelessWidget {
  final bool isHomePage;
  const HomeCategoryProductView({super.key, required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeCategoryProductProvider>(
      builder: (context, homeCategoryProductProvider, child) {
        return homeCategoryProductProvider.homeCategoryProductList.isNotEmpty
            ? ListView.builder(
                itemCount:
                    homeCategoryProductProvider.homeCategoryProductList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index) {
                  return Container(
                    color: index.isEven
                        ? Theme.of(context).primaryColor.withOpacity(.125)
                        : Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isHomePage
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0,
                                    Dimensions.paddingSizeDefault,
                                    0,
                                    Dimensions.paddingSizeDefault),
                                child: TitleRow(
                                    title: homeCategoryProductProvider
                                        .homeCategoryProductList[index].name,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => BrandAndCategoryProductScreen(
                                                  isBrand: false,
                                                  id: homeCategoryProductProvider
                                                      .homeCategoryProductList[
                                                          index]
                                                      .id
                                                      .toString(),
                                                  name: homeCategoryProductProvider
                                                      .homeCategoryProductList[
                                                          index]
                                                      .name)));
                                    }),
                              )
                            : const SizedBox(),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width,
                          
                          ),
                          child: GridView.builder(
                            itemCount: (isHomePage &&
                                    homeCategoryProductProvider
                                            .homeCategoryProductList[index]
                                            .products!
                                            .length >
                                        4)
                                ? 4
                                : homeCategoryProductProvider
                                    .homeCategoryProductList[index]
                                    .products!
                                    .length,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int i) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(milliseconds: 1000),
                                        pageBuilder: (context, anim1, anim2) =>
                                            ProductDetails(
                                          productId: homeCategoryProductProvider
                                              .productList![i].id,
                                          slug: homeCategoryProductProvider
                                              .productList![i].slug,
                                        ),
                                      ));
                                },
                                child: ProductWidget(
                                    productModel: homeCategoryProductProvider
                                        .homeCategoryProductList[index]
                                        .products![i]),
                              );
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,childAspectRatio: 0.90),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                      ],
                    ),
                  );
                })
            : const SizedBox();
      },
    );
  }
}
