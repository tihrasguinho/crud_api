import 'package:crud_api/consts/supabase_consts.dart';
import 'package:supabase/supabase.dart';

class SupabaseService {
  static final _client = SupabaseClient(supabaseUrl, supabaseKey);

  SupabaseClient get client => _client;
}
