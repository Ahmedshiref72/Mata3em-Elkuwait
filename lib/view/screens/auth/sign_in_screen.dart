import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/localization_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/screens/auth/sign_up_screen.dart';
import 'package:efood_multivendor/view/screens/auth/widget/condition_check_box.dart';
import 'package:efood_multivendor/view/screens/auth/widget/guest_button.dart';
import 'package:efood_multivendor/view/screens/auth/widget/social_login_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

class SignInScreen extends StatefulWidget {
  final bool exitFromApp;
  final bool backFromThis;
  const SignInScreen(
      {Key? key, required this.exitFromApp, required this.backFromThis})
      : super(key: key);
  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _countryDialCode;
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();

    _countryDialCode =
        Get.find<AuthController>().getUserCountryCode().isNotEmpty
            ? Get.find<AuthController>().getUserCountryCode()
            : CountryCode.fromCountryCode(
                    Get.find<SplashController>().configModel!.country!)
                .dialCode;
    _phoneController.text = Get.find<AuthController>().getUserNumber();
    _passwordController.text = Get.find<AuthController>().getUserPassword();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.exitFromApp) {
          if (_canExit) {
            if (GetPlatform.isAndroid) {
              SystemNavigator.pop();
            } else if (GetPlatform.isIOS) {
              exit(0);
            } else {
              Navigator.pushNamed(context, RouteHelper.getInitialRoute());
            }
            return Future.value(false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('back_press_again_to_exit'.tr,
                  style: const TextStyle(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            ));
            _canExit = true;
            Timer(const Duration(seconds: 2), () {
              _canExit = false;
            });
            return Future.value(false);
          }
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: ResponsiveHelper.isDesktop(context)
            ? Colors.transparent
            : Theme.of(context).cardColor,
        appBar: ResponsiveHelper.isDesktop(context)
            ? null
            : !widget.exitFromApp
                ? AppBar(
                    leading: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back_ios_rounded,
                          color: Theme.of(context).textTheme.bodyLarge!.color),
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent)
                : null,
        body: SafeArea(
            child: Scrollbar(
          child: Center(
            child: Container(
              width: context.width > 700 ? 500 : context.width,
              padding: context.width > 700
                  ? const EdgeInsets.all(50)
                  : const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
              margin: context.width > 700
                  ? const EdgeInsets.all(50)
                  : EdgeInsets.zero,
              decoration: context.width > 700
                  ? BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      boxShadow: ResponsiveHelper.isDesktop(context)
                          ? null
                          : [
                              BoxShadow(
                                  color:
                                      Colors.grey[Get.isDarkMode ? 700 : 300]!,
                                  blurRadius: 5,
                                  spreadRadius: 1)
                            ],
                    )
                  : null,
              child: GetBuilder<AuthController>(builder: (authController) {
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ResponsiveHelper.isDesktop(context)
                              ? Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    onPressed: () => Get.back(),
                                    icon: const Icon(Icons.clear),
                                  ),
                                )
                              : const SizedBox(),
                          Image.asset(Images.logo, width: 100),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Image.asset(Images.logoName, width: 100),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraLarge),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text('sign_in'.tr,
                                style: robotoBold.copyWith(
                                    fontSize: Dimensions.fontSizeExtraLarge)),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          CustomTextField(
                            titleText: ResponsiveHelper.isDesktop(context)
                                ? 'phone'.tr
                                : 'enter_phone_number'.tr,
                            hintText: 'enter_phone_number'.tr,
                            controller: _phoneController,
                            focusNode: _phoneFocus,
                            nextFocus: _passwordFocus,
                            inputType: TextInputType.phone,
                            isPhone: true,
                            onCountryChanged: (CountryCode countryCode) {
                              _countryDialCode = countryCode.dialCode;
                            },
                            countryDialCode: _countryDialCode != null
                                ? CountryCode.fromCountryCode(
                                        Get.find<SplashController>()
                                            .configModel!
                                            .country!)
                                    .code
                                : Get.find<LocalizationController>()
                                    .locale
                                    .countryCode,
                          ),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraLarge),
                          CustomTextField(
                            titleText: ResponsiveHelper.isDesktop(context)
                                ? 'password'.tr
                                : 'enter_your_password'.tr,
                            hintText: 'enter_your_password'.tr,
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            inputAction: TextInputAction.done,
                            inputType: TextInputType.visiblePassword,
                            prefixIcon: Icons.lock,
                            isPassword: true,
                            showTitle: ResponsiveHelper.isDesktop(context),
                            onSubmit: (text) => (GetPlatform.isWeb)
                                ? _login(authController, _countryDialCode!)
                                : null,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          Row(children: [
                            Expanded(
                              child: ListTile(
                                onTap: () => authController.toggleRememberMe(),
                                leading: Checkbox(
                                  activeColor: Theme.of(context).primaryColor,
                                  value: authController.isActiveRememberMe,
                                  onChanged: (bool? isChecked) =>
                                      authController.toggleRememberMe(),
                                ),
                                title: Text('remember_me'.tr),
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                horizontalTitleGap: 0,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Get.toNamed(
                                  RouteHelper.getForgotPassRoute(false, null)),
                              child: Text('${'forgot_password'.tr}?',
                                  style: robotoRegular.copyWith(
                                      color: Theme.of(context).hintColor)),
                            ),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          ConditionCheckBox(authController: authController),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          CustomButton(
                            radius: Dimensions.radiusDefault,
                            buttonText: 'sign_in'.tr,
                            isLoading: authController.isLoading,
                            onPressed: authController.acceptTerms
                                ? () =>
                                    _login(authController, _countryDialCode!)
                                : null,
                          ),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraLarge),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('do_not_have_account'.tr,
                                    style: robotoRegular.copyWith(
                                        color: Theme.of(context).hintColor)),
                                InkWell(
                                  onTap: () {
                                    if (ResponsiveHelper.isDesktop(context)) {
                                      Get.back();
                                      Get.dialog(const SignUpScreen());
                                    } else {
                                      Get.toNamed(RouteHelper.getSignUpRoute());
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeExtraSmall),
                                    child: Text('sign_up'.tr,
                                        style: robotoMedium.copyWith(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  ),
                                ),
                              ]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          const SocialLoginWidget(),
                            GuestButton(onTap: (){
                            _guestLogin(authController);
                          }),
                        ]),
                  ),
                );
              }),
            ),
          ),
        )),
      ),
    );
  }

  void _login(AuthController authController, String countryDialCode) async {
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String numberWithCountryCode = countryDialCode + phone;
    bool isValid = GetPlatform.isAndroid ? false : true;
    if (GetPlatform.isAndroid) {
      try {
        PhoneNumber phoneNumber =
            await PhoneNumberUtil().parse(numberWithCountryCode);
        numberWithCountryCode =
            '+${phoneNumber.countryCode}${phoneNumber.nationalNumber}';
        isValid = true;
      } catch (_) {}
    }
    if (phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else {
      authController
          .login(numberWithCountryCode, password,
              alreadyInApp: widget.backFromThis)
          .then((status) async {
        if (status.isSuccess) {
          if (authController.isActiveRememberMe) {
            authController.saveUserNumberAndPassword(
                phone, password, countryDialCode);
          } else {
            authController.clearUserNumberAndPassword();
          }
          String token = status.message!.substring(1, status.message!.length);
          if (Get.find<SplashController>().configModel!.customerVerification! &&
              int.parse(status.message![0]) == 0) {
            List<int> encoded = utf8.encode(password);
            String data = base64Encode(encoded);
            Get.toNamed(RouteHelper.getVerificationRoute(
                numberWithCountryCode, token, RouteHelper.signUp, data));
          } else {
            if (widget.backFromThis) {
              Get.back();
            } else {
              Get.find<LocationController>()
                  .navigateToLocationScreen('sign-in', offNamed: true);
              // Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
            }
          }
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }

  void _guestLogin(AuthController authController) async {
    if (false) {
    } else {
      authController
          .guestLogin(alreadyInApp: widget.backFromThis)
          .then((status) async {
        if (status.isSuccess) {

          String token = status.message!.substring(1, status.message!.length);
          if (Get.find<SplashController>().configModel!.customerVerification! &&
              int.parse(status.message![0]) == 0) {
            // List<int> encoded = utf8.encode(password);
            // String data = base64Encode(encoded);
            // Get.toNamed(RouteHelper.getVerificationRoute(
            //     numberWithCountryCode, token, RouteHelper.signUp, data));
          } else {
            if (widget.backFromThis) {
              Get.back();
            } else {
              Get.find<LocationController>()
                  .navigateToLocationScreen('sign-in', offNamed: true);
              // Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
            }
          }
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
