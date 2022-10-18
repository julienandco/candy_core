import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:candy_core/src/domain/entities/entities.dart';

///
/// Implementation of an Error Service to dynamically handle errors and show
/// the user valuable output.
class ErrorService {
  ///
  /// Fetches the error map from the server and that holds
  /// the following format: [Map<String, Map<String, String>>]
  ///
  /// {
  ///   <errorCode1>: {
  ///         <languageCode1>: <errorMessageInLanguage1>,
  ///         <languageCode2>: <errorMessageInLanguage2>,
  ///         },
  ///   <errorCode2>: {
  ///         <languageCode1>: <errorMessageInLanguage1>,
  ///         <languageCode2>: <errorMessageInLanguage2>,
  ///         },
  /// }.
  ///
  final Future<Either<Failure, dynamic>> Function() getErrorsMap;

  ///
  /// Returns the language code for a given BuildContext. If you used
  /// EasyLocalization, you would simply pass the function
  /// [(context) => context.locale.languageCode].
  final String Function(BuildContext) getLocaleLanguageCodeForContext;

  ///
  /// Takes a BuildContext and an error message and shows a
  /// Toast or Snackbar with the error message.
  final void Function(BuildContext, String)? showErrorToast;

  ///
  /// The fallback value that is used, when the [ErrorService] has not been
  /// intialized by calling [initialize]. Thus, you should ensure that the map
  /// returned by [getErrorsMap] always contains an entry for the
  /// [defaultLocaleLanguageCode].
  final String defaultLocaleLanguageCode;

  ///
  /// If no entry for a given error code or language code is found in the
  /// map returned by [getErrorsMap], [defaultErrorMessage] is the default
  /// error message used during the invocation of [showErrorToast].
  final String defaultErrorMessage;

  ErrorService({
    required this.getErrorsMap,
    required this.getLocaleLanguageCodeForContext,
    this.defaultLocaleLanguageCode = 'en',
    this.defaultErrorMessage = 'Something went wrong...',
    this.showErrorToast,
  });

  @visibleForTesting
  Map<String, dynamic> errorsMap = {};

  @visibleForTesting
  BuildContext? rootContext;

  Future<void> initialize(BuildContext context) async {
    rootContext = context;
    final response = await getErrorsMap();
    response.fold(
      (l) => null,
      (r) => errorsMap = json.decode(r) as Map<String, dynamic>,
    );
  }

  void setContext(BuildContext context) => rootContext = context;

  void showErrorForCode(int code) {
    if (rootContext == null) return;
    final errorMessage = getErrorMessageForCode(code);

    showErrorToast?.call(rootContext!, errorMessage);
  }

  String getErrorMessageForCode(int code) {
    final languageCode = rootContext != null
        ? getLocaleLanguageCodeForContext(rootContext!)
        : defaultLocaleLanguageCode;

    String? errorMessage;
    if (errorsMap.containsKey('$code')) {
      final codeMap = errorsMap['$code'] as Map<String, dynamic>;
      if (codeMap.containsKey(languageCode)) {
        errorMessage = codeMap[languageCode];
      }
    }

    return errorMessage ?? defaultErrorMessage;
  }
}
