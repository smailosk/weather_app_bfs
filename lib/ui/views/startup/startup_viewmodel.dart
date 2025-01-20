import 'package:stacked/stacked.dart';
import 'package:weather_app_bfs/app/app.locator.dart';
import 'package:weather_app_bfs/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:weather_app_bfs/core/services/shared_prefs_service.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _sharedPrefsService = locator<SharedPrefsService>();

  Future runStartupLogic() async {
    await _sharedPrefsService.init();

    await Future.delayed(const Duration(seconds: 1));

    _navigationService.replaceWithWeatherView();
  }
}
