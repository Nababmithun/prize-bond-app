import 'dart:io';
import 'package:flutter/foundation.dart';

import '../repositories/ProfileRepository.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository _repo;
  ProfileViewModel(this._repo);

  //  State Variables
  bool _loading = false;
  bool get isLoading => _loading;

  Map<String, dynamic>? user;
  List<Map<String, dynamic>> bonds = [];
  String? message;

  // Load Only Profile (used in EditProfileView)
  Future<void> loadProfile() async {
    _loading = true;
    notifyListeners();

    final res = await _repo.getProfile();

    _loading = false;
    if (res['ok'] == true) {
      user = res['user'];
    } else {
      message = res['message'];
    }

    notifyListeners();
  }

  //  Load Profile + Bonds Together (used in ProfileView)
  Future<void> loadProfileAndBonds() async {
    _loading = true;
    notifyListeners();

    final profileRes = await _repo.getProfile();
    final bondsRes = await _repo.getPrizeBonds();

    _loading = false;

    // Handle profile
    if (profileRes['ok'] == true) {
      user = profileRes['user'];
    } else {
      message = profileRes['message'];
    }

    // Handle bonds
    if (bondsRes['ok'] == true) {
      bonds = List<Map<String, dynamic>>.from(bondsRes['bonds']);
    } else {
      message = bondsRes['message'];
    }

    notifyListeners();
  }

  //  Update Profile
  Future<bool> updateProfile({
    required String name,
    required String phone,
    required String nid,
    File? image,
  }) async {
    _loading = true;
    notifyListeners();

    final res = await _repo.updateProfile(
      name: name,
      phone: phone,
      nid: nid,
      image: image,
    );

    _loading = false;
    message = res['message'];

    if (res['ok'] == true) {
      user = res['user'];
    }

    notifyListeners();
    return res['ok'] == true;
  }
}
