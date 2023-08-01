import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:logify/interfaces/cloud_adapter.dart';
import 'package:logify/interfaces/sync_adapter.dart';
import 'package:logify/logify.dart';
import 'package:logify/models/log_list.dart';
import 'package:logify/utils/exception_handler.dart';

/// An implementation of [SyncAdapter] to sync logs from storage with cloud using [AndroidAlarmManager]
class AlarmManagerSyncAdapter extends SyncAdapter {
  AlarmManagerSyncAdapter();

  @override
  Future<void> init(Duration syncInterval, Function syncCallback) async {
    try {
      await AndroidAlarmManager.initialize();

      await AndroidAlarmManager.periodic(syncInterval, 0, syncCallback, rescheduleOnReboot: true, allowWhileIdle: true);
    } catch (e) {
      ExceptionHandler.log('AlarmManagerSyncAdapter initialization error: $e');
    }
  }

  @override
  Future<void> cloudSync(CloudAdapter cloudAdapter) async {
    try {
      List<Log> logList = await Logify.getOutOfSyncLogs();

      if (logList.isEmpty) return;

      await cloudAdapter.syncJob(logList).then((value) async {
        if (value) {
          await cleanJob(logList);
        }
      });
    } catch (e) {
      ExceptionHandler.log('AlarmManagerSyncAdapter sync error: $e');
    }
  }

  @override
  Future<void> cleanJob(List<Log>? logList) async {
    try {
      if (logList == null) return;

      await Logify.updateAsSynced(logList);
      await Logify.clearSynced();
    } catch (e) {
      ExceptionHandler.log('AlarmManagerSyncAdapter clean job error: $e');
    }
  }
}
