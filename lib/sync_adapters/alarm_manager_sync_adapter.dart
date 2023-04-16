import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:logify/interfaces/cloud_adapter.dart';
import 'package:logify/interfaces/sync_adapter.dart';
import 'package:logify/logify.dart';

/// An implementation of [SyncAdapter] to sync logs from storage with cloud using [AndroidAlarmManager]
class AlarmManagerSyncAdapter extends SyncAdapter {
  final CloudAdapter _cloudAdapter;

  AlarmManagerSyncAdapter(this._cloudAdapter);

  @override
  Future<void> init(Duration syncInterval, Function syncCallback) async {
    try {
      await AndroidAlarmManager.initialize();

      await AndroidAlarmManager.periodic(syncInterval, 0, syncCallback, rescheduleOnReboot: true);
    } catch (e) {
      throw ('AlarmManagerSyncAdapter error: $e');
    }
  }

  @override
  Future<void> sync() async {
    try {
      await _cloudAdapter
        .sync(await Logify.getOutOfSyncLogs())
        .then((value) async {
      if (value) {
        await clear();
      }
    });
    } catch (e) {
      throw ('AlarmManagerSyncAdapter sync error: $e');
    }
  }

  @override
  Future<void> clear() async {
    try {
      await Logify.clearSynced();
    } catch (e) {
      rethrow;
    }
  }
}