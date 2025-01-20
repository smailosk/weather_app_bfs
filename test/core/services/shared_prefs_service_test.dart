import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app_bfs/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('SharedPrefsServiceTest -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
