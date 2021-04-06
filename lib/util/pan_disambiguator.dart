import 'dart:async';
import 'dart:collection';

import 'package:flutter/gestures.dart';

// maximal duration between changes in the two pointers
// when starting or ending a scale
const _maxScalePointerDelay = Duration(milliseconds: 50);

class PanDisambiguator {
  final void Function(Offset localPosition)? onPan;

  final _panBacklog = _Backlog();
  final _panSuspense = _Suspense();

  PanDisambiguator(this.onPan);

  void start(ScaleStartDetails details) {
    _handleInteraction(details.pointerCount, details.localFocalPoint,
        isStart: true);
  }

  void update(ScaleUpdateDetails details) {
    _handleInteraction(details.pointerCount, details.localFocalPoint);
  }

  void _handleInteraction(int pointerCount, Offset point,
      {bool isStart = false}) {
    // interaction with multiple pointers -> scale, else -> pan
    final bool isScale = pointerCount > 1;

    if (isScale || _panSuspense.isSuspended) {
      // scale -> queued pans have become obsolete
      _panBacklog.clear();
    } else {
      if (isStart) {
        // start of pan -> temporarily suspend pans (but queue them for later)
        // because it might turn out to be the start of a scale instead
        _panBacklog.suspend(_maxScalePointerDelay);
      }

      // pan -> queue if pans are currently suspended, else run immediately
      _panBacklog.add(() {
        onPan?.call(point);
      });
    }
  }

  void end(ScaleEndDetails details) {
    // end of interaction with leftover pointers -> scale, else -> pan
    final bool isScale = details.pointerCount > 0;

    if (isScale) {
      // end of scale -> temporarily suspend pans (and forget them)
      // because they are just artifacts of ending the scale
      _panSuspense.suspend(_maxScalePointerDelay);
    }
  }
}

class _Backlog {
  final Queue<void Function()> _queue = Queue();
  final _Suspense _suspense = _Suspense();

  void add(void Function() task) {
    if (_suspense.isSuspended) {
      _queue.add(task);
    } else {
      task();
    }
  }

  void suspend(Duration duration) {
    _suspense.suspend(duration, callback: () {
      for (final task in _queue) {
        task();
      }

      clear();
    });
  }

  void clear() {
    _queue.clear();
  }
}

class _Suspense {
  Timer? _timer;

  bool get isSuspended => _timer?.isActive ?? false;

  void suspend(Duration duration, {void Function()? callback}) {
    _timer?.cancel();
    _timer = Timer(duration, () {
      _timer = null;
      callback?.call();
    });
  }
}
