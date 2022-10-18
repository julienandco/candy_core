import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

bool get kIsWebOrMacOS => (kIsWeb || Platform.isMacOS);

bool isWebInDesktop(BuildContext context) =>
    (kIsWeb && MediaQuery.of(context).size.width >= _desktopBreakPointWidth);
bool isWebInMobile(BuildContext context) =>
    (kIsWeb && MediaQuery.of(context).size.width < _desktopBreakPointWidth);

int _desktopBreakPointWidth = 1024;

extension BuildContextData on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
}
