import 'dart:developer';

import 'package:bloc/bloc.dart';

class AppBlocObserver extends BlocObserver {
  ///
  /// Enable or disable logging when a new bloc/cubit is created.
  ///
  final bool logBlocCreations;

  ///
  /// The message to be displayed upon a bloc/cubit creation.
  ///
  final String Function(BlocBase)? blocCreationLogMessage;

  ///
  /// Enable or disable logging when a bloc/cubit state change happens.
  /// This will only log AFTER a new state has been emitted.
  ///
  final bool logStateChanges;

  ///
  /// The message to be displayed upon a bloc/cubit state change.
  ///
  final String Function(BlocBase)? stateChangeLogMessage;

  ///
  /// Enable or disable logging when a bloc/cubit state transition happens.
  /// This will log when a new event is created and BEFORE a new state is
  /// emitted. Defaults to [false].
  ///
  final bool logStateTransitions;

  ///
  /// The message to be displayed upon a bloc/cubit state transition.
  ///
  final String Function(BlocBase)? stateTransitionLogMessage;

  ///
  /// Enable or disable logging when a bloc/cubit is closed.
  ///
  final bool logBlocClosings;

  ///
  /// The message to be displayed upon a bloc/cubit closing.
  ///
  final String Function(BlocBase)? blocClosingLogMessage;

  ///
  /// Enable or disable logging when a bloc event is dispatched.
  ///
  final bool logEventDispatches;

  ///
  /// The message to be displayed upon a bloc event dispatch.
  ///
  final String Function(BlocBase)? eventDispatchLogMessage;

  ///
  /// Enable or disable logging when an error occurs in a bloc/cubit.
  ///
  final bool logBlocErrors;

  ///
  /// The message to be displayed upon an error occurence in a bloc/cubit.
  ///
  final String Function(BlocBase)? blocErrorLogMessage;

  AppBlocObserver({
    this.blocCreationLogMessage,
    this.stateChangeLogMessage,
    this.stateTransitionLogMessage,
    this.blocClosingLogMessage,
    this.eventDispatchLogMessage,
    this.blocErrorLogMessage,
    this.logBlocCreations = true,
    this.logStateChanges = true,
    this.logStateTransitions = false,
    this.logBlocClosings = true,
    this.logEventDispatches = true,
    this.logBlocErrors = true,
  });

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);

    if (logBlocCreations) {
      final message = blocClosingLogMessage?.call(bloc) ??
          'Created with initial state: ${bloc.state.runtimeType}';
      log(message, name: '${bloc.runtimeType}');
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (logStateChanges) {
      final message = stateChangeLogMessage?.call(bloc) ??
          'State change: ${change.currentState.runtimeType} --> ${change.nextState.runtimeType}';
      log(message, name: '${bloc.runtimeType}');
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (logStateTransitions) {
      final message = stateTransitionLogMessage?.call(bloc) ??
          'State Transition: ${bloc.runtimeType} --> ${transition.nextState.runtimeType}';
      log(message, name: '${bloc.runtimeType}');
    }
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (logBlocClosings) {
      final message = blocClosingLogMessage?.call(bloc) ??
          'Closed with final state: ${bloc.state.runtimeType}';
      log(message, name: '${bloc.runtimeType}');
    }
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (logEventDispatches) {
      final message = eventDispatchLogMessage?.call(bloc) ??
          'New Event dispatched: ${event.runtimeType}';

      log(message, name: '${bloc.runtimeType}');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (logBlocErrors) {
      final message = blocErrorLogMessage?.call(bloc) ??
          'Error occured: ${error.runtimeType}';

      log(
        message,
        name: '${bloc.runtimeType}',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
