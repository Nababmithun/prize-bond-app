import 'package:flutter/foundation.dart';
import '../repositories/change_password_repository.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final ChangePasswordRepository _repo;
  ChangePasswordViewModel(this._repo);

  bool _loading = false;
  bool get isLoading => _loading;

  String? message;

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _loading = true;
    notifyListeners();

    final res = await _repo.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    _loading = false;
    message = res['message'];
    notifyListeners();
    return res['ok'] == true;
  }
}
