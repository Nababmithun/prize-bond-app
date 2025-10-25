import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Monitors internet connectivity + simple DNS reachability check,
/// and shows a blocking "No Internet" dialog until connectivity is restored.
///
/// How to use:
///   InternetChecker.startListening(context);
///   ...
///   InternetChecker.dispose(); // e.g., on app exit
class InternetChecker {
  InternetChecker._();

  static final Connectivity _connectivity = Connectivity();
  static StreamSubscription<ConnectivityResult>? _subscription;

  /// Prevents multiple dialogs.
  static bool _dialogShown = false;

  /// Begin listening to connectivity changes.
  /// Safe to call once (subsequent calls are ignored).
  static void startListening(BuildContext context) {
    // Prevent double subscription
    if (_subscription != null) return;

    // Delay so that navigator/context is ready (esp. on splash)
    Future.delayed(const Duration(seconds: 1), () async {
      // Initial manual check
      await _manualCheck(context);

      // Subscribe to connectivity changes
      _subscription = _connectivity.onConnectivityChanged.listen(
            (ConnectivityResult result) async {
          final offline = await _isOffline(result);
          if (offline) {
            _showNoInternetDialog(context);
          } else {
            // Close dialog if open
            if (_dialogShown) {
              final navigator = Navigator.of(context, rootNavigator: true);
              if (navigator.canPop()) {
                navigator.pop();
              }
              _dialogShown = false;
            }
          }
        } as void Function(List<ConnectivityResult> event)?,
      ) as StreamSubscription<ConnectivityResult>?;
    });
  }

  /// Do a one-off connectivity + DNS check and show dialog if offline.
  static Future<void> _manualCheck(BuildContext context) async {
    final result = await _connectivity.checkConnectivity();
    final offline = await _isOffline(result as ConnectivityResult);
    if (offline) {
      _showNoInternetDialog(context);
    }
  }

  /// Consider offline if:
  ///  - No network (ConnectivityResult.none), OR
  ///  - DNS lookup to example.com fails or times out.
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

  /// Show a blocking "No Internet" dialog.
  static void _showNoInternetDialog(BuildContext context) {
    // BuildContext.mounted is available in recent Flutter; guard anyway:
    if (_dialogShown) return;
    if (!context.mounted) return;

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
                // Icon
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

                // Title
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

                // Message
                Text(
                  'no_internet.msg'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 26),

                // Actions
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
                        icon: const Icon(Icons.exit_to_app,
                            color: Colors.redAccent),
                        label: Text(
                          'common.exit'.tr(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
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
                          final result =
                          await _connectivity.checkConnectivity();
                          final ok = !(await _isOffline(result as ConnectivityResult));
                          if (ok) {
                            // Close dialog
                            final navigator =
                            Navigator.of(context, rootNavigator: true);
                            if (navigator.canPop()) {
                              navigator.pop();
                            }
                            _dialogShown = false;
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
                            color: Colors.white,
                          ),
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

  /// Exit the app gracefully.
  static void _exitApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else {
      // iOS & others: force exit (not recommended usually)
      exit(0);
    }
  }

  /// Stop listening and clean up.
  static void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _dialogShown = false;
  }
}
