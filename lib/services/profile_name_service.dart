import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileNameService {
  ProfileNameService._();

  static Future<String> loadDisplayName() async {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;

    if (user == null) {
      return 'New User';
    }

    try {
      final row = await client
          .from('profiles')
          .select('full_name')
          .eq('id', user.id)
          .maybeSingle();

      final fullName = (row?['full_name'] as String?)?.trim();
      if (fullName != null && fullName.isNotEmpty) {
        return fullName;
      }

      final email = user.email?.trim();
      if (email != null && email.isNotEmpty) {
        return email.split('@').first;
      }

      return 'New User';
    } catch (_) {
      final email = user.email?.trim();
      if (email != null && email.isNotEmpty) {
        return email.split('@').first;
      }

      return 'New User';
    }
  }
}