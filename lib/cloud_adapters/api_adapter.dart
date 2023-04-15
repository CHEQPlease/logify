import 'package:logify/interfaces/cloud_adapter.dart';

class ApiAdapter implements CloudAdapter {
  final String url;

  ApiAdapter(this.url);

  @override
  init() {
    throw UnimplementedError();
  }

  @override
  sync() {
    throw UnimplementedError();
  }
}