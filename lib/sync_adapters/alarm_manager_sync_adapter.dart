import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:logify/interfaces/cloud_adapter.dart';
import 'package:logify/interfaces/sync_adapter.dart';

/// An implementation of [SyncAdapter] to sync logs from storage with cloud using [AndroidAlarmManager]
class AlarmManagerSyncAdapter extends SyncAdapter {
  final Duration _syncInterval;
  final CloudAdapter _cloudAdapter;

  AlarmManagerSyncAdapter(this._syncInterval, this._cloudAdapter);

  @override
  Future<void> init() async {
    await AndroidAlarmManager.initialize();

    await AndroidAlarmManager.periodic(_syncInterval, 0, sync, rescheduleOnReboot: true);
  }

  @override
  Future<void> sync() async {
    await _cloudAdapter.sync();

    // todo clean job
  }

  @override
  Future<void> clear() {
    throw UnimplementedError();
  }
}