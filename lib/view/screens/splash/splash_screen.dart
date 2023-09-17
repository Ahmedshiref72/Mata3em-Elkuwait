import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/body/deep_link_body.dart';
import 'package:efood_multivendor/data/model/body/notification_body.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';

import 'package:video_player/video_player.dart';
import 'package:efood_multivendor/view/base/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  final NotificationBody? notificationBody;
  final DeepLinkBody? linkBody;
  const SplashScreen({Key? key, required this.notificationBody, required this.linkBody}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;
  late VideoPlayerController _controller;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/image/splash.mp4');
    _controller.initialize().then((_) {
      _controller.setLooping(false);
      Timer(const Duration(milliseconds: 3), () {
        setState(() {
          _controller.play();
          _controller.setLooping(true);
          _visible = true;
        });
      });
    });
    bool firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? const SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection'.tr : 'connected'.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if(!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    Get.find<SplashController>().initSharedData();
    if(Get.find<LocationController>().getUserAddress() != null && (Get.find<LocationController>().getUserAddress()!.zoneIds == null
        || Get.find<LocationController>().getUserAddress()!.zoneData == null)) {
      Get.find<AuthController>().clearSharedAddress();
    }
    Get.find<CartController>().getCartData();
    _route();

  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  void _route() {
    Get.find<SplashController>().getConfigData().then((isSuccess) {
      if(isSuccess) {
        Timer(const Duration(seconds: 2), () async {
          double? minimumVersion = 0;
          if(GetPlatform.isAndroid) {
            minimumVersion = Get.find<SplashController>().configModel!.appMinimumVersionAndroid;
          }else if(GetPlatform.isIOS) {
            minimumVersion = Get.find<SplashController>().configModel!.appMinimumVersionIos;
          }
          if(AppConstants.appVersion < minimumVersion! || Get.find<SplashController>().configModel!.maintenanceMode!) {
            Get.offNamed(RouteHelper.getUpdateRoute(AppConstants.appVersion < minimumVersion));
          }else {
            if(widget.notificationBody != null && widget.linkBody == null) {
              if (widget.notificationBody!.notificationType == NotificationType.order) {
                Get.offNamed(RouteHelper.getOrderDetailsRoute(widget.notificationBody!.orderId));
              }else if(widget.notificationBody!.notificationType == NotificationType.general){
                Get.offNamed(RouteHelper.getNotificationRoute(fromNotification: true));
              }else {
                Get.offNamed(RouteHelper.getChatRoute(notificationBody: widget.notificationBody, conversationID: widget.notificationBody!.conversationId));
              }
            }/*else if(widget.linkBody != null && widget.notificationBody == null){
              if(widget.linkBody.deepLinkType == DeepLinkType.restaurant){
                Get.toNamed(RouteHelper.getRestaurantRoute(widget.linkBody.id));
              }else if(widget.linkBody.deepLinkType == DeepLinkType.category){
                Get.toNamed(RouteHelper.getCategoryProductRoute(widget.linkBody.id, widget.linkBody.name));
              }else if(widget.linkBody.deepLinkType == DeepLinkType.cuisine){
                Get.toNamed(RouteHelper.getCuisineRestaurantRoute(widget.linkBody.id));
              }
            }*/ else {
              if (Get.find<AuthController>().isLoggedIn()) {
                Get.find<AuthController>().updateToken();
                await Get.find<WishListController>().getWishList();
                if (Get.find<LocationController>().getUserAddress() != null) {
                  Get.offNamed(RouteHelper.getInitialRoute( fromSplash: true ));
                } else {
                  Get.offNamed(RouteHelper.getAccessLocationRoute('splash'));
                }
              } else {
                if (Get.find<SplashController>().showIntro()!) {
                  if(AppConstants.languages.length > 1) {
                    Get.offNamed(RouteHelper.getLanguageRoute('splash'));
                  }else {
                    Get.offNamed(RouteHelper.getOnBoardingRoute());
                  }
                } else {
                  Get.offNamed(RouteHelper.getInitialRoute());
                }
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      key: _globalKey,
      body: GetBuilder<SplashController>(builder: (splashController) {
        return
          splashController.hasConnection ?
          AnimatedOpacity(opacity: _visible ? 1:1,
              child:VideoPlayer(_controller),
              duration: Duration(milliseconds: 3000))
              : NoInternetScreen(child: SplashScreen(notificationBody: widget.notificationBody, linkBody: widget.linkBody));
      }),
    );
  }
}
