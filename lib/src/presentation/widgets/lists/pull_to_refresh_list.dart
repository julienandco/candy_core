import 'dart:async';

import 'package:flutter/material.dart';

const _kTextFieldChangeDebounceMilliseconds = 500;
const _kInfiniteScrollThreshold = 1000;

class PullToRefreshList extends StatelessWidget {
  final Widget child;
  final Function(Widget) buildRefreshIndicator;
  final ScrollController? scrollController;
  final void Function()? onFetchMore;
  final int? fetchMoreThreshold;
  final bool withFetchMoreListener;

  const PullToRefreshList({
    Key? key,
    required this.child,
    required this.buildRefreshIndicator,
    this.scrollController,
    this.onFetchMore,
    this.fetchMoreThreshold,
    this.withFetchMoreListener = false,
  })  : assert(!withFetchMoreListener || scrollController != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final pullToRefreshChild = buildRefreshIndicator(child);

    return withFetchMoreListener
        ? _FetchMoreListener(
            scrollController: scrollController!,
            onFetchMore: onFetchMore,
            threshold: fetchMoreThreshold ?? _kInfiniteScrollThreshold,
            child: pullToRefreshChild,
          )
        : pullToRefreshChild;
  }
}

class _FetchMoreListener extends StatefulWidget {
  final ScrollController scrollController;
  final Widget child;
  final int threshold;
  final Function()? onFetchMore;

  const _FetchMoreListener({
    Key? key,
    required this.scrollController,
    required this.child,
    required this.threshold,
    this.onFetchMore,
  }) : super(key: key);

  @override
  _FetchMoreListenerState createState() => _FetchMoreListenerState();
}

class _FetchMoreListenerState extends State<_FetchMoreListener> {
  Timer? _debounce;

  @override
  void initState() {
    widget.scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_debounce?.isActive ?? false) {
      return;
    }
    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.position.pixels;

    if (maxScroll - currentScroll <= widget.threshold) {
      widget.onFetchMore?.call();
    }
    _debounce = Timer(
      const Duration(milliseconds: _kTextFieldChangeDebounceMilliseconds),
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
