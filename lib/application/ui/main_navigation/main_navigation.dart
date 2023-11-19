import 'package:senly/application/domain/screen_factory/screen_factory.dart';
import 'package:flutter/material.dart';

abstract class MainNavigationScreens {
  static const mainScreen = '/';
  static const registerScreen = '/register';
}

class MainNavigation {
  static final _screenFactory = ScreenFactory();

  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationScreens.mainScreen: (_) =>
        _screenFactory.makeMainTabsScreen(),
    MainNavigationScreens.registerScreen: (_) =>
        _screenFactory.makeRegisterScreen(),
  };

  Route<Object>? onGenerateRoute(RouteSettings settings) {
    return null;
  }
}
