import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

void pushRouteAndRefreshOnReturn(
  BuildContext context, {
  required PageRouteInfo<dynamic> route,
  required Function() refresh,
}) async {
  log('$route', name: 'pushRouteAndRefresh');
  await context.router.push(route);
  refresh();
}

void navigateToRouteAndRefreshOnReturn(
  BuildContext context, {
  required PageRouteInfo<dynamic> route,
  required Function() refresh,
}) async {
  log('$route', name: 'navigateToRouteAndRefresh');
  await context.router.navigate(route);
  refresh();
}
