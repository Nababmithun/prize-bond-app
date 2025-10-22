import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

class InternetChecker {
  static final Connectivity _connectivity = Connectivity();
  static StreamSubscription<ConnectivityResult>? _subscription;
  static bool _dialogShown = false;

  static void startListening(BuildContext context) {
    // Prevent double subscription
    if (_subscription != null) return;

    // ✅ Delay 1s so context is mounted (important for splash)
    Future.delayed(const Duration(seconds: 1), () async {
      await _manualCheck(context);

      _subscription = _connectivity.onConnectivityChanged.listen((result) async {
        if (result == null) return;

        final offline = await _isOffline(result as ConnectivityResult);
        if (offline) {
          _showNoInternetDialog(context);
        } else {
          if (_dialogShown && Navigator.canPop(context)) {
            Navigator.of(context, rootNavigator: true).pop();
            _dialogShown = false;
          }
        }
      }) as StreamSubscription<ConnectivityResult>?;
    });
  }

  static Future<void> _manualCheck(BuildContext context) async {
    final result = await _connectivity.checkConnectivity();
    if (result == null) return;

    final offline = await _isOffline(result as ConnectivityResult);
    if (offline) {
      _showNoInternetDialog(context);
    }
  }

  static Future<bool> _isOffline(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) return true;

    try {
      final lookup = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 2));
      return lookup.isEmpty || lookup.first.rawAddress.isEmpty;
    } on SocketException {
      return true;
    } on TimeoutException {
      return true;
    }
  }

  static void _showNoInternetDialog(BuildContext context) {
    if (_dialogShown || !context.mounted) return;
    _dialogShown = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 30),
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.wifi_off_rounded,
                      size: 50, color: Colors.redAccent),
                ),
                const SizedBox(height: 20),
                Text(
                  'no_internet.title'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'no_internet.msg'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 26),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          side: const BorderSide(color: Colors.redAccent),
                        ),
                        onPressed: _exitApp,
                        icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
                        label: Text(
                          'common.exit'.tr(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () async {
                          final result = await _connectivity.checkConnectivity();
                          final ok = !(await _isOffline(result as ConnectivityResult));
                          if (ok) {
                            if (Navigator.canPop(context)) {
                              Navigator.of(context, rootNavigator: true).pop();
                              _dialogShown = false;
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('common.retry'.tr()),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        label: Text(
                          'common.retry'.tr(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _exitApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else {
      exit(0);
    }
  }

  static void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
