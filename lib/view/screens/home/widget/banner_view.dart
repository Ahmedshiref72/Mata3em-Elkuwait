import 'package:carousel_slider/carousel_slider.dart';
import 'package:efood_multivendor/controller/banner_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/data/model/response/basic_campaign_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../base/title_widget.dart';

class BannerView extends StatelessWidget {
  const BannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(builder: (bannerController) {
      return (bannerController.bannerImageList != null &&
              bannerController.bannerImageList!.isEmpty)
          ? const SizedBox()
          : Container(
              width: MediaQuery.of(context).size.width,
              height: GetPlatform.isDesktop
                  ? 450
                  : MediaQuery.of(context).size.width * 0.52,
              padding:
                  const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
              child: bannerController.bannerImageList != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /*Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child:SizedBox() */ /*TitleWidget(title: 'Offers'.tr, onTap: () => Get.toNamed(RouteHelper.getCategoryRoute())),*/ /*
            ),*/
                        Expanded(
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              autoPlay: true,
                              enlargeCenterPage: true,
                              disableCenter: true,
                              autoPlayInterval: const Duration(seconds: 7),
                              onPageChanged: (index, reason) {
                                bannerController.setCurrentIndex(index, true);
                              },
                            ),
                            itemCount: bannerController.bannerImageList!.isEmpty
                                ? 1
                                : bannerController.bannerImageList!.length,
                            itemBuilder: (context, index, _) {
                              String? baseUrl =
                                  bannerController.bannerDataList![index]
                                          is BasicCampaignModel
                                      ? Get.find<SplashController>()
                                          .configModel!
                                          .baseUrls!
                                          .campaignImageUrl
                                      : Get.find<SplashController>()
                                          .configModel!
                                          .baseUrls!
                                          .bannerImageUrl;
                              return InkWell(
                                onTap: () {
                                  if (bannerController.bannerDataList![index]
                                      is Product) {
                                    Product? product =
                                        bannerController.bannerDataList![index];
                                    ResponsiveHelper.isMobile(context)
                                        ? showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (con) =>
                                                ProductBottomSheet(
                                                    product: product),
                                          )
                                        : showDialog(
                                            context: context,
                                            builder: (con) => Dialog(
                                                child: ProductBottomSheet(
                                                    product: product)),
                                          );
                                  } else if (bannerController
                                      .bannerDataList![index] is Restaurant) {
                                    Restaurant restaurant =
                                        bannerController.bannerDataList![index];
                                    Get.toNamed(
                                      RouteHelper.getRestaurantRoute(
                                          restaurant.id),
                                      arguments: RestaurantScreen(
                                          restaurant: restaurant),
                                    );
                                  } else if (bannerController
                                          .bannerDataList![index]
                                      is BasicCampaignModel) {
                                    BasicCampaignModel campaign =
                                        bannerController.bannerDataList![index];
                                    Get.toNamed(
                                        RouteHelper.getBasicCampaignRoute(
                                            campaign));
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[
                                              Get.isDarkMode ? 800 : 200]!,
                                          spreadRadius: 1,
                                          blurRadius: 5)
                                    ],
                                  ),
                                  child: ClipRRect(
                                    //   borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                    child: GetBuilder<SplashController>(
                                      builder: (splashController) {
                                        return CustomImage(
                                          image:
                                              '$baseUrl/${bannerController.bannerImageList![index]}',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              bannerController.bannerImageList!.map((bnr) {
                            int index =
                                bannerController.bannerImageList!.indexOf(bnr);
                            return TabPageSelectorIndicator(
                              backgroundColor:
                                  index == bannerController.currentIndex
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.5),
                              borderColor:
                                  Theme.of(context).colorScheme.background,
                              size: index == bannerController.currentIndex
                                  ? 10
                                  : 7,
                            );
                          }).toList(),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: bannerController.bannerImageList == null,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: GetPlatform.isDesktop
                                ? 450
                                : MediaQuery.of(context).size.width * 0.52,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radiusSmall),
                              color: Colors.grey[
                                  Get.find<ThemeController>().darkTheme
                                      ? 700
                                      : 300],
                            )),
                      ),
                    ),
            );
    });
  }
}
