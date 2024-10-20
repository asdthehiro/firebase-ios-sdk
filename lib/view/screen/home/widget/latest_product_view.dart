import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/shimmer/latest_product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/widget/latest_products_view/latest_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/view_all_product_screen.dart';
import 'package:provider/provider.dart';

class LatestProductView extends StatelessWidget {
  const LatestProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product>? productList;
        productList = prodProvider.lProductList;

        return productList != null
            ? productList.isNotEmpty
                ? Column(
                    children: [
                      TitleRow(
                          title: getTranslated('latest_products', context),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AllProductScreen(
                                      productType:
                                          ProductType.latestProduct)))),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: Dimensions.paddingSizeDefault),
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.50,
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: productList.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 200,
                                  height: 150,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: LatestProductWidget(
                                        productModel: productList![index]),
                                  ),
                                );
                              },
                            )),
                      )
                    ],
                  )
                : const SizedBox.shrink()
            : const LatestProductShimmer();
      },
    );
  }
}
