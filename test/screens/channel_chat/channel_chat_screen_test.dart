import 'dart:io';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lichee/models/user_data.dart';
import 'package:lichee/screens/channel_chat/channel_chat_screen.dart';
import 'package:lichee/screens/channel_chat/message_bubble.dart';
import 'package:lichee/services/storage_service.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../setup/storage_mock_setup/firebase_storage_mocks_base.dart';

void main() {
  group('ChannelChatScreen', () {
    testWidgets('matches golden file', (tester) async {
      final _firestore = FakeFirebaseFirestore();
      final _storage = StorageService(MockFirebaseStorage());
      final _imagePicker = ImagePicker();

      final channelChatParams = ChannelChatNavigationParams(
        channelId: 'testChannelId',
        channelName: 'testChannelName',
      );

      final userData = UserData(
        id: 'testId',
        username: 'testUsername',
      );

      final channelChatWidget = ChannelChatScreen(
        userData: userData,
        data: channelChatParams,
        firestore: _firestore,
        storage: _storage,
        imagePicker: _imagePicker,
      );

      final channelChatScreen = MaterialApp(
        home: Scaffold(
          body: channelChatWidget,
        ),
      );

      await mockNetworkImagesFor(() => tester.pumpWidget(channelChatScreen));

      expectLater(
          find.byType(ChannelChatScreen),
          matchesGoldenFile(
              './../../test_resources/goldens/channel_chat_screen.png'));
    });

    testWidgets('check initial state', (tester) async {
      final _firestore = FakeFirebaseFirestore();
      final _storage = StorageService(MockFirebaseStorage());
      final _imagePicker = ImagePicker();

      final channelChatParams = ChannelChatNavigationParams(
        channelId: 'testChannelId',
        channelName: 'testChannelName',
      );

      final userData = UserData(
        id: 'testId',
        username: 'testUsername',
      );

      final channelChatWidget = ChannelChatScreen(
        userData: userData,
        data: channelChatParams,
        firestore: _firestore,
        storage: _storage,
        imagePicker: _imagePicker,
      );

      final channelChatScreen = MaterialApp(
        home: Scaffold(
          body: channelChatWidget,
        ),
      );

      await mockNetworkImagesFor(() => tester.pumpWidget(channelChatScreen));

      expect(find.byType(MessageBubble), findsNothing);
      expect(find.text('testChannelName'), findsOneWidget);

      final screenState =
          tester.state<ChannelChatScreenState>(find.byType(ChannelChatScreen));

      expect(screenState.messageText, '');
      expect(screenState.file, isNull);
      expect(screenState.imagePicker, isNotNull);
      expect(screenState.messageTextController, isNotNull);
    });

    testWidgets('chooseImageFromGallery works fine', (tester) async {
      final _firestore = FakeFirebaseFirestore();
      final _storage = StorageService(MockFirebaseStorage());
      final _imagePicker = ImagePicker();

      final channelChatParams = ChannelChatNavigationParams(
        channelId: 'testChannelId',
        channelName: 'testChannelName',
      );

      final userData = UserData(
        id: 'testId',
        username: 'testUsername',
      );

      final channelChatWidget = ChannelChatScreen(
        userData: userData,
        data: channelChatParams,
        firestore: _firestore,
        storage: _storage,
        imagePicker: _imagePicker,
      );

      final channelChatScreen = MaterialApp(
        home: Scaffold(
          body: channelChatWidget,
        ),
      );

      await tester.pumpWidget(channelChatScreen);

      final screenState =
          tester.state<ChannelChatScreenState>(find.byType(ChannelChatScreen));

      screenState.file = File('./../../test_resources/test_file.jpg');

      await tester.pumpAndSettle();

      final file = screenState.file;

      expect(find.byIcon(Icons.close_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_outlined));

      await tester.pump();

      final screenStateAfterImageClear =
          tester.state<ChannelChatScreenState>(find.byType(ChannelChatScreen));

      expect(file!.path, './../../test_resources/test_file.jpg');
      expect(screenStateAfterImageClear.file, isNull);

      expect(find.byIcon(Icons.close_outlined), findsNothing);
    });

    testWidgets('check state after attempt to send empty message',
        (tester) async {
      final _firestore = FakeFirebaseFirestore();
      final _storage = StorageService(MockFirebaseStorage());
      final _imagePicker = ImagePicker();

      final channelChatParams = ChannelChatNavigationParams(
        channelId: 'testChannelId',
        channelName: 'testChannelName',
      );

      final userData = UserData(
        id: 'testId',
        username: 'testUsername',
      );

      final channelChatWidget = ChannelChatScreen(
        userData: userData,
        data: channelChatParams,
        firestore: _firestore,
        storage: _storage,
        imagePicker: _imagePicker,
      );

      final channelChatScreen = MaterialApp(
        home: Scaffold(
          body: channelChatWidget,
        ),
      );

      await tester.pumpWidget(channelChatScreen);

      final screenState =
          tester.state<ChannelChatScreenState>(find.byType(ChannelChatScreen));

      await tester.tap(find.byIcon(Icons.arrow_forward_ios_outlined));

      await tester.pump();

      expect(find.byType(MessageBubble), findsNothing);
      expect(screenState.messageText, '');
      expect(screenState.file, isNull);
      expect(screenState.imagePicker, isNotNull);
      expect(screenState.messageTextController, isNotNull);
    });

    testWidgets('check state after attempt to send only text message',
        (tester) async {
      final _firestore = FakeFirebaseFirestore();
      final _storage = StorageService(MockFirebaseStorage());
      final _imagePicker = ImagePicker();

      final channelChatParams = ChannelChatNavigationParams(
        channelId: 'testChannelId',
        channelName: 'testChannelName',
      );

      final userData = UserData(
        id: 'testId',
        username: 'testUsername',
      );

      final channelChatWidget = ChannelChatScreen(
        userData: userData,
        data: channelChatParams,
        firestore: _firestore,
        storage: _storage,
        imagePicker: _imagePicker,
      );

      final channelChatScreen = MaterialApp(
        home: Scaffold(
          body: channelChatWidget,
        ),
      );

      await tester.pumpWidget(channelChatScreen);

      final screenState =
          tester.state<ChannelChatScreenState>(find.byType(ChannelChatScreen));

      await tester.enterText(find.byType(TextField), 'testMessage');
      expect(screenState.messageText, 'testMessage');

      expect(find.byType(MessageBubble), findsNothing);

      await tester.tap(find.byIcon(Icons.arrow_forward_ios_outlined));

      await tester.pump();

      expect(find.byType(MessageBubble), findsOneWidget);
      expect(screenState.messageText, '');
      expect(screenState.file, isNull);
      expect(screenState.imagePicker, isNotNull);
      expect(screenState.messageTextController, isNotNull);
    });

    testWidgets('check state after attempt to send only image message',
        (tester) async {
      final _firestore = FakeFirebaseFirestore();
      final _storage = StorageService(MockFirebaseStorage());
      final _imagePicker = ImagePicker();

      final channelChatParams = ChannelChatNavigationParams(
        channelId: 'testChannelId',
        channelName: 'testChannelName',
      );

      final userData = UserData(
        id: 'testId',
        username: 'testUsername',
      );

      final channelChatWidget = ChannelChatScreen(
        userData: userData,
        data: channelChatParams,
        firestore: _firestore,
        storage: _storage,
        imagePicker: _imagePicker,
      );

      final channelChatScreen = MaterialApp(
        home: Scaffold(
          body: channelChatWidget,
        ),
      );

      await mockNetworkImagesFor(() => tester.pumpWidget(channelChatScreen));

      final screenState =
          tester.state<ChannelChatScreenState>(find.byType(ChannelChatScreen));

      screenState.file = File('./../../test_resources/test_file.png');

      await tester.pump();

      expect(find.byType(ClipRRect), findsOneWidget);
      expect(find.byType(MessageBubble), findsNothing);
      expect(screenState.file, isNotNull);

      await tester.tap(find.byIcon(Icons.arrow_forward_ios_outlined));

      expect(screenState.messageText, '');
      expect(screenState.file, isNull);
      expect(screenState.imagePicker, isNotNull);
      expect(screenState.messageTextController, isNotNull);
    });
  });
}
