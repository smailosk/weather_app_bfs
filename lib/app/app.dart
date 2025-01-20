import 'package:weather_app_bfs/core/services/location_service.dart';
import 'package:weather_app_bfs/core/services/shared_prefs_service.dart';
import 'package:weather_app_bfs/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:weather_app_bfs/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:weather_app_bfs/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:weather_app_bfs/ui/views/weather/weather_view.dart';
import 'package:weather_app_bfs/core/services/weather_service.dart';
// @stacked-import

@StackedApp(routes: [
  MaterialRoute(page: StartupView),
  MaterialRoute(page: WeatherView),
// @stacked-route
], dependencies: [
  LazySingleton(classType: BottomSheetService),
  LazySingleton(classType: DialogService),
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: WeatherService),
  LazySingleton(classType: LocationService),
  LazySingleton(classType: SharedPrefsService),

// @stacked-service
], bottomsheets: [
  StackedBottomsheet(classType: NoticeSheet),
  // @stacked-bottom-sheet
], dialogs: [
  StackedDialog(classType: InfoAlertDialog),
  // @stacked-dialog
], logger: StackedLogger())
class App {}
