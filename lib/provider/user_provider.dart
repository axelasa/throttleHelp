import 'package:flutter/cupertino.dart';
import 'package:trnk_ice/features/presentation/pages/auth/service/auth_service.dart';

import '../features/presentation/pages/auth/models/user_data.dart';

class UserProvider with ChangeNotifier {
  UserData? _user;
  final AuthService _auth = AuthService();

  UserData? get getUser => _user;

  Future<void> refreshUser() async {
    UserData? user = await _auth.getUserData();
    _user = user;
    notifyListeners();
  }
}
