import 'package:senly/application/domain/services/auth_service.dart';

class UserScreenModel {
  final _authService = AuthService();

  void signOut() async {
    await _authService.signOut();
  }
}
