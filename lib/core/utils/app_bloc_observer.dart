import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Global BlocObserver that logs all Bloc events, state transitions, and errors to the debug console.
class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('⚡ [BLOC EVENT] ${bloc.runtimeType} -> $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint(
      '🔄 [BLOC STATE CHANGE] ${bloc.runtimeType}\n'
      '   ├── Current: ${change.currentState}\n'
      '   └── Next:    ${change.nextState}',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('❌ [BLOC ERROR] ${bloc.runtimeType} error: $error\n$stackTrace');
  }
}
