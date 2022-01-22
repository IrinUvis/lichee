import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

class CategoriesChannelsMockFirestore {
  static setUpMockFirestore(FakeFirebaseFirestore firestore) async {
    await firestore.collection('categories').doc('3wl3cGGwJxmoZs1WpHbH').set({
      'childrenIds': List.empty(),
      'isLastCategory': false,
      'name': 'Running',
      'parentId': '',
      'type': 'category'
    });

    await firestore.collection('categories').doc('9nWigKGjjN6gkbCGGIuy').set({
      'childrenIds': [
        'LGmmj4ZitURNSHHkhWqJ',
      ],
      'isLastCategory': false,
      'name': 'Football',
      'parentId': '',
      'type': 'category'
    });

    await firestore.collection('categories').doc('AItfHH3K5AklngNKoN4F').set({
      'childrenIds': ['NhjiLVTZXHjBG2tqngeT'],
      'isLastCategory': false,
      'name': 'Volleyball',
      'parentId': '',
      'type': 'category'
    });

    await firestore.collection('categories').doc('vPTJD1I65EM4t7MUCbEa').set({
      'childrenIds': ['XVj8VxZZLVAqEUQrlyff'],
      'isLastCategory': false,
      'name': 'Basketball',
      'parentId': '',
      'type': 'category'
    });

    await firestore.collection('categories').doc('LGmmj4ZitURNSHHkhWqJ').set({
      'childrenIds': ['jD6kkiJH2wD4e0E1k3G5', 'HFUptpYgbHNQNFod8Xdd'],
      'isLastCategory': true,
      'name': 'Match 3x3',
      'parentId': '9nWigKGjjN6gkbCGGIuy',
      'type': 'category'
    });

    await firestore.collection('categories').doc('NhjiLVTZXHjBG2tqngeT').set({
      'childrenIds': List.empty(),
      'isLastCategory': false,
      'name': 'Net discussions',
      'parentId': 'AItfHH3K5AklngNKoN4F',
      'type': 'category'
    });

    await firestore.collection('categories').doc('XVj8VxZZLVAqEUQrlyff').set({
      'childrenIds': List.empty(),
      'isLastCategory': false,
      'name': 'Basket discussions',
      'parentId': 'vPTJD1I65EM4t7MUCbEa',
      'type': 'category'
    });

    await firestore.collection('categories').doc('jD6kkiJH2wD4e0E1k3G5').set({
      'childrenIds': List.empty(),
      'isLastCategory': false,
      'name': 'Match in Lodz',
      'parentId': 'LGmmj4ZitURNSHHkhWqJ',
      'type': 'channel'
    });

    await firestore.collection('categories').doc('HFUptpYgbHNQNFod8Xdd').set({
      'childrenIds': List.empty(),
      'isLastCategory': false,
      'name': 'Match in Zgierz',
      'parentId': 'LGmmj4ZitURNSHHkhWqJ',
      'type': 'channel'
    });

    await firestore.collection('channels').doc('jD6kkiJH2wD4e0E1k3G5').set({
      'channelImageURL':
      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png',
      'channelName': 'Match in Lodz',
      'city': 'Lodz',
      'createdOn': DateTime.now(),
      'description': 'testDescriptionTestDescription',
      'ownerId': 'testUserId',
      'parentCategoryId': 'LGmmj4ZitURNSHHkhWqJ',
      'usersIds': List.empty(),
    });

    await firestore.collection('channels').doc('HFUptpYgbHNQNFod8Xdd').set({
      'channelImageURL':
      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png',
      'channelName': 'Match in Zgierz',
      'city': 'Zgierz',
      'createdOn': DateTime.now(),
      'description': 'testDescriptionTestDescription',
      'ownerId': 'testUserId',
      'parentCategoryId': 'LGmmj4ZitURNSHHkhWqJ',
      'usersIds': List.empty(),
    });
  }
}