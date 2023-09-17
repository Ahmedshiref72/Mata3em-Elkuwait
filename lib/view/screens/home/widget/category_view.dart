import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/title_widget.dart';
import 'package:efood_multivendor/view/screens/home/widget/category_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

import '../../../base/custom_button.dart';
import '../../auth/sign_in_screen.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return GetBuilder<CategoryController>(builder: (categoryController) {
      return (categoryController.categoryList != null &&
              categoryController.categoryList!.isEmpty)
          ? const SizedBox()
          : Column(
              children: [
               /* Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child:
                        SizedBox() *//* TitleWidget(title: 'categories'.tr, onTap: () => Get.toNamed(RouteHelper.getCategoryRoute())),*//*
                    ),*/
                Row(
                  children: [
                    /*Expanded(
                child: SizedBox(
                  height: 150,
                  child: categoryController.categoryList != null ?
                  ListView.builder(
                    controller: scrollController,
                    itemCount: categoryController.categoryList!.length > 15 ? 15 : categoryController.categoryList!.length,
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: InkWell(
                          onTap: () => Get.toNamed(RouteHelper.getCategoryProductRoute(
                            categoryController.categoryList![index].id, categoryController.categoryList![index].name!,
                          )),
                          child: SizedBox(
                            width: 120,
                            child: Column(children: [
                              Container(
                                height: 120, width: 120,
                                margin: EdgeInsets.only(
                                  left: index == 0 ? 0 : Dimensions.paddingSizeExtraSmall,
                                  right: Dimensions.paddingSizeExtraSmall,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  child: CustomImage(
                                    image: '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${categoryController.categoryList![index].image}',
                                    height: 120, width: 120, fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              Padding(
                                padding: EdgeInsets.only(right: index == 0 ? Dimensions.paddingSizeExtraSmall : 0),
                                child: Text(
                                  categoryController.categoryList![index].name!,
                                  style: robotoMedium.copyWith(fontSize: 20),
                                  maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                                ),
                              ),

                            ]),
                          ),
                        ),
                      );
                    },
                  ) : CategoryShimmer(categoryController: categoryController),
                ),
              ),*/
                    categoryController.categoryList != null ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: 260,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //  mainAxisSpacing: 35,

                          crossAxisCount: ResponsiveHelper.isDesktop(context)
                              ? 6
                              : ResponsiveHelper.isTab(context)
                                  ? 2
                                  : 2,
                          childAspectRatio: (2 / 1.4),
                        ),
                        padding: const EdgeInsets.all(1),
                        itemCount: categoryController.categoryList!.length > 6
                            ? 4
                            : categoryController.categoryList!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: InkWell(
                              onTap: () => Get.toNamed(
                                  RouteHelper.getCategoryProductRoute(
                                categoryController.categoryList![index].id,
                                categoryController.categoryList![index].name!,
                              )),
                              child: SizedBox(
                                child: Column(children: [
                                  Container(
                                      height: 120,
                                      width: MediaQuery.of(context).size.width *
                                          .45,
                                      margin: EdgeInsets.only(
                                        left: Dimensions.paddingSizeExtraSmall,
                                        right: Dimensions.paddingSizeExtraSmall,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusSmall),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          right: 10,
                                                          left: 10.0),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        categoryController
                                                            .categoryList![
                                                                index]
                                                            .name!,
                                                        style: robotoMedium
                                                            .copyWith(
                                                                fontSize: 18),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Container(
                                                        width: 50,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                          color: Color(0xFFfe0000),
                                                          borderRadius: BorderRadius.circular(25)
                                                        ),
                                                        child: Center(child: Text('New'.tr,style: TextStyle(fontSize: 12,color: Colors.white),)),
                                                      )

                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CustomImage(
                                                image:
                                                    '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${categoryController.categoryList![index].image}',
                                                height: 100,
                                                width:85,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      /* ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),

                                child: CustomImage(
                                  image: '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${categoryController.categoryList![index].image}',
                                  height: 80, width: 140,
                                ),
                              ),*/
                                      ),
                                ]),
                              ),
                            ),
                          );
                        },
                      ),
                    ) : CategoryAllShimmer(
                        categoryController: categoryController),
                    ResponsiveHelper.isMobile(context)
                        ? const SizedBox()
                        : categoryController.categoryList != null
                            ? Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (con) => Dialog(
                                              child: SizedBox(
                                                  height: 550,
                                                  width: 600,
                                                  child: CategoryPopUp(
                                                    categoryController:
                                                        categoryController,
                                                  ))));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: Dimensions.paddingSizeSmall),
                                      child: CircleAvatar(
                                        radius: 35,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: Text('view_all'.tr,
                                            style: TextStyle(
                                                fontSize: Dimensions
                                                    .paddingSizeDefault,
                                                color: Theme.of(context)
                                                    .cardColor)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              )
                            : CategoryAllShimmer(
                                categoryController: categoryController)
                  ],
                ),
              ],
            );
    });
  }
}

class CategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;

  const CategoryShimmer({Key? key, required this.categoryController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        itemCount: 14,
        padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: categoryController.categoryList == null,
              child: Column(children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[
                        Get.find<ThemeController>().darkTheme ? 700 : 300],
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                    height: 10,
                    width: 50,
                    color: Colors.grey[
                        Get.find<ThemeController>().darkTheme ? 700 : 300]),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class CategoryAllShimmer extends StatelessWidget {
  final CategoryController categoryController;

  const CategoryAllShimmer({Key? key, required this.categoryController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Padding(
        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
        child: Shimmer(
          duration: const Duration(seconds: 2),
          enabled: categoryController.categoryList == null,
          child: Column(children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
            ),
            const SizedBox(height: 5),
            Container(height: 10, width: 50, color: Colors.grey[300]),
          ]),
        ),
      ),
    );
  }
}
