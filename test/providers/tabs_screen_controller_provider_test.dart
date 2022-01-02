import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/providers/tabs_screen_controller_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tabs_screen_controller_provider_test.mocks.dart';

@GenerateMocks([PageController])
void main() {
  group('TabsScreenControllerProvider', () {
    final mockPageController = MockPageController();
    when(mockPageController.animateToPage(
      any,
      duration: anyNamed('duration'),
      curve: anyNamed('curve'),
    )).thenAnswer((_) async {});

    test('basics work correctly', () {
      final provider =
          TabsScreenControllerProvider(pageController: mockPageController);
      expect(provider.pages.length, 5);
      expect(provider.selectedPageIndex, 0);
      expect(provider.pageController, isNotNull);
    });

    test('selectProfilePage works correctly', () {
      final provider =
          TabsScreenControllerProvider(pageController: mockPageController);
      provider.selectProfilePage();
      expect(provider.selectedPageIndex, 4);
    });
  });
}
