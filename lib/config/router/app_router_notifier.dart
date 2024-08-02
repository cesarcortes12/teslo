import 'dart:async';

import 'package:flutter/foundation.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    //notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) {
        notifyListeners();
        print('GoRouterRefreshStream: change detected');
      },
    );
  }

  late StreamSubscription<dynamic> _subscription;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
