import 'dart:async';
import 'dart:convert';

import 'package:crud_api/services/supabase_service.dart';
import 'package:crud_api/utils/jwt_helper.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

FutureOr<Response> users(Request req, ModularArguments args) async {
  final sb = Modular.get<SupabaseService>();

  final check = accessTokenChecker(req);

  if (check.containsKey('error')) {
    return Response(
      400,
      body: jsonEncode({'message': check['error']}),
    );
  } else {
    var data = <String, dynamic>{};

    if (args.queryParams.containsKey('uid')) {
      final query = await sb.client
          .from('users')
          .select('uid, name, email, image, created_at')
          .eq('uid', args.queryParams['uid'])
          .execute();

      data = {
        'message': 'user by uid',
        'user': query.data != null ? query.data[0] : 'user not found',
      };
    } else {
      final query = await sb.client
          .from('users')
          .select('uid, name, email, image, created_at')
          .neq('uid', check['uid'])
          .execute();

      data = {
        'message': 'list of all users',
        'user': query.data,
      };
    }

    return Response(
      200,
      body: jsonEncode(data),
    );
  }
}
