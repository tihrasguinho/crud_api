import 'dart:async';
import 'dart:convert';

import 'package:crud_api/services/supabase_service.dart';
import 'package:crud_api/utils/jwt_helper.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

FutureOr<Response> me(Request req) async {
  final sb = Modular.get<SupabaseService>();

  final check = accessTokenChecker(req);

  if (check.containsKey('error')) {
    return Response(
      400,
      body: jsonEncode({'message': check['error']}),
    );
  } else {
    final query = await sb.client
        .from('users')
        .select('uid, name, email, image, created_at')
        .eq('uid', check['uid'])
        .execute();

    return Response(
      200,
      body: jsonEncode({
        'message': 'current user',
        'user': query.data[0],
      }),
    );
  }
}
