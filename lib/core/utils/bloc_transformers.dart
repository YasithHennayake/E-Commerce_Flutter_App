import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) =>
      _debounceStream(events, duration).asyncExpand(mapper);
}

Stream<T> _debounceStream<T>(Stream<T> input, Duration duration) {
  final controller = StreamController<T>();
  Timer? timer;
  late StreamSubscription<T> sub;

  sub = input.listen(
    (event) {
      timer?.cancel();
      timer = Timer(duration, () => controller.add(event));
    },
    onError: controller.addError,
    onDone: () {
      timer?.cancel();
      controller.close();
    },
    cancelOnError: false,
  );

  controller.onCancel = () async {
    timer?.cancel();
    await sub.cancel();
  };

  return controller.stream;
}
