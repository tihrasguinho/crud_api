import 'package:crud_api/app_module.dart';
import 'package:shelf_modular/shelf_modular.dart';
import 'package:shelf/shelf_io.dart' as io;

void main(List<String> arguments) async {
  final server = await io.serve(Modular(module: AppModule()), '0.0.0.0', 3000);
  print('Server started: ${server.address.address}:${server.port}');
}
