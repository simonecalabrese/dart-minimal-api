import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../modules/db.dart' as db;
import '../modules/http.dart';
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
      return jsonResponse(
          500, '{"message": "Error occurred during creating a new user"}');
    }
    if (check['res'] == null) {
      final hashed_password = BCrypt.hashpw(
        body['password'],
        BCrypt.gensalt(),
      );
      var user = User(body['name'], body['username'], hashed_password, null);
      final res = await db.insert("users", user.toJson());
      return (res['error'])
          ? jsonResponse(
              500, '{"message": "Error occurred during creating a new user"}')
          : jsonResponse(
              201,
              '{"message": "Username created successfully"}',
            );
    } else {
      return jsonResponse(
        422,
        '{"message": "Username already taken"}',
      );
    }
  } else {
    return jsonResponse(
      422,
      '{"message": "Invalid request payload"}',
    );
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
      return jsonResponse(
        500,
        '{"message": "Error occurred during login"}',
      );
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
        return jsonResponse(
          200,
          '{"message": "User logged in successfully", "token": "$token", "user": ${json.encode(user)}}',
        );
      } else {
        return jsonResponse(
          401,
          '{"message": "Password incorrect"}',
        );
      }
    } else {
      return jsonResponse(
        400,
        '{"message": "User does not exists"}',
      );
    }
  } else {
    return jsonResponse(
      422,
      '{"message": "Invalid request payload"}',
    );
  }
}

Future<Response?> getProfile(Request request) async {
  var token = request.headers['Authorization'];
  if (token != null) {
    token = token.split(" ")[1];
    try {
      final jwt = JWT.verify(token, SecretKey(jwt_secret_passphrase));
      final user = await db.findOne(
          "users", where.eq('username', jwt.payload['username']));
      return jsonResponse(
        200,
        '{"user": ${json.encode(user['res'])}}',
      );
    } catch (e) {
      return jsonResponse(
        401,
        '{"message": "Unauthorized"}',
      );
    }
  } else {
    return jsonResponse(
      401,
      '{"message": "Unauthorized"}',
    );
  }
}
