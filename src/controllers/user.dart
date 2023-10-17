import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../db.dart' as db;
import '../models/user.dart';

final platform_url = Platform.environment['PLATFORM_URL'] ?? 'dart-minimal-api';
final jwt_secret_passphrase =
    "Some strong password to encrypt all the generated JWTs";

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

Future<Response?> login(Request request) async {
  var body = json.decode(await request.readAsString());
  // validate request body parameters
  if (body['username'] != null && body['password'] != null) {
    // check if username has been registered
    var check =
        await db.findOne("users", where.eq('username', body['username']));
    if (check['error']) {
      return Response(500,
          body: '{"message": "Error occurred during login"}',
          headers: {'content-type': 'application/json'});
    }
    if (check['res'] != null) {
      var user = User(check['res']['name'], check['res']['username'],
          check['res']['password'], check['res']['created_at'].toString());
      final String saved_pass = user.password ?? "";
      if (BCrypt.checkpw(body['password'], saved_pass)) {
        final jwt = JWT(
          {'username': user.username},
          issuer: platform_url,
        );
        // generate jwt token signing the payload with HS256 algorithm
        final token = jwt.sign(SecretKey(jwt_secret_passphrase));
        return Response(200,
            body:
                '{"message": "User logged in successfully", "token": "$token", "user": ${json.encode(user)}}',
            headers: {'content-type': 'application/json'});
      } else {
        return Response(401,
            body: '{"message": "Password incorrect"}',
            headers: {'content-type': 'application/json'});
      }
    } else {
      return Response(400,
          body: '{"message": "User does not exists"}',
          headers: {'content-type': 'application/json'});
    }
  } else {
    return Response(422,
        body: '{"message": "Invalid request payload"}',
        headers: {'content-type': 'application/json'});
  }
}
