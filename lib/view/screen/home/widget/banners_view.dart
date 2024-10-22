import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/banner_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_image.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_slider/carousel_options.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_slider/custom_slider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class BannersView extends StatelessWidget {
  const BannersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<BannerProvider>(
          builder: (context, bannerProvider, child) {
            double width = MediaQuery.of(context).size.width;
            return Stack(
              children: [
                bannerProvider.mainBannerList != null
                    ? bannerProvider.mainBannerList!.isNotEmpty
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.18,
                            width: width,
                            child: Column(
                              children: [
                                SizedBox(
                                  height:  MediaQuery.of(context).size.height * 0.15,
                                  width: width,
                                  child: CarouselSlider.builder(
                                    options: CarouselOptions(
                                      aspectRatio: 4 / 1,
                                      viewportFraction: 0.9,
                                      autoPlay: true,
                                      enlargeFactor: .1,
                                      enlargeCenterPage: true,
                                      disableCenter: true,
                                      onPageChanged: (index, reason) {
                                        Provider.of<BannerProvider>(context,
                                                listen: false)
                                            .setCurrentIndex(index);
                                      },
                                    ),
                                    itemCount: bannerProvider
                                            .mainBannerList!.isEmpty
                                        ? 1
                                        : bannerProvider.mainBannerList!.length,
                                    itemBuilder: (context, index, _) {
                                      return InkWell(
                                        onTap: () {
                                          bannerProvider.clickBannerRedirect(
                                              context,
                                              bannerProvider
                                                  .mainBannerList![index]
                                                  .resourceId,
                                              bannerProvider
                                                          .mainBannerList![
                                                              index]
                                                          .resourceType ==
                                                      'product'
                                                  ? bannerProvider
                                                      .mainBannerList![index]
                                                      .product
                                                  : null,
                                              bannerProvider
                                                  .mainBannerList![index]
                                                  .resourceType);
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.paddingSizeSmall),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(Dimensions
                                                          .paddingSizeSmall),
                                                  color:
                                                      Provider.of<ThemeProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .darkTheme
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                              .withOpacity(.1)
                                                          : Theme.of(context)
                                                              .primaryColor
                                                              .withOpacity(
                                                                  .05)),
                                              child: CustomImage(
                                                  height: 100,
                                                  image:
                                                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}'
                                                      '/${bannerProvider.mainBannerList![index].photo}')),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox()
                    : SizedBox(
                        height: width * 0.39,
                        width: width,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          enabled: bannerProvider.mainBannerList == null,
                          child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ColorResources.white,
                              )),
                        ),
                      ),
                Container(
                  height: 7,
                  width: 7,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
                if (bannerProvider.mainBannerList != null &&
                    bannerProvider.mainBannerList!.isNotEmpty)
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: bannerProvider.mainBannerList!.map((banner) {
                        int index =
                            bannerProvider.mainBannerList!.indexOf(banner);
                        return index == bannerProvider.currentIndex
                            ? Container(
                                height: 7,
                                width: 7,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              )
                            : Container(
                                height: 7,
                                width: 7,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                              );
                      }).toList(),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
