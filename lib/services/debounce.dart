import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [DebounceCallBack] is a typedef for the callback
typedef DebounceCallBack = void Function();

/// [Debounce] class that debounces the action
class Debounce {
  /// [Debounce] constructor
  Debounce({required this.interval});

  /// [interval] is the duration for which the debounce is to be done
  final Duration interval;

  DebounceCallBack? _action;
  Timer? _timer;

  /// [call] method that calls the debounce
  void call(DebounceCallBack action) {
    _action = action;
    _timer?.cancel();
    _timer = Timer(interval, _callAction);
  }

  void _callAction() {
    _action?.call();
    _timer = null;
  }

  /// [reset] method resets the debounce
  void reset() {
    _action = null;
    _timer = null;
  }
}

/// will provide an instance of [Debounce]
final debounceProvider =
    Provider((ref) => Debounce(interval: const Duration(milliseconds: 1000)));
