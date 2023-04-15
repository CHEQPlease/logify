import 'package:logify/cloud_adapters/firebase_adapter.dart';
import 'package:logify/interfaces/storage_adapter.dart';
import 'package:logify/interfaces/sync_adapter.dart';
import 'package:logify/logify.dart';
import 'package:logify/storage_adapters/sqlite_storage_adapter.dart';
import 'package:logify/sync_adapters/alarm_manager_sync_adapter.dart';

void main() {
  StorageAdapter storageAdapter = SQLiteStorageAdapter();
  SyncAdapter syncAdapter = AlarmManagerSyncAdapter(const Duration(seconds: 10), FirebaseAdapter('CheqLog'));
  Logify.init(storageAdapter, syncAdapter);
}
