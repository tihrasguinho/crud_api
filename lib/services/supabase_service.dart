import 'package:supabase/supabase.dart';

class SupabaseService {
  static final _client = SupabaseClient(
    String.fromEnvironment('SUPABASE_URL'),
    String.fromEnvironment('SUPABASE_KEY'),
  );

  SupabaseClient get client => _client;
}
