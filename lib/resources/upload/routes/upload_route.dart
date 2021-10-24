import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crud_api/services/supabase_service.dart';
import 'package:crud_api/utils/jwt_helper.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';
import 'package:shelf_multipart/form_data.dart';

FutureOr<Response> avatar(Request req) async {
  final check = accessTokenChecker(req);

  if (check.containsKey('error')) {
    return Response(
      400,
      body: jsonEncode({'message': check['error']}),
    );
  } else {
    if (req.isMultipartForm) {
      final sb = Modular.get<SupabaseService>();

      final parameters = <String, dynamic>{};

      await for (final form in req.multipartFormData) {
        if (form.name == 'image') {
          parameters['image'] = {
            'bytes': await form.part.readBytes(),
            'filename': form.filename,
          };
        } else {
          parameters[form.name] = await form.part.readString();
        }
      }

      if (parameters.containsKey('image')) {
        try {
          final bytes = parameters['image']['bytes'] as Uint8List;
          final filename = parameters['image']['filename'] as String;
          final sufix = filename.split('.').last;

          if (!validImage(sufix)) {
            return Response(
              400,
              body: jsonEncode({
                'message': 'this image format is no supported',
              }),
            );
          }

          final name = '${DateTime.now().millisecondsSinceEpoch}.$sufix';
          final file = File('./uploads/$name');

          await file.writeAsBytes(bytes);

          await sb.client.storage.from('images').upload(name, file);

          final download =
              await sb.client.storage.from('images').getPublicUrl(name);

          await file.delete();

          final url = Uri.parse(download.data!);

          final update = await sb.client
              .from('users')
              .update({'image': url.toString(), 'updated_at': 'now()'})
              .eq('uid', check['uid'])
              .execute();

          if (update.error != null) {
            return Response(
              400,
              body: jsonEncode({'message': update.error!.message}),
            );
          } else {
            return Response(
              200,
              body: jsonEncode({'message': 'user avatar updated'}),
            );
          }
        } on Exception catch (e) {
          print(e);
          return Response(
            500,
            body: jsonEncode(
                {'message': 'fail to upload image, try again later'}),
          );
        }
      } else {
        return Response(
          400,
          body: jsonEncode({'message': 'image not provided'}),
        );
      }
    } else {
      return Response(
        400,
        body: jsonEncode({'message': 'only multipart allowed'}),
      );
    }
  }
}

bool validImage(String str) =>
    str.toLowerCase() == 'jpeg' ||
    str.toLowerCase() == 'jpg' ||
    str.toLowerCase() == 'png';
