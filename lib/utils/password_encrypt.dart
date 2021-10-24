import 'dart:convert';

import 'package:crypto/crypto.dart';

String passwordEncrypt(String str) {
  final hash = Hmac(sha256, utf8.encode('PASSWORD_HASH'));
  final digest = hash.convert(utf8.encode(str));
  return digest.toString();
}
