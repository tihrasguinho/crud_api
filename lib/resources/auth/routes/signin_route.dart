import 'dart:async';
import 'dart:convert';

import 'package:crud_api/services/supabase_service.dart';
import 'package:crud_api/utils/email_checker.dart';
import 'package:crud_api/utils/jwt_helper.dart';
import 'package:crud_api/utils/password_encrypt.dart';
import 'package:crud_api/utils/signin_checker.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

FutureOr<Response> signIn(ModularArguments args) async {
  final sb = Modular.get<SupabaseService>();

  final data = args.data as Map;

  if (signInChecker(data)) {
    if (emailValid(data['email'])) {
      final query = await sb.client
          .from('users')
          .select()
          .eq('email', data['email'])
          .execute();

      final result = query.data as List;

      if (result.isNotEmpty) {
        final user = result[0] as Map;

        if (user['password'] == passwordEncrypt(data['password'])) {
          user['access_token'] = accessTokenGenerate(user['uid']);

          user['refresh_token'] = refreshTokenGenerate(user['uid']);

          await sb.client
              .from('users')
              .update({'last_connection': 'now()'})
              .eq('email', data['email'])
              .execute();

          return Response(
            200,
            body: jsonEncode({
              'message': 'signed in successfull',
              'user': user
                ..remove('password')
                ..remove('last_connection'),
            }),
          );
        } else {
          return Response(
            400,
            body: jsonEncode({'message': 'wrong password'}),
          );
        }
      } else {
        return Response(
          404,
          body: jsonEncode({'message': 'user not found'}),
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
