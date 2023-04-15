import 'package:firebase_core/firebase_core.dart';
import 'package:logify/interfaces/cloud_adapter.dart';

class FirebaseAdapter implements CloudAdapter {
  final String collectionName;

  FirebaseAdapter(this.collectionName);

  @override
  init() async {
    await Firebase.initializeApp();
  }

  @override
  sync() async {
    await init();
  }
}
