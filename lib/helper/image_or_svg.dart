import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageOrSvg extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;

  ImageOrSvg(
    this.url, {
    Key? key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
  }) : super(key: ValueKey(url));

  @override
  State<ImageOrSvg> createState() => _ImageOrSvgState();
}

class _ImageOrSvgState extends State<ImageOrSvg>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    final fullPath = widget.url;
    return fullPath.endsWith(".svg")
        ? SvgPicture.network(
            fullPath,
            key: widget.key,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            color: widget.color,
          )
        : ExtendedImage.network(
            fullPath,
            key: widget.key,
            width: widget.width,
            color: widget.color,
            height: widget.height,
            fit: widget.fit,
            cache: true,
            opacity: _controller,
            handleLoadingProgress: true,
            enableLoadState: true,
            cacheMaxAge: const Duration(days: 7),
            loadStateChanged: (ff) {
              switch (ff.extendedImageLoadState) {
                case LoadState.loading:
                  _controller.reset();
                  return Image.asset(
                    "assets/loading.gif",
                    fit: BoxFit.fill,
                  );
                case LoadState.failed:
                  _controller.forward();
                  return FadeTransition(
                    opacity: _controller,
                    child: InkWell(
                      onTap: () {
                        ff.reLoadImage();
                      },
                      child: const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                  );
                case LoadState.completed:
                  _controller.forward();
                  return FadeTransition(
                    opacity: _controller,
                    child: ExtendedRawImage(
                      image: ff.extendedImageInfo?.image,
                      width: widget.width,
                      color: widget.color,
                      height: widget.height,
                      fit: widget.fit,
                    ),
                  );
              }
            },
          );
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
