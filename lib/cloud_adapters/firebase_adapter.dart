import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logify/interfaces/cloud_adapter.dart';
import 'package:logify/models/log_list.dart';
import 'package:logify/utils/exception_handler.dart';

class FirebaseAdapter implements CloudAdapter {
  final String collectionName;

  FirebaseAdapter(this.collectionName);

  init() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      ExceptionHandler.log('Firebase initialization error: $e');
    }
  }

  @override
  Future<bool> syncJob(List<Log> logList) async {
    try {
      await init();

      await upload(logList);

      return Future.value(true);
    } catch (e) {
      ExceptionHandler.log('Firebase sync failed: $e');

      return Future.value(false);
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
        ExceptionHandler.log('Firebase upload failed: $e');
      });
    } catch (e) {
      ExceptionHandler.log('Firebase error: $e');
    }
  }
}
