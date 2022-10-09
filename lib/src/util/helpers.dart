import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

bool get isWebOrMacOS => (kIsWeb || Platform.isMacOS);

bool isWebInDesktop(BuildContext context) =>
    (kIsWeb && MediaQuery.of(context).size.width >= _desktopBreakPointWidth);
bool isWebInMobile(BuildContext context) =>
    (kIsWeb && MediaQuery.of(context).size.width < _desktopBreakPointWidth);

int _desktopBreakPointWidth = 1024;
