import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:logify/interfaces/sync_adapter.dart';

class AlarmManagerSyncAdapter extends SyncAdapter {

  @override
  Future<void> init() async {
    await AndroidAlarmManager.initialize();
  }

  @override
  Future<bool> sync() {
    throw UnimplementedError();
  }

  @override
  Future<void> clear() {
    throw UnimplementedError();
  }
}