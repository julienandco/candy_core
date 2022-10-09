import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RedirectedCachedNetworkImage extends StatefulWidget {
  final String url;
  final String Function(String) buildRedirectURL;
  final Widget placeholder;
  final Map<String, String>? httpHeaders;
  final BoxFit fit;
  final double? width;
  final double? height;
  final int? maxHeightDiskCache;
  final bool debugPrint;
  final bool needsRedirect;
  final Duration? fadeOutDuration;
  final Widget Function(BuildContext, String, DownloadProgress)?
      progressIndicatorBuilder;
  final Color? color;
  final bool withFade;

  const RedirectedCachedNetworkImage({
    Key? key,
    required this.url,
    required this.buildRedirectURL,
    required this.placeholder,
    this.httpHeaders,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.progressIndicatorBuilder,
    this.maxHeightDiskCache,
    this.debugPrint = false,
    this.needsRedirect = true,
    this.color,
    this.fadeOutDuration = const Duration(milliseconds: 2),
    this.withFade = true,
  }) : super(key: key);

  @override
  State<RedirectedCachedNetworkImage> createState() =>
      _RedirectedCachedNetworkImageState();
}

class _RedirectedCachedNetworkImageState
    extends State<RedirectedCachedNetworkImage> {
  String? _redirectedUrl;

  @override
  void initState() {
    _redirectedUrl = widget.buildRedirectURL(widget.url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_redirectedUrl != null) {
      return CachedNetworkImage(
        imageUrl: _redirectedUrl!,
        fadeInDuration:
            widget.withFade ? const Duration(milliseconds: 2) : Duration.zero,
        placeholderFadeInDuration:
            widget.withFade ? const Duration(milliseconds: 2) : Duration.zero,
        maxHeightDiskCache: widget.maxHeightDiskCache,
        errorWidget: (context, url, error) => widget.placeholder,
        progressIndicatorBuilder:
            widget.withFade ? widget.progressIndicatorBuilder : null,
        httpHeaders: widget.httpHeaders,
        fadeOutDuration:
            widget.withFade ? widget.fadeOutDuration : Duration.zero,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        placeholder: widget.progressIndicatorBuilder != null
            ? null
            : (context, url) => widget.placeholder,
        color: widget.color,
      );
    }
    return widget.placeholder;
  }
}
