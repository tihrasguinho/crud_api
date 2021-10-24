import 'package:crud_api/resources/upload/routes/upload_route.dart';
import 'package:shelf_modular/shelf_modular.dart';

class UploadResource extends Resource {
  @override
  List<Route> get routes => [
        Route.post('/avatar', avatar),
      ];
}
