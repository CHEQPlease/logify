import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logify/interfaces/cloud_adapter.dart';
import 'package:logify/models/log_list.dart';

class FirebaseAdapter implements CloudAdapter {
  final String collectionName;

  FirebaseAdapter(this.collectionName);

  init() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> sync(List<Log> logList) async {
    try {
      await init();

      await upload(logList);

      return Future.value(true);
    } catch (e) {
      throw ('Sync failed - $e');
    }
  }

  Future<void> upload(List<Log> logList) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final CollectionReference collection =
          firestore.collection(collectionName);

      DocumentReference documentReference = collection.doc();

      LogSyncModel logSyncModel =
          LogSyncModel(logList: logList);

      await documentReference
          .set(logSyncModel.toJson(), SetOptions(merge: false))
          .whenComplete(() async {})
          .catchError((e) {
        throw e;
      });
    } catch (e) {
      rethrow;
    }
  }
}
