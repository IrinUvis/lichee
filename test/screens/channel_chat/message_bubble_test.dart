import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/screens/channel_chat/message_bubble.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('MessageBubble', () {
    testWidgets('matches golden file', (tester) async {
      const messageBubbleWidget = MaterialApp(
        home: Scaffold(
          body: MessageBubble(
            sender: 'testSender',
            text: 'testText',
            imageUrl: null,
            isMe: true,
          ),
        ),
      );

      await mockNetworkImagesFor(() => tester.pumpWidget(messageBubbleWidget));

      expectLater(find.byType(MessageBubble),
          matchesGoldenFile('./../../test_resources/goldens/message_bubble.png'));
    });

    group('with imageUrl', () {
      testWidgets('check messageContents when text is not empty',
          (tester) async {
        const messageBubbleWidget = MaterialApp(
          home: Scaffold(
            body: MessageBubble(
              sender: 'testSender',
              text: 'testText',
              imageUrl: 'testImageUrl',
              isMe: false,
            ),
          ),
        );

        await mockNetworkImagesFor(
            () => tester.pumpWidget(messageBubbleWidget));

        final columnFinder = find.byWidgetPredicate(
          (widget) => widget is Column && widget.children.length == 3,
        );
        expect(columnFinder, findsOneWidget);
        expect(
          tester.widget(columnFinder),
          isA<Column>().having(
            (column) => column.children,
            'children',
            isA<List<Widget>>().having(
              (children) => children[0],
              'clipRRect',
              isA<ClipRRect>().having(
                (clipRRect) => clipRRect.child,
                'Image',
                isA<Image>().having(
                  (img) => img.image,
                  'image',
                  isA<NetworkImage>().having(
                    (ni) => ni.url,
                    'imageUrl',
                    'testImageUrl',
                  ),
                ),
              ),
            ),
          ),
        );
        expect(
          tester.widget(columnFinder),
          isA<Column>().having(
            (column) => column.children,
            'children',
            isA<List<Widget>>().having(
              (children) => children[0],
              'clipRRect',
              isA<ClipRRect>().having(
                (clipRRect) => clipRRect.child,
                'Image',
                isA<Image>().having(
                  (img) => img.loadingBuilder,
                  'loadingBuilder',
                  isNotNull,
                ),
              ),
            ),
          ),
        );
      });

      testWidgets('check messageContents when text is empty', (tester) async {
        const messageBubbleWidget = MaterialApp(
          home: Scaffold(
            body: MessageBubble(
              sender: 'testSender',
              text: '',
              imageUrl: 'testImageUrl',
              isMe: false,
            ),
          ),
        );

        await mockNetworkImagesFor(
            () => tester.pumpWidget(messageBubbleWidget));

        final columnFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Column &&
              widget.children.length == 1 &&
              widget.children.last is ClipRRect,
        );
        expect(columnFinder, findsOneWidget);
        expect(
          tester.widget(columnFinder),
          isA<Column>().having(
            (column) => column.children,
            'children',
            isA<List<Widget>>().having(
              (children) => children[0],
              'clipRRect',
              isA<ClipRRect>().having(
                (clipRRect) => clipRRect.child,
                'Image',
                isA<Image>().having(
                  (img) => img.image,
                  'image',
                  isA<NetworkImage>().having(
                    (networkImg) => networkImg.url,
                    'imageUrl',
                    'testImageUrl',
                  ),
                ),
              ),
            ),
          ),
        );
        expect(
          tester.widget(columnFinder),
          isA<Column>().having(
            (column) => column.children,
            'children',
            isA<List<Widget>>().having(
              (children) => children[0],
              'clipRRect',
              isA<ClipRRect>().having(
                (clipRRect) => clipRRect.child,
                'Image',
                isA<Image>().having(
                  (img) => img.loadingBuilder,
                  'loadingBuilder',
                  isNotNull,
                ),
              ),
            ),
          ),
        );
      });
    });

    testWidgets('getCircularProgressWidget works properly', (tester) async {
      final mockContext = MockBuildContext();

      const messageBubble = MessageBubble(
        sender: 'testSender',
        text: '',
        imageUrl: 'testImageUrl',
        isMe: false,
      );

      const messageBubbleWidget = MaterialApp(
        home: Scaffold(
          body: messageBubble,
        ),
      );

      await mockNetworkImagesFor(() => tester.pumpWidget(messageBubbleWidget));

      final resultWhenLoadingProgressNotNull =
          messageBubble.getCircularProgressWidget(
        mockContext,
        const Text('testText'),
        const ImageChunkEvent(
            cumulativeBytesLoaded: 100, expectedTotalBytes: 1000),
      );

      final resultWhenLoadingProgressIsNull =
          messageBubble.getCircularProgressWidget(
        mockContext,
        const Text('testText'),
        null,
      );

      expect(
        resultWhenLoadingProgressNotNull,
        isA<Center>().having(
          (center) => center.child,
          'padding',
          isA<Padding>().having(
              (padding) => padding.child,
              'circular progress indicator',
              isA<CircularProgressIndicator>()
                  .having((cpi) => cpi.value, 'value', .1)),
        ),
      );

      expect(
        resultWhenLoadingProgressIsNull,
        isA<Text>().having(
          (text) => text.data,
          'data',
          'testText',
        ),
      );
    });
  });
}
