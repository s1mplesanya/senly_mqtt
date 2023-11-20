import 'package:provider/provider.dart';
import 'package:senly/application/ui/screens/main_screen/main_screen_model.dart';
import 'package:senly/application/ui/screens/main_screen/main_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:senly/application/ui/screens/register_screen/register_screen_model.dart';
import 'package:senly/application/ui/screens/register_screen/register_screen_widget.dart';
import 'package:senly/application/ui/screens/user_screen/user_screen_model.dart';
import 'package:senly/application/ui/screens/user_screen/user_screen_widget.dart';

class ScreenFactory {
  Widget makeMainTabsScreen() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MainScreenModel(),
      child: const MainScreenWidget(),
    );
  }

  Widget makeRegisterScreen() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => RegisterScreenModel(context),
      child: const RegisterScreenWidget(),
    );
  }

  Widget makeUserScreen() {
    return Provider(
      create: (BuildContext context) => UserScreenModel(),
      child: const UserScreenWidget(),
    );
  }
}
