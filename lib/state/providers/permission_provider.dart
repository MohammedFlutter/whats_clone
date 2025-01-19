import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final permissionNotifierProvider = StateNotifierProvider.family<
    PermissionNotifier, PermissionStatus?, Permission>(
  (ref, arg) => PermissionNotifier(permission: arg),
);

class PermissionNotifier extends StateNotifier<PermissionStatus?> {
  PermissionNotifier({required this.permission}) : super(null);
  final Permission permission;

  void getPermissionStatus() async {
    state = await permission.status;
  }

  Future<void> handlePermissionStatus({required Function() onPermissionGranted}) async {
    state = await permission.status;

    if (state == PermissionStatus.denied) {
      state = await permission.request();
    } else if (state == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
      state = await permission.status;
    }


    if (state == PermissionStatus.granted) {
      onPermissionGranted();
      return;
    }
  }
}
