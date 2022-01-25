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

        await tester.pump();

        verifyNever(mockAuthenticationProvider.signIn(
            email: 'testEmail', password: 'testPassword'));

        await tester.enterText(
            find.byKey(const Key('emailField')), 'testEmail@test.com');
        await tester.enterText(
            find.byKey(const Key('passwordField')), 'testPassword');

        await tester.tap(find.byKey(const Key('authorizeButton')));

        await tester.pump();

        verify(mockAuthenticationProvider.signIn(
                email: 'testEmail@test.com', password: 'testPassword'))
            .called(1);
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

        await tester.pump();

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

        await tester.pump();

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
    });
  });
}
