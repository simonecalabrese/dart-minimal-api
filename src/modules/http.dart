import 'package:shelf/shelf.dart';

Response jsonResponse(int statusCode, Object? body) {
  return Response(
    statusCode,
    body: body,
    headers: {'content-type': 'application/json'},
  );
}
