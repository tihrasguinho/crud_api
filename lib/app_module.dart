import 'package:crud_api/resources/auth/auth_resource.dart';
import 'package:crud_api/resources/upload/upload_resource.dart';
import 'package:crud_api/resources/users/users_resource.dart';
import 'package:crud_api/services/supabase_service.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => SupabaseService()),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.resource('/auth', resource: AuthResource()),
        Route.resource('/users', resource: UsersResource()),
        Route.resource('/upload', resource: UploadResource()),
      ];
}
