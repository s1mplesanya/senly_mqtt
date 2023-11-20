import 'package:flutter/material.dart';
import 'package:senly/application/domain/entity/user.dart';
import 'package:senly/application/domain/services/auth_service.dart';
import 'package:senly/application/domain/services/user_service.dart';
import 'package:senly/application/ui/main_navigation/main_navigation.dart';

class RegisterScreenModel extends ChangeNotifier {
  final BuildContext _context;
  final _authService = AuthService();

  RegisterScreenModel(this._context) {
    _initialize();
  }
  void _initialize() async {
    final isUserFound =
        await UserService.getUserFromFirestore(_authService.user!.uid);
    if (_authService.isAlreadyLogged() == true && isUserFound == true) {
      Future.microtask(
        () => Navigator.pushNamed(_context, MainNavigationScreens.mainScreen),
      );
    }
  }

  void registerWithGoogle(BuildContext context) async {
    final user = await _authService.signInWithGoogle();
    print(user);
    if (user != null) {
      final user = UserService.auth.currentUser;
      if (user != null) {
        final createdUser = UserE(
          id: user.uid,
          geoStatus: true,
          displayName: user.displayName ?? "Name",
          subscribedUsers: [],
          imageUrl: user.photoURL,
        );
        await UserService.saveUserToFirestore(createdUser);

        Future.microtask(
          () => Navigator.pushNamed(context, MainNavigationScreens.mainScreen),
        );
      }
    }
  }
}
