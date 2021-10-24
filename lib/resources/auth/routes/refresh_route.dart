import 'dart:async';
import 'dart:convert';

import 'package:crud_api/utils/jwt_helper.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

FutureOr<Response> refresh(Request req, ModularArguments args) async {
  final result = refreshTokenChecker(req);

  if (result.containsKey('error')) {
    return Response(
      400,
      body: jsonEncode({'message': result['error']}),
    );
  } else {
    final accessToken = accessTokenGenerate(result['uid']);

    return Response(
      200,
      body: jsonEncode({
        'message': 'access token refreshed',
        'access_token': accessToken,
      }),
    );
  }
}
