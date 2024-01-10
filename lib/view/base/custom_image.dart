import 'package:efood_multivendor/helper/image_or_svg.dart';
import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final bool isNotification;
  final String placeholder;
  const CustomImage(
      {Key? key,
      required this.image,
      this.height,
      this.width,
      this.fit = BoxFit.cover,
      this.isNotification = false,
      this.placeholder = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImageOrSvg(
      image,
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain,
    );
  }
}
