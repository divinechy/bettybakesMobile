import 'package:get_it/get_it.dart';
import 'navService.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
}