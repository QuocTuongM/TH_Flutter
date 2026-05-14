import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // Xin quyền storage
  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isGranted) return true;

    if (status.isDenied) {
      status = await Permission.storage.request();
      return status.isGranted;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return false;
  }

  // Xin quyền audio (Android 13+)
  Future<bool> requestAudioPermission() async {
    if (await Permission.audio.isGranted) return true;

    var status = await Permission.audio.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return status.isGranted;
  }

  // Kiểm tra quyền
  Future<bool> hasPermissions() async {
    final storage = await Permission.storage.isGranted;
    final audio   = await Permission.audio.isGranted;
    return storage || audio;
  }
}