import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class FeaturedProductView extends StatelessWidget {
  final ScrollController? scrollController;
  final bool isHome;

  const FeaturedProductView(
      {super.key, this.scrollController, required this.isHome});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product>? productList;
        productList = prodProvider.featuredProductList;
        return Stack(
          children: [
            Column(children: [
              productList != null
                  ? productList.isNotEmpty
                      ? isHome
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: Dimensions.paddingSizeDefault),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: MediaQuery.of(context).size.width,
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.50,
                                ),
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) =>
                                        ProductWidget(
                                          productModel: productList![index],
                                        ),
                                    itemCount: 6,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2)),
                              ),
                            )
                          : MasonryGridView.count(
                              itemCount: productList.length,
                              crossAxisCount: 2,
                              padding: const EdgeInsets.all(0),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return ProductWidget(
                                    productModel: productList![index]);
                              },
                            )
                      : const SizedBox.shrink()
                  : ProductShimmer(
                      isHomePage: true,
                      isEnabled: prodProvider.firstFeaturedLoading),
              prodProvider.isFeaturedLoading
                  ? Center(
                      child: Padding(
                      padding:
                          const EdgeInsets.all(Dimensions.iconSizeExtraSmall),
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor)),
                    ))
                  : const SizedBox.shrink(),
            ]),
            // Positioned(
            //   bottom: 0,
            //   right: 20,
            //   child: Align(
            //     alignment: Alignment.bottomRight,
            //     child: LinearPercentIndicator(
            //       padding: EdgeInsets.zero,
            //       barRadius:
            //           const Radius.circular(Dimensions.paddingSizeDefault),
            //       width: 80,
            //       lineHeight: 4.0,
            //       percent: prodProvider.featuredIndex / productList!.length,
            //       backgroundColor:
            //           Provider.of<ThemeProvider>(context, listen: false)
            //                   .darkTheme
            //               ? Theme.of(context).primaryColor.withOpacity(.5)
            //               : Theme.of(context).primaryColor.withOpacity(.2),
            //       progressColor:
            //           (Provider.of<ThemeProvider>(context, listen: false)
            //                   .darkTheme)
            //               ? Theme.of(context).colorScheme.onSecondary
            //               : Theme.of(context).primaryColor,
            //     ),
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
