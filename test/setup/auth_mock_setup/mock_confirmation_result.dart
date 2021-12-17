import 'package:firebase_auth/firebase_auth.dart';

class MockConfirmationResult implements ConfirmationResult {
  Function onConfirm;

  MockConfirmationResult({required this.onConfirm});

  @override
  Future<UserCredential> confirm(String verificationCode) {
    return onConfirm();
  }

  @override
  String get verificationId => throw UnimplementedError();
}