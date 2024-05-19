// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBCopSydJJo6nFj508SPDTRwTgs74Wj3BA',
    appId: '1:452192915558:web:4601d6a327538d42ca5da7',
    messagingSenderId: '452192915558',
    projectId: 'pokedexapp-b6006',
    authDomain: 'pokedexapp-b6006.firebaseapp.com',
    storageBucket: 'pokedexapp-b6006.appspot.com',
    measurementId: 'G-Z1JXQMJECB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBMyGJeOLtH_zPO72gig2QLxRT8aoRsKGg',
    appId: '1:452192915558:android:d13266008dc1339aca5da7',
    messagingSenderId: '452192915558',
    projectId: 'pokedexapp-b6006',
    storageBucket: 'pokedexapp-b6006.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB51fIX20U3BKnU4PyW7gbxqYEjvWfOTes',
    appId: '1:452192915558:ios:ceded5c9ef2c252aca5da7',
    messagingSenderId: '452192915558',
    projectId: 'pokedexapp-b6006',
    storageBucket: 'pokedexapp-b6006.appspot.com',
    iosBundleId: 'com.example.pokedex.RunnerTests',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB51fIX20U3BKnU4PyW7gbxqYEjvWfOTes',
    appId: '1:452192915558:ios:4d59e8025c6cf34aca5da7',
    messagingSenderId: '452192915558',
    projectId: 'pokedexapp-b6006',
    storageBucket: 'pokedexapp-b6006.appspot.com',
    iosBundleId: 'com.example.pokedex',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBCopSydJJo6nFj508SPDTRwTgs74Wj3BA',
    appId: '1:452192915558:web:7b609bcaaee8b19cca5da7',
    messagingSenderId: '452192915558',
    projectId: 'pokedexapp-b6006',
    authDomain: 'pokedexapp-b6006.firebaseapp.com',
    storageBucket: 'pokedexapp-b6006.appspot.com',
    measurementId: 'G-JJB8PSFY42',
  );

}