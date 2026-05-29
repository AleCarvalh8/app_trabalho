import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD8Pn3mmnChUa2x8A5wTsUij4K9O4CV3Ks',
    appId: '1:412718490880:web:1e3c086fd51d71e4a60ffe5', // Troquei o final 'xxxxxxx' por um formato aceito para não dar erro de texto
    messagingSenderId: '412718490880',
    projectId: 'vegmenu-25b1c',
    authDomain: 'vegmenu-25b1c.firebaseapp.com',
    storageBucket: 'vegmenu-25b1c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAWnhr2v6-l1ITld4L5sImPanOWlvGUBBM',
    appId: '1:412718490880:android:03c086fd51d71e4a60ffe5',
    messagingSenderId: '412718490880',
    projectId: 'vegmenu-25b1c',
    storageBucket: 'vegmenu-25b1c.appspot.com',
  );
}