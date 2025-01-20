import 'package:weather_app_bfs/app/app.bottomsheets.dart';
import 'package:weather_app_bfs/app/app.dialogs.dart';
import 'package:weather_app_bfs/app/app.locator.dart';
import 'package:weather_app_bfs/app/app.router.dart';
import 'package:weather_app_bfs/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();

  String get counterLabel => 'Counter is: $_counter';

  int _counter = 0;

  bool get isAlertMode => _counter > 10;

  void incrementCounter() {
    _counter++;

    rebuildUi();
  }

  void showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Stacked Rocks!',
      description: 'Give stacked $_counter stars on Github',
    );
  }

  void showBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
  }

  final _navigationService = locator<NavigationService>();

  void goToWeatherView() {
    _navigationService.replaceWithWeatherView();
  }
}
