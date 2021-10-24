import 'package:crud_api/resources/users/routes/me_route.dart';
import 'package:crud_api/resources/users/routes/users_route.dart';
import 'package:shelf_modular/shelf_modular.dart';

class UsersResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/get', users),
        Route.get('/me', me),
      ];
}
