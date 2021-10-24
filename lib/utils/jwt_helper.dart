import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

String accessTokenGenerate(String uid) {
  final jwt = JWT({'uid': uid, 'issuer': 'dev.tihrasguinho'});

  return jwt.sign(
    SecretKey('AccessTokenHash'),
    expiresIn: Duration(hours: 1),
  );
}

String refreshTokenGenerate(String uid) {
  final jwt = JWT({'uid': uid, 'issuer': 'dev.tihrasguinho'});

  return jwt.sign(
    SecretKey('RefreshTokenHash'),
    expiresIn: Duration(days: 7),
  );
}

Map refreshTokenChecker(Request req) {
  try {
    final authorization = req.headers['authorization'];

    if (authorization == null) {
      return {'error': 'jwt not provided'};
    }

    final splited = authorization.split(' ');

    if (splited.length != 2 ||
        splited[0] != 'Bearer' ||
        splited[1].isEmpty ||
        splited[1].length != 225) {
      return {'error': 'jwt invalid or malformed'};
    }

    final jwt = JWT.verify(splited[1], SecretKey('RefreshTokenHash'));

    return jwt.payload;
  } on JWTExpiredError {
    print('jwt expired');

    return {'error': 'jwt expired'};
  } on JWTError catch (ex) {
    print(ex.message); // ex: invalid signature
    return {'error': ex.message};
  }
}

Map accessTokenChecker(Request req) {
  try {
    final authorization = req.headers['authorization'];

    if (authorization == null) {
      return {'error': 'jwt not provided'};
    }

    final splited = authorization.split(' ');

    if (splited.length != 2 ||
        splited[0] != 'Bearer' ||
        splited[1].isEmpty ||
        splited[1].length != 225) {
      return {'error': 'jwt invalid or malformed'};
    }

    final jwt = JWT.verify(splited[1], SecretKey('AccessTokenHash'));

    return jwt.payload;
  } on JWTExpiredError {
    print('jwt expired');

    return {'error': 'jwt expired'};
  } on JWTError catch (ex) {
    print(ex.message); // ex: invalid signature
    return {'error': ex.message};
  }
}
