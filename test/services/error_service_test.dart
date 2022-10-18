import 'dart:convert';

import 'package:candy_core/candy_core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class MockBuildContext extends Mock implements BuildContext {}

class ToastFunctions {
  void showToast(BuildContext context, String message) {}
}

class MockToastFunctions extends Mock implements ToastFunctions {}

const defaultErrorMessage = 'Fail';

ErrorService _buildDummyErrorService({
  bool useSophisticatedErrorMap = false,
  bool returnFailureFromGetMap = false,
  String languageCodeForContext = 'en',
  void Function(BuildContext, String)? showErrorToast,
}) {
  final errorMap =
      useSophisticatedErrorMap ? sophisticatedErrorMapString : '{}';

  return ErrorService(
    getErrorsMap: () async =>
        returnFailureFromGetMap ? const Left(Failure()) : Right(errorMap),
    getLocaleLanguageCodeForContext: (_) => languageCodeForContext,
    defaultErrorMessage: defaultErrorMessage,
    showErrorToast: showErrorToast,
  );
}

Map<String, dynamic> sophisticatedErrorMap = {
  '404': {
    'en': 'Not found',
    'de': 'Nicht gefunden',
  },
};

final String sophisticatedErrorMapString = json.encode(sophisticatedErrorMap);

void main() {
  setUpAll(() {
    registerFallbackValue(MockBuildContext());
    registerFallbackValue(defaultErrorMessage);
  });

  test('Is instantiated with null rootContext', () {
    final service = _buildDummyErrorService();
    expect(service.rootContext, isNull);
  });

  test('Is instantiated with empty errors map', () {
    final service = _buildDummyErrorService();

    expect(service.errorsMap, {});
  });

  group('Initialize', () {
    test('Initialize sets root context', () {
      final context = MockBuildContext();
      final service = _buildDummyErrorService();

      service.initialize(context);

      expect(service.rootContext, context);
    });

    test('Initialize sets error map', () {
      final context = MockBuildContext();
      final service = _buildDummyErrorService(useSophisticatedErrorMap: true);

      service
          .initialize(context)
          .then((_) => expect(service.errorsMap, sophisticatedErrorMap));
    });

    test('Initialize does not change error map if error occurs during getMap',
        () {
      final context = MockBuildContext();
      final service = _buildDummyErrorService(returnFailureFromGetMap: true);

      service.initialize(context).then((_) => expect(service.errorsMap, {}));
    });
  });

  group('Set Context', () {
    test('Set contexts sets rootContext', () {
      final context = MockBuildContext();
      final service = _buildDummyErrorService();

      service.setContext(context);

      expect(service.rootContext, context);
    });
  });

  group('Show Error', () {
    test('Does nothing if rootContext is Null', () {
      final mockToast = MockToastFunctions();
      final service =
          _buildDummyErrorService(showErrorToast: mockToast.showToast);

      service.showErrorForCode(404);

      verifyNever(
        () => mockToast.showToast(
          any<MockBuildContext>(),
          any<String>(),
        ),
      );
    });

    test('Shows default error message if none found in errorsMap', () {
      final mockToast = MockToastFunctions();
      final context = MockBuildContext();
      final service = _buildDummyErrorService(
        showErrorToast: mockToast.showToast,
        useSophisticatedErrorMap: true,
      );

      service.initialize(context).then(
        (_) {
          service.showErrorForCode(401);
          verify(
            () => mockToast.showToast(
              context,
              defaultErrorMessage,
            ),
          ).called(1);
        },
      );
    });

    test('Shows specific error message for given code in errorsMap', () {
      final mockToast = MockToastFunctions();
      final context = MockBuildContext();
      final service = _buildDummyErrorService(
        useSophisticatedErrorMap: true,
        showErrorToast: mockToast.showToast,
        languageCodeForContext: 'de',
      );

      service.initialize(context).then(
        (_) {
          service.showErrorForCode(404);
          verify(
            () => mockToast.showToast(
              context,
              'Nicht gefunden',
            ),
          ).called(1);
        },
      );
    });
  });
  group('Get Error Message For Code', () {
    test('Empty ErrorsMap returns default Error Message', () {
      final service = _buildDummyErrorService();
      final message = service.getErrorMessageForCode(404);

      expect(message, defaultErrorMessage);
    });

    test(
        ' ErrorsMap that does not contain given error code returns default Error Message',
        () {
      final context = MockBuildContext();
      final service = _buildDummyErrorService(useSophisticatedErrorMap: true);

      service.initialize(context).then(
        (_) {
          final message = service.getErrorMessageForCode(401);

          expect(message, defaultErrorMessage);
        },
      );
    });

    test(
        ' ErrorsMap that contains given error code, but not required language code returns default Error Message',
        () {
      final context = MockBuildContext();
      final service = _buildDummyErrorService(
        useSophisticatedErrorMap: true,
        languageCodeForContext: 'fr',
      );

      service.initialize(context).then(
        (_) {
          final message = service.getErrorMessageForCode(404);

          expect(message, defaultErrorMessage);
        },
      );
    });

    test(
        ' ErrorsMap returns correct error message for given error and language code',
        () {
      final context = MockBuildContext();
      final service = _buildDummyErrorService(
        useSophisticatedErrorMap: true,
      );

      service.initialize(context).then(
        (_) {
          final message = service.getErrorMessageForCode(404);

          expect(message, 'Not found');
        },
      );
    });
  });
}
