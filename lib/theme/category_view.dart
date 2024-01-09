import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/home/widget/category_pop_up.dart';
import 'package:efood_multivendor/view/screens/order/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../controller/auth_controller.dart';
import '../view/screens/favourite/favourite_screen.dart';

class Shortcuts2 extends StatefulWidget {
  const Shortcuts2({Key? key}) : super(key: key);

  @override
  State<Shortcuts2> createState() => _Shortcuts2State();
}

class _Shortcuts2State extends State<Shortcuts2> {
  int _selectedIndex = 0;

  final List<IconData> icons = [
    Icons.favorite_outlined,
    Icons.shopping_cart,
    Icons.energy_savings_leaf,
    // Add more icons as needed
  ];

  get searchController => null;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return GetBuilder<CategoryController>(builder: (categoryController) {
      return (categoryController.categoryList != null &&
              categoryController.categoryList!.isEmpty)
          ? const SizedBox()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Row(
                    children: [
                      Text('shortCuts'.tr,
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    GetBuilder<AuthController>(
                      builder: (authController) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  ResponsiveHelper.isDesktop(context)
                                      ? 6
                                      : ResponsiveHelper.isTab(context)
                                          ? 4
                                          : 3,
                              childAspectRatio: (1 / 1),
                            ),
                            padding: const EdgeInsets.all(1),
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: InkWell(
                                  onTap: () {
                                    String routeName;
                                    switch (index) {
                                      case 0:
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FavouriteScreen()),
                                        );
                                        break;
                                      case 1:
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderScreen()),
                                        );
                                        break;
                                      case 2:
                                        Get.toNamed(
                                            RouteHelper.getVegRestaurantsRoute(
                                                'popular'));
                                        break;
                                      default:
                                        routeName = '/';
                                    }
                                  },
                                  child: SizedBox(
                                    child: Column(children: [
                                      Container(
                                          margin: EdgeInsets.only(
                                            left: Dimensions
                                                .paddingSizeExtraSmall,
                                            right: Dimensions
                                                .paddingSizeExtraSmall,
                                          ),
                                          child: Container(
                                            child: Center(
                                              child: Icon(
                                                icons[index],
                                                size: 50,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            height: 75,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              color: Color(0XFFfef4cf),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusSmall),
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
                                      /* Padding(
                                        padding: EdgeInsets.only(
                                          top: 5,
                                        ),
                                        child: Text(
                                          texts[index],
                                          style: robotoMedium.copyWith(
                                              fontSize: 14),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),*/
                                    ]),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
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
