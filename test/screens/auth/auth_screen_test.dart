import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/models/user_data.dart';
import 'package:lichee/providers/authentication_provider.dart';
import 'package:lichee/screens/auth/role.dart';
import 'package:lichee/screens/auth/screens/auth_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../setup/auth_mock_setup/mock_user_credential.dart';
import 'auth_screen_test.mocks.dart';

@GenerateMocks([AuthenticationProvider])
void main() {
  group('AuthScreen', () {
    final mockAuthenticationProvider = MockAuthenticationProvider();

    testWidgets('check rendering and auth type changing', (tester) async {
      const authScreen = MaterialApp(
        home: Scaffold(
          body: AuthScreen(),
        ),
      );

      await tester.pumpWidget(authScreen);

      expect(find.byKey(const Key('firstNameField')), findsNothing);
      expect(find.byKey(const Key('emailField')), findsOneWidget);
      expect(find.byKey(const Key('dateOfBirthField')), findsNothing);
      expect(find.byKey(const Key('passwordField')), findsOneWidget);
      expect(find.byKey(const Key('confirmPasswordField')), findsNothing);
      expect(find.byKey(const Key('authorizeButton')), findsOneWidget);
      expect(find.byKey(const Key('authTypeChanger')), findsOneWidget);

      await tester.tap(find.text('Sign up'));

      await tester.pump();

      expect(find.byKey(const Key('firstNameField')), findsOneWidget);
      expect(find.byKey(const Key('emailField')), findsOneWidget);
      expect(find.byKey(const Key('dateOfBirthField')), findsOneWidget);
      expect(find.byKey(const Key('passwordField')), findsOneWidget);
      expect(find.byKey(const Key('confirmPasswordField')), findsOneWidget);
      expect(find.byKey(const Key('authorizeButton')), findsOneWidget);
      expect(find.byKey(const Key('authTypeChanger')), findsOneWidget);
    });

    group('sign in', () {
      when(mockAuthenticationProvider.signIn(
              email: 'testEmail@test.com', password: 'testPassword'))
          .thenAnswer((_) async => MockUserCredential(false));
      when(mockAuthenticationProvider.signIn(
              email: 'invalidEmail@test.com', password: 'testPassword'))
          .thenThrow(FirebaseAuthException(code: 'invalid-email'));
      when(mockAuthenticationProvider.signIn(
              email: 'wrongPassword@test.com', password: 'testPassword'))
          .thenThrow(FirebaseAuthException(code: 'wrong-password'));
      when(mockAuthenticationProvider.signIn(
              email: 'userNotFound@test.com', password: 'testPassword'))
          .thenThrow(FirebaseAuthException(code: 'user-not-found'));
      when(mockAuthenticationProvider.signIn(
              email: 'userDisabled@test.com', password: 'testPassword'))
          .thenThrow(FirebaseAuthException(code: 'user-disabled'));
      when(mockAuthenticationProvider.signIn(
              email: 'tooManyRequests@test.com', password: 'testPassword'))
          .thenThrow(FirebaseAuthException(code: 'too-many-requests'));
      when(mockAuthenticationProvider.signIn(
              email: 'operationNotAllowed@test.com', password: 'testPassword'))
          .thenThrow(FirebaseAuthException(code: 'operation-not-allowed'));
      when(mockAuthenticationProvider.signIn(
              email: 'undefined@test.com', password: 'testPassword'))
          .thenThrow(FirebaseAuthException(code: 'undefined'));

      testWidgets('check inputs and validation works correctly',
          (tester) async {
        final authScreen = Provider<AuthenticationProvider>(
          create: (context) => mockAuthenticationProvider,
          child: const MaterialApp(
            home: Scaffold(
              body: AuthScreen(),
            ),
          ),
        );

        await tester.pumpWidget(authScreen);

        await tester.enterText(
            find.byKey(const Key('emailField')), 'testEmail');
        await tester.enterText(
            find.byKey(const Key('passwordField')), 'testPassword');

        await tester.tap(find.byKey(const Key('authorizeButton')));

        await tester.pumpAndSettle();

        verifyNever(mockAuthenticationProvider.signIn(
            email: 'testEmail', password: 'testPassword'));

        await tester.enterText(
            find.byKey(const Key('emailField')), 'testEmail@test.com');
        await tester.enterText(
            find.byKey(const Key('passwordField')), 'testPassword');

        await tester.tap(find.byKey(const Key('authorizeButton')));

        await tester.pumpAndSettle();

        verify(mockAuthenticationProvider.signIn(
                email: 'testEmail@test.com', password: 'testPassword'))
            .called(1);
      });

      testWidgets('check firebase auth exceptions', (tester) async {
        final authScreen = Provider<AuthenticationProvider>(
          create: (context) => mockAuthenticationProvider,
          child: const MaterialApp(
            home: Scaffold(
              body: AuthScreen(),
            ),
          ),
        );

        await tester.pumpWidget(authScreen);

        // invalid email
        await tester.enterText(
            find.byKey(const Key('emailField')), 'invalidEmail@test.com');
        await tester.enterText(
            find.byKey(const Key('passwordField')), 'testPassword');
        await tester.tap(find.byKey(const Key('authorizeButton')));
        expect(
            tester
                .state<AuthScreenState>(find.byType(AuthScreen))
                .errorMessage!,
            'Your email address appears to be malformed.');

        // wrong password
        await tester.enterText(
            find.byKey(const Key('emailField')), 'wrongPassword@test.com');
        await tester.tap(find.byKey(const Key('authorizeButton')));
        expect(
            tester
                .state<AuthScreenState>(find.byType(AuthScreen))
                .errorMessage!,
            'Your password is wrong.');

        // user not found
        await tester.enterText(
            find.byKey(const Key('emailField')), 'userNotFound@test.com');
        await tester.tap(find.byKey(const Key('authorizeButton')));
        expect(
            tester
                .state<AuthScreenState>(find.byType(AuthScreen))
                .errorMessage!,
            'User with this email doesn\'t exist.');

        // user disabled
        await tester.enterText(
            find.byKey(const Key('emailField')), 'userDisabled@test.com');
        await tester.tap(find.byKey(const Key('authorizeButton')));
        expect(
            tester
                .state<AuthScreenState>(find.byType(AuthScreen))
                .errorMessage!,
            'User with this email has been disabled.');

        // too many requests
        await tester.enterText(
            find.byKey(const Key('emailField')), 'tooManyRequests@test.com');
        await tester.tap(find.byKey(const Key('authorizeButton')));
        expect(
            tester
                .state<AuthScreenState>(find.byType(AuthScreen))
                .errorMessage!,
            'Too many requests.');

        // operation not allowed
        await tester.enterText(find.byKey(const Key('emailField')),
            'operationNotAllowed@test.com');
        await tester.tap(find.byKey(const Key('authorizeButton')));
        expect(
            tester
                .state<AuthScreenState>(find.byType(AuthScreen))
                .errorMessage!,
            'Signing in with email and password is not enabled.');

        // undefined code
        await tester.enterText(
            find.byKey(const Key('emailField')), 'undefined@test.com');
        await tester.tap(find.byKey(const Key('authorizeButton')));
        expect(
            tester
                .state<AuthScreenState>(find.byType(AuthScreen))
                .errorMessage!,
            'An undefined error has occurred.');
      });
    });

    group('sign up', () {
      when(mockAuthenticationProvider.signUp(
        userData: UserData(
          username: 'testFirstName',
          email: 'testEmail@test.com',
          role: Role.normalUser,
          dateOfBirth: DateTime(2000),
        ),
        password: 'testPassword',
      )).thenAnswer((_) async => MockUserCredential(false));
      when(mockAuthenticationProvider.signUp(
        userData: UserData(
          username: 'testFirstName',
          email: 'invalidEmail@test.com',
          role: Role.normalUser,
          dateOfBirth: DateTime(2000),
        ),
        password: 'testPassword',
      )).thenThrow(FirebaseAuthException(code: 'invalid-email'));
      when(mockAuthenticationProvider.signUp(
        userData: UserData(
          username: 'testFirstName',
          email: 'wrongPassword@test.com',
          role: Role.normalUser,
          dateOfBirth: DateTime(2000),
        ),
        password: 'testPassword',
      )).thenThrow(FirebaseAuthException(code: 'wrong-password'));
      when(mockAuthenticationProvider.signUp(
        userData: UserData(
          username: 'testFirstName',
          email: 'userNotFound@test.com',
          role: Role.normalUser,
          dateOfBirth: DateTime(2000),
        ),
        password: 'testPassword',
      )).thenThrow(FirebaseAuthException(code: 'user-not-found'));
      when(mockAuthenticationProvider.signUp(
        userData: UserData(
          username: 'testFirstName',
          email: 'userDisabled@test.com',
          role: Role.normalUser,
          dateOfBirth: DateTime(2000),
        ),
        password: 'testPassword',
      )).thenThrow(FirebaseAuthException(code: 'user-disabled'));
      when(mockAuthenticationProvider.signUp(
        userData: UserData(
          username: 'testFirstName',
          email: 'tooManyRequests@test.com',
          role: Role.normalUser,
          dateOfBirth: DateTime(2000),
        ),
        password: 'testPassword',
      )).thenThrow(FirebaseAuthException(code: 'too-many-requests'));
      when(mockAuthenticationProvider.signUp(
        userData: UserData(
          username: 'testFirstName',
          email: 'operationNotAllowed@test.com',
          role: Role.normalUser,
          dateOfBirth: DateTime(2000),
        ),
        password: 'testPassword',
      )).thenThrow(FirebaseAuthException(code: 'operation-not-allowed'));
      when(mockAuthenticationProvider.signUp(
        userData: UserData(
          username: 'testFirstName',
          email: 'undefined@test.com',
          role: Role.normalUser,
          dateOfBirth: DateTime(2000),
        ),
        password: 'testPassword',
      )).thenThrow(FirebaseAuthException(code: 'undefined'));

      testWidgets('check inputs and validation works correctly',
          (tester) async {
        final authScreen = Provider<AuthenticationProvider>(
          create: (context) => mockAuthenticationProvider,
          child: const MaterialApp(
            home: Scaffold(
              body: AuthScreen(),
            ),
          ),
        );

        await tester.pumpWidget(authScreen);

        await tester.tap(find.text('Sign up'));
        await tester.pump();

        tester
            .state<AuthScreenState>(find.byType(AuthScreen))
            .selectedDateOfBirth = DateTime(2000);
        await tester.enterText(
            find.byKey(const Key('firstNameField')), 'testFirstName');
        await tester.enterText(
            find.byKey(const Key('emailField')), 'testEmail');
        await tester.enterText(
            find.byKey(const Key('passwordField')), 'testPassword');
        await tester.enterText(find.byKey(const Key('confirmPasswordField')),
            'testConfirmPassword');

        await tester.tap(find.byKey(const Key('authorizeButton')));

        await tester.pumpAndSettle();

        verifyNever(mockAuthenticationProvider.signUp(
          userData: UserData(
            username: 'testFirstName',
            email: 'testEmail',
            role: Role.normalUser,
            dateOfBirth: DateTime(2000),
          ),
          password: 'testPassword',
        ));

        await tester.enterText(
            find.byKey(const Key('emailField')), 'testEmail@test.com');
        await tester.enterText(
            find.byKey(const Key('confirmPasswordField')), 'testPassword');

        await tester.tap(find.byKey(const Key('authorizeButton')));

        await tester.pumpAndSettle();

        verify(mockAuthenticationProvider.signUp(
          userData: UserData(
            username: 'testFirstName',
            email: 'testEmail@test.com',
            role: Role.normalUser,
            dateOfBirth: DateTime(2000),
          ),
          password: 'testPassword',
        )).called(1);
      });

      testWidgets('check firebase auth exceptions', (tester) async {
        final authScreen = Provider<AuthenticationProvider>(
          create: (context) => mockAuthenticationProvider,
          child: const MaterialApp(
            home: Scaffold(
              body: AuthScreen(),
            ),
          ),
        );

        await tester.pumpWidget(authScreen);

        await tester.tap(find.text('Sign up'));
        await tester.pumpAndSettle();

        // invalid email
        tester
            .state<AuthScreenState>(find.byType(AuthScreen))
            .selectedDateOfBirth = DateTime(2000);
        await tester.enterText(
            find.byKey(const Key('firstNameField')), 'testFirstName');
        await tester.enterText(
            find.byKey(const Key('emailField')), 'invalidEmail@test.com');
        await tester.enterText(
            find.byKey(const Key('passwordField')), 'testPassword');
        await tester.enterText(
            find.byKey(const Key('confirmPasswordField')), 'testPassword');
        await tester.tap(find.byKey(const Key('authorizeButton')));
        expect(
            tester.state<AuthScreenState>(find.byType(AuthScreen)).errorMessage!,
            'Your email address appears to be malformed.');

        // wrong password
        await tester.enterText(
            find.byKey(const Key('emailField')), 'wrongPassword@test.com');
        await tester.tap(find.byKey(const Key('authorizeButton')));
        expect(
            tester.state<AuthScreenState>(find.byType(AuthScreen)).errorMessage!,
            'Your password is wrong.');

        // user not found
        await tester.enterText(
            find.byKey(const Key('emailField')), 'userNotFound@test.com');
        await tester.tap(find.byKey(const Key('authorizeButton')));
        expect(
            tester.state<AuthScreenState>(find.byType(AuthScreen)).errorMessage!,
            'User with this email doesn\'t exist.');

        // user disabled
        await tester.enterText(
            find.byKey(const Key('emailField')), 'userDisabled@test.com');
        await tester.tap(find.byKey(const Key('authorizeButton')));
        expect(
            tester.state<AuthScreenState>(find.byType(AuthScreen)).errorMessage!,
            'User with this email has been disabled.');

        // too many requests
        await tester.enterText(
            find.byKey(const Key('emailField')), 'tooManyRequests@test.com');
        await tester.tap(find.byKey(const Key('authorizeButton')));
        expect(
            tester.state<AuthScreenState>(find.byType(AuthScreen)).errorMessage!,
            'Too many requests.');

        // operation not allowed
        await tester.enterText(
            find.byKey(const Key('emailField')), 'operationNotAllowed@test.com');
        await tester.tap(find.byKey(const Key('authorizeButton')));
        expect(
            tester.state<AuthScreenState>(find.byType(AuthScreen)).errorMessage!,
            'Signing in with email and password is not enabled.');

        // undefined code
        await tester.enterText(
            find.byKey(const Key('emailField')), 'undefined@test.com');
        await tester.tap(find.byKey(const Key('authorizeButton')));
        expect(
            tester.state<AuthScreenState>(find.byType(AuthScreen)).errorMessage!,
            'An undefined error has occurred.');
      });
    });
  });
}
