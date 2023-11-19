import 'package:flutter/material.dart';
import 'package:senly/application/domain/services/auth_service.dart';
import 'package:senly/application/ui/main_navigation/main_navigation.dart';

class RegisterScreenModel extends ChangeNotifier {
  final BuildContext _context;
  final _authService = AuthService();

  RegisterScreenModel(this._context) {
    _initialize();
  }
  void _initialize() {
    if (_authService.isAlreadyLogged() == true) {
      Future.microtask(
        () => Navigator.pushNamed(_context, MainNavigationScreens.mainScreen),
      );
    }
  }

  void registerWithGoogle(BuildContext context) async {
    final user = await _authService.signInWithGoogle();
    print(user);
    if (user != null) {
      Future.microtask(
        () => Navigator.pushNamed(context, MainNavigationScreens.mainScreen),
      );
    }
  }
}
