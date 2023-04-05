library logify;

import 'package:logify/interfaces/storage_adapter.dart';
import 'package:logify/interfaces/sync_adapter.dart';

class Logify {
  late final StorageAdapter _storageAdapter;
  late final SyncAdapter _syncAdapter;

  Logify._internal(this._storageAdapter, this._syncAdapter);

  static Logify? _instance;

  static Future<void> init(StorageAdapter storageAdapter, SyncAdapter syncAdapter) async {
    _instance ??= Logify._internal(storageAdapter, syncAdapter);
    await _instance!._storageAdapter.init();
    await _instance!._syncAdapter.init();
  }
}