import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestStoragePermission() async {
    try {
      var status = await Permission.storage.status;
      if (status.isGranted) return true;
      status = await Permission.storage.request();
      return status.isGranted;
    } catch (_) {
      return true;
    }
  }

  Future<bool> requestAudioPermission() async {
    try {
      var status = await Permission.audio.status;
      if (status.isGranted) return true;
      status = await Permission.audio.request();
      return status.isGranted;
    } catch (_) {
      return true;
    }
  }

  Future<bool> hasPermissions() async => true;
}