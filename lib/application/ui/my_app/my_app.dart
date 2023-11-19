import 'package:senly/application/ui/main_navigation/main_navigation.dart';
import 'package:senly/application/ui/themes/app_theme.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mainNavigation = MainNavigation();

    return MaterialApp(
      title: 'Senly',
      debugShowCheckedModeBanner: false,
      // themeMode: ThemeMode.dark,
      theme: AppTheme.light(context),
      routes: mainNavigation.routes,
      initialRoute: MainNavigationScreens.registerScreen,
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}
