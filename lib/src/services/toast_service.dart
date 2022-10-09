import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class ToastService {
  ///
  /// The container that styles the default toast.
  ///
  final Container Function(String?) buildDefaultToast;

  ///
  /// The container that styles the dedicated toast for error messages.
  ///
  final Container Function(String?)? buildErrorToast;

  ///
  /// The container that styles the dedicated toast for success messages.
  ///
  final Container Function(String?)? buildSuccesToast;

  ///
  /// The default position of the shown toast.
  ///
  final StyledToastPosition toastPosition;

  ///
  /// The duration for which the toast is shown. Defaults to 5 seconds.
  ///
  final Duration showDuration;

  ///
  /// The duration it takes for the toast to animate in and out. Defaults to
  /// 1 second.
  ///
  final Duration animationDuration;

  ///
  /// An animation builder to control the fadeIN animation of the toast.
  /// Defaults to a [SlideTransition] from right to left.
  ///
  final Widget Function(BuildContext, AnimationController, Duration, Widget)?
      fadeInAnimationBuilder;

  ///
  /// An animation builder to control the fadeOUT animation of the toast.
  /// Defaults to a [SlideTransition] from right to left.
  ///
  final Widget Function(BuildContext, AnimationController, Duration, Widget)?
      fadeOutAnimationBuilder;

  const ToastService({
    required this.buildDefaultToast,
    this.buildErrorToast,
    this.buildSuccesToast,
    this.toastPosition = StyledToastPosition.top,
    this.showDuration = const Duration(
      seconds: 5,
    ),
    this.animationDuration = const Duration(
      seconds: 1,
    ),
    this.fadeInAnimationBuilder,
    this.fadeOutAnimationBuilder,
  });

  void showErrorToast(BuildContext context, [String? message]) {
    final errorToast =
        buildErrorToast?.call(message) ?? buildDefaultToast(message);

    _showCustomToast(context, errorToast);
  }

  void showSuccessToast(BuildContext context, [String? message]) {
    final successToast =
        buildSuccesToast?.call(message) ?? buildDefaultToast(message);

    _showCustomToast(context, successToast);
  }

  void _showCustomToast(BuildContext context, Container toast) {
    showToastWidget(
      GestureDetector(
        onTap: () {
          dismissAllToast(showAnim: true);
        },
        child: toast,
      ),
      context: context,
      position: toastPosition,
      duration: showDuration,
      animDuration: animationDuration,
      isIgnoring: false,
      animationBuilder: fadeInAnimationBuilder ??
          (
            BuildContext context,
            AnimationController controller,
            Duration duration,
            Widget child,
          ) =>
              _defaultAnimation(
                context,
                controller: controller,
                duration: duration,
                child: child,
              ),
      reverseAnimBuilder: fadeOutAnimationBuilder ??
          (
            BuildContext context,
            AnimationController controller,
            Duration duration,
            Widget child,
          ) =>
              _defaultAnimation(
                context,
                controller: controller,
                duration: duration,
                child: child,
              ),
    );
  }

  Widget _defaultAnimation(BuildContext context,
          {required AnimationController controller,
          required Duration duration,
          required Widget child}) =>
      SlideTransition(
        position: getAnimation<Offset>(
          const Offset(0.0, 0.0),
          const Offset(0.0, -20.0),
          controller,
          curve: Curves.fastOutSlowIn,
        ),
        child: child,
      );
}
