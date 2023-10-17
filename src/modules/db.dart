import 'dart:io' show Platform;

import 'package:mongo_dart/mongo_dart.dart';

final mongodb_host = Platform.environment['MONGO_DB_HOST'] ?? '127.0.0.1';
final mongodb_port = Platform.environment['MONGO_DB_PORT'] ?? '2717';
final mongodb_name = Platform.environment['MONGO_DB_NAME'] ?? 'dart_minimal_api';

Future<Map<String, dynamic>> findOne(String collection_name, dynamic selector) async {
  try {
    var db = Db('mongodb://$mongodb_host:$mongodb_port/$mongodb_name');
    await db.open();
    var collection = db.collection(collection_name);
    var res = await collection.findOne(selector);
    await db.close();
    return {"error": false, "res": res};
  } catch(e) {
    return {"error": true, "res": e};
  }
}


Future<Map<String, dynamic>> insert(String collection_name, Map<String, dynamic> query) async {
  try {
    var db = Db('mongodb://$mongodb_host:$mongodb_port/$mongodb_name');
    await db.open();
    var collection = db.collection(collection_name);
    var res = await collection.insert(query);
    await db.close();
    return {"error": false, "res": res};
  } catch(e) {
    return {"error": true, "res": e};
  }
}