// Mocks generated by Mockito 5.0.16 from annotations
// in lichee/test/screens/auth/auth_screen_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:firebase_auth/firebase_auth.dart' as _i2;
import 'package:lichee/models/user_data.dart' as _i5;
import 'package:lichee/providers/authentication_provider.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeUserCredential_0 extends _i1.Fake implements _i2.UserCredential {}

/// A class which mocks [AuthenticationProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationProvider extends _i1.Mock
    implements _i3.AuthenticationProvider {
  MockAuthenticationProvider() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<_i2.User?> get authState =>
      (super.noSuchMethod(Invocation.getter(#authState),
          returnValue: Stream<_i2.User?>.empty()) as _i4.Stream<_i2.User?>);
  @override
  _i4.Future<_i2.UserCredential> signUp(
          {_i5.UserData? userData, String? password}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #signUp, [], {#userData: userData, #password: password}),
              returnValue:
                  Future<_i2.UserCredential>.value(_FakeUserCredential_0()))
          as _i4.Future<_i2.UserCredential>);
  @override
  _i4.Future<_i2.UserCredential> signIn({String? email, String? password}) =>
      (super.noSuchMethod(
          Invocation.method(#signIn, [], {#email: email, #password: password}),
          returnValue:
              Future<_i2.UserCredential>.value(_FakeUserCredential_0())) as _i4
          .Future<_i2.UserCredential>);
  @override
  _i4.Future<void> signOut() =>
      (super.noSuchMethod(Invocation.method(#signOut, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  String toString() => super.toString();
}
