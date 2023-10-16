import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:bcrypt/bcrypt.dart';

import '../db.dart' as db;
import '../models/user.dart';

Future<Response?> signup(Request request) async {
  var body = json.decode(await request.readAsString());
  // validate request body parameters
  if (body['name'] != null &&
      body['username'] != null &&
      body['password'] != null) {
    // username must be unique
    var check =
        await db.findOne("users", where.eq('username', body['username']));
    if (check['error']) {
      return Response(500,
          body: '{"message": "Error occurred during creating a new user"}',
          headers: {'content-type': 'application/json'});
    }
    if (check['res'] == null) {
      final hashed_password = BCrypt.hashpw(
        body['password'],
        BCrypt.gensalt(),
      );
      var user = User(body['name'], body['username'], hashed_password, null);
      final res = await db.insert("users", user.toJson());
      return (res['error'])
          ? Response(500,
              body: '{"message": "Error occurred during creating a new user"}',
              headers: {'content-type': 'application/json'})
          : Response(201,
              body: '{"message": "Username created successfully"}',
              headers: {'content-type': 'application/json'});
    } else {
      return Response(422,
          body: '{"message": "Username already taken"}',
          headers: {'content-type': 'application/json'});
    }
  } else {
    return Response(422,
        body: '{"message": "Invalid request payload"}',
        headers: {'content-type': 'application/json'});
  }
}
