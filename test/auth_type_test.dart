import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/screens/auth/auth_type.dart';

void main() {
  group('Testing Auth Type', () {

    test('AuthTypeExtension test', () {
     AuthType text = AuthType.login;
     expect(text.getName(), 'login');
     AuthType text2 = AuthType.register;
     expect(text2.getName(), 'register');
    });

    test('StringExtension test', () {
      String text = 'test';
      expect(text.capitalize(), 'Test');
    });

  });
}