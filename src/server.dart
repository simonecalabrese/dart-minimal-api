import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;

Future<void> main() async {
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final cascade = Cascade().add(_router);

  // https://pub.dev/documentation/shelf/latest/shelf_io/serve.html
  final server = await shelf_io.serve(
    logRequests() // https://pub.dev/documentation/shelf/latest/shelf/logRequests.html
        .addHandler(cascade.handler), // https://pub.dev/documentation/shelf/latest/shelf/MiddlewareExtensions/addHandler.html
    InternetAddress.anyIPv4, // allow external connections
    port,
  );
  print('Server listening at http://${server.address.host}:${server.port}');
}

// Router instance to handle requests.
final _router = shelf_router.Router()
  ..get('/helloworld', helloWorld);

Response helloWorld(Request request) => Response.ok("Hello world!");