import 'package:crud_api/resources/auth/routes/refresh_route.dart';
import 'package:crud_api/resources/auth/routes/signin_route.dart';
import 'package:crud_api/resources/auth/routes/signup_routet.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AuthResource extends Resource {
  @override
  List<Route> get routes => [
        Route.post('/signin', signIn),
        Route.post('/signup', signUp),
        Route.get('/refresh', refresh),
      ];
}
