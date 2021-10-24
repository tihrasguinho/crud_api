import 'dart:io';

import 'package:supabase/supabase.dart';

class SupabaseService {
  static final _client = SupabaseClient(
    Platform.environment['SUPABASE_URL']!,
    Platform.environment['SUPABASE_KEY']!,
  );

  SupabaseClient get client => _client;
}
