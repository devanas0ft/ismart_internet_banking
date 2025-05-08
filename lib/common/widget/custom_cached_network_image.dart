import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/custom_cache_manager.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    required this.url,
    required this.fit,
    this.height,
    this.width,
    this.color,
    this.placeholder,
    this.placeholderFit,
    this.alignment = Alignment.center,
    this.customPlaceHolder,
  });

  final String url;
  final BoxFit fit;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? placeholderFit;
  final String? placeholder;
  final Alignment alignment;
  final Widget? customPlaceHolder;

  @override
  Widget build(BuildContext context) {
    final String _url = url;
    return CachedNetworkImage(
      imageUrl: _url,
      fit: fit,
      height: height,
      width: width,
      color: color,
      alignment: alignment,
      cacheManager: CustomCacheManager.instance,
      errorWidget:
          (a, b, c) =>
              customPlaceHolder ??
              Image.asset(
                placeholder ??
                    RepositoryProvider.of<CoOperative>(context).coOperativeLogo,
                fit: placeholderFit ?? fit,
                height: height,
                alignment: alignment,
                width: width,
              ),
      placeholder:
          (a, c) =>
              customPlaceHolder ??
              Image.asset(
                placeholder ??
                    RepositoryProvider.of<CoOperative>(context).coOperativeLogo,
                fit: placeholderFit ?? fit,
                height: height,
                alignment: alignment,
                width: width,
              ),
    );
  }
}
