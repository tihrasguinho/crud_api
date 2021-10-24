import 'dart:io';

import 'package:crud_api/app_module.dart';
import 'package:shelf_modular/shelf_modular.dart';
import 'package:shelf/shelf_io.dart' as io;

void main(List<String> arguments) async {
  final port = Platform.environment['PORT'];

  final server = await io.serve(
    Modular(module: AppModule()),
    '0.0.0.0',
    int.tryParse(port!) ?? 8080,
  );
  print('Server started: ${server.address.address}:${server.port}');
}
