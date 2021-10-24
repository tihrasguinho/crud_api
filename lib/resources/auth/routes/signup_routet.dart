import 'dart:async';
import 'dart:convert';

import 'package:crud_api/services/supabase_service.dart';
import 'package:crud_api/utils/email_checker.dart';
import 'package:crud_api/utils/jwt_helper.dart';
import 'package:crud_api/utils/password_encrypt.dart';
import 'package:crud_api/utils/signup_checker.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

FutureOr<Response> signUp(ModularArguments args) async {
  final sb = Modular.get<SupabaseService>();

  final data = args.data as Map;

  if (signUpChecker(data)) {
    if (emailValid(data['email'])) {
      final query = await sb.client
          .from('users')
          .select('uid')
          .eq('email', data['email'])
          .execute();

      final result = query.data as List;

      if (result.isNotEmpty) {
        return Response(
          400,
          body: jsonEncode({'message': 'email already in use'}),
        );
      } else {
        data['password'] = passwordEncrypt(data['password']);

        final insert = await sb.client.from('users').insert({
          ...data,
        }).execute();

        final user = insert.data[0] as Map;

        user['access_token'] = accessTokenGenerate(user['uid']);

        user['refresh_token'] = refreshTokenGenerate(user['uid']);

        return Response(
          200,
          body: jsonEncode({
            'message': 'signed up successfull',
            'user': user
              ..remove('password')
              ..remove('last_connection'),
          }),
        );
      }
    } else {
      return Response(
        400,
        body: jsonEncode({'message': 'email invalid'}),
      );
    }
  } else {
    return Response(
      400,
      body: jsonEncode({'message': 'user data not provided'}),
    );
  }
}
